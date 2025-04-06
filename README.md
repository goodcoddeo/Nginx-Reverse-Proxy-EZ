🇰🇷 Nginx 리버스 프록시 자동 설정 스크립트 — DNS 확인부터 설정파일 생성, 적용까지 한 번에! <br>
🌐 Easy Nginx Reverse Proxy Setup — From DNS check to config & reload, fully automated! <br>

Page -> https://goodcoddeo.github.io/Nginx-Reverse-Proxy-EZ/

---

```md
# 🌐 Nginx Reverse Proxy Ez

`setup-nginx-proxy.sh` is a shell script that automates the entire process of setting up an Nginx reverse proxy.  
No more manual editing in `/etc/nginx/sites-available/` and linking files — just run the script and follow the steps!

---

## 📦 Features

- ✅ Supports both direct and Cloudflare proxied connections
- ✅ Checks if the domain's A record matches the current server IP
- ✅ Automatically creates and enables Nginx site config
- ✅ Tests and reloads Nginx with the new settings
- ✅ DNS guidance with clear prompts and instructions

---

## 🛠️ Installation & Usage

```bash
chmod +x setup-nginx-proxy.sh
./setup-nginx-proxy.sh
```

---

## 🧭 Step-by-step Flow

1. **Choose connection type**
   - `1`: Original (Direct IP)
   - `2`: Cloudflare Proxied

2. **Enter port and domain**
   - Example: `3000`, `example.com`

3. **DNS guidance**
   - Check if the domain's A record matches your server IP
   - Warn if mismatch or if CF proxy isn't active

4. **Nginx config auto-generation**
   - Creates file in `/etc/nginx/sites-available/`
   - Links it to `/etc/nginx/sites-enabled/`

5. **Apply the config**
   - Runs `nginx -t` and reloads on success

---

## 🌩️ Example

```
Choose type (1 or 2): 2
Port number (e.g. 3000): 3000
Domain (e.g. example.com): my.site.com
...
✅ Domain points to Cloudflare proxy IP
✅ Nginx config applied successfully!
🌐 http://example.com -> http://127.0.0.1:3000
```

---

## ⚠️ Notes

- Designed for **Ubuntu-based systems**
- Assumes Nginx uses `/sites-available/` and `/sites-enabled/`
- Script exits if DNS settings are not valid

---

## 🧪 Requirements

- `nginx`
- `dig` (DNS lookup tool — part of `dnsutils`)
- `curl`

Install via:

```bash
sudo apt update
sudo apt install nginx dnsutils curl
```

---

## 📄 License

MIT License.

---

---

# 🇰🇷 Nginx Reverse Proxy Ez

`setup-nginx-proxy.sh`는 Nginx 리버스 프록시 설정을 자동화하는 셸 스크립트입니다.  
`/etc/nginx/sites-available/`에서 직접 설정 파일을 만들고, 심볼릭 링크를 걸고, 테스트하고 리로드하는 복잡한 과정은 이제 그만!  
스크립트를 실행하고 안내에 따라 입력만 하면 자동으로 설정됩니다.

---

## 📦 주요 기능

- ✅ 직접 연결 및 Cloudflare 프록시 연결 모두 지원
- ✅ 도메인의 A 레코드가 서버 IP와 일치하는지 검사
- ✅ Nginx 설정 파일 자동 생성 및 활성화
- ✅ 설정 테스트 후 nginx 자동 리로드
- ✅ DNS 설정 가이드 제공

---

## 🛠️ 설치 및 사용법

```bash
chmod +x setup-nginx-proxy.sh
./setup-nginx-proxy.sh
```

---

## 🧭 사용 흐름

1. **연결 방식 선택**
   - `1`: Original (직접 연결)
   - `2`: Cloudflare 프록시 사용

2. **포트와 도메인 입력**
   - 예: `3000`, `example.com`

3. **DNS 설정 안내**
   - 도메인의 A 레코드가 서버 IP와 일치하는지 확인
   - CF 모드인 경우 Cloudflare IP 대역인지 검사

4. **Nginx 설정 자동 생성**
   - `/etc/nginx/sites-available/`에 설정 파일 생성
   - `/etc/nginx/sites-enabled/`에 링크 생성

5. **설정 적용**
   - `nginx -t` 테스트 후 자동 리로드

---

## 🌩️ 예시

```
선택 (1 또는 2): 2
포트 번호: 3000
도메인: my.site.com
...
✅ 도메인이 Cloudflare 프록시 IP를 가리키고 있습니다.
✅ Nginx 설정이 성공적으로 적용되었습니다!
🌐 http://example.com -> http://127.0.0.1:3000
```

---

## ⚠️ 주의사항

- **Ubuntu 계열 리눅스**에서 사용하도록 설계되었습니다.
- Nginx가 `/sites-available/`, `/sites-enabled/` 구조를 사용할 때 정상 동작합니다.
- DNS 설정이 올바르지 않으면 스크립트가 중단됩니다.

---

## 🧪 필요 패키지

- `nginx`
- `dig` (`dnsutils` 패키지)
- `curl`

설치 방법:

```bash
sudo apt update
sudo apt install nginx dnsutils curl
```

---

## 📄 라이선스

MIT License.

---
```

---
