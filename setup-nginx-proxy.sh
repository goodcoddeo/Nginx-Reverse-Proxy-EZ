#!/bin/bash

echo "Nginx Reverse Proxy 자동 설정기"
echo "Made by @goodcoddeo" 

echo "1. Original (직접 연결)"
echo "2. CF Proxied (Cloudflare 프록시 사용)"
read -p "선택 (1 또는 2): " type

read -p "포트 번호를 입력하세요 (예: 3000): " port
read -p "도메인을 입력하세요 (예: example.com): " domain

server_ip=$(curl -s ifconfig.me)

domain_ip=$(dig +short "$domain" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n1)

echo ""
echo "📌 도메인 설정 안내:"
echo "$domain 의 A 레코드를 아래 IP로 설정해주세요:"
echo "❗ CF Proxied라면 프록시를 체크해주세요!"
echo ""
echo "👉 $domain A $server_ip"

echo "➡️  $domain A $domain_ip (현재 가르키는 IP)"


if [[ -z "$domain_ip" ]]; then
    echo "❌ $domain A 레코드에 등록된 IP가 없습니다."
elif [[ "$type" == "1" ]]; then
    if [[ "$domain_ip" == "$server_ip" ]]; then
        echo "⚡ $domain A 레코드가 일치합니다."
    else
        echo "⚠️  $domain A 레코드가 서버 IP와 일치하지 않습니다."
        echo "➡️  도메인: $domain_ip"
        echo "➡️  서버  : $server_ip"
    fi
fi
echo ""
read -p "설정이 완료되었다면 'Y'을 입력하세요: " confirm

if [[ "$confirm" != "Y" ]]; then
    echo "⚠️ 'Y'가 입력되지 않았습니다. 스크립트를 종료합니다."
    exit 1
fi

domain_ip=$(dig +short "$domain" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n1)

if [[ -z "$domain_ip" ]]; then
    echo "❌ 도메인에서 IP를 가져오지 못했습니다. DNS가 제대로 설정되었는지 확인하세요."
    exit 1
fi

echo "🔎 도메인 $domain 이 현재 가리키는 IP: $domain_ip"

function ip_in_cidr() {
    local ip=$1
    local cidr=$2

    local ip_dec=$(ip_to_decimal "$ip")
    IFS=/ read base_ip range <<< "$cidr"
    local base_dec=$(ip_to_decimal "$base_ip")
    local mask=$(( 0xFFFFFFFF << (32 - range) & 0xFFFFFFFF ))

    if (( (ip_dec & mask) == (base_dec & mask) )); then
        return 0
    else
        return 1
    fi
}

function ip_to_decimal() {
    local IFS=.
    read -r o1 o2 o3 o4 <<< "$1"
    echo $(( (o1 << 24) + (o2 << 16) + (o3 << 8) + o4 ))
}

if [ "$type" == "1" ]; then
    if [ "$domain_ip" == "$server_ip" ]; then
        echo "✅ 도메인이 현재 서버 IP를 정확히 가리키고 있습니다."
    else
        echo "❌ 도메인이 현재 서버 IP($server_ip)를 가리키지 않습니다. DNS 설정을 확인하세요."
        exit 1
    fi
elif [ "$type" == "2" ]; then
    cf_cidrs=(
        "173.245.48.0/20"
        "103.21.244.0/22"
        "103.22.200.0/22"
        "103.31.4.0/22"
        "141.101.64.0/18"
        "108.162.192.0/18"
        "190.93.240.0/20"
        "188.114.96.0/20"
        "197.234.240.0/22"
        "198.41.128.0/17"
        "162.158.0.0/15"
        "104.16.0.0/13"
        "104.24.0.0/14"
        "172.64.0.0/13"
        "131.0.72.0/22"
    )

    is_cf_ip=false
    for cidr in "${cf_cidrs[@]}"; do
        if ip_in_cidr "$domain_ip" "$cidr"; then
            is_cf_ip=true
            break
        fi
    done

    if $is_cf_ip; then
        echo "✅ 도메인이 Cloudflare 프록시 IP를 가리키고 있습니다."
    else
        echo "❌ 도메인이 Cloudflare IP가 아닙니다. CF 프록시 상태인지 확인하세요."
        exit 1
    fi
else
    echo "❌ 잘못된 타입입니다."
    exit 1
fi

config_path="/etc/nginx/sites-available/$domain"

if [ "$type" == "1" ]; then
    cat > "$config_path" <<EOL
server {
    listen 80;
    server_name $domain;

    location / {
        proxy_pass http://127.0.0.1:$port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL
elif [ "$type" == "2" ]; then
    cat > "$config_path" <<EOL
server {
    listen 80;
    server_name $domain;

    location / {
        proxy_pass http://127.0.0.1:$port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$http_cf_connecting_ip;
        proxy_set_header X-Forwarded-For \$http_cf_connecting_ip;
    }
}
EOL
else
    echo "잘못된 선택입니다. 스크립트를 종료합니다."
    exit 1
fi

ln -s "$config_path" /etc/nginx/sites-enabled/

echo ""
echo "🔍 nginx 설정 테스트 중..."
nginx -t

if [ $? -eq 0 ]; then
    echo "🔄 nginx 재시작 중..."
    systemctl reload nginx
    echo "✅ Nginx 설정이 성공적으로 적용되었습니다!"
    echo "🌐 도메인: http://$domain -> http://127.0.0.1:$port"
else
    echo "❌ nginx 설정 오류 발생. 설정 파일을 확인하세요: $config_path"
fi
