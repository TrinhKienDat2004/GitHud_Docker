# Hướng dẫn chi tiết: Push image lên Docker Hub và chạy web

---

## PHẦN 1: Chuẩn bị trên trang Docker Hub (trình duyệt)

### Bước 1.1: Đăng ký / đăng nhập Docker Hub

- **Ở đâu:** Trình duyệt, mở https://hub.docker.com  
- **Làm gì:**
  - Chưa có tài khoản: bấm **Sign Up** → tạo tài khoản (email + mật khẩu).
  - Đã có tài khoản: bấm **Sign In** → đăng nhập.
- **Nhớ:** Username Docker Hub (ví dụ: `trinhkiendat`) — dùng ở bước sau.

---

### Bước 1.2: Tạo Repository (nơi chứa image)

- **Ở đâu:** Trang Docker Hub, sau khi đăng nhập.
- **Làm gì:**
  1. Bấm **Create Repository** (hoặc Repositories → **Create**).
  2. **Repository Name:** gõ `trinhkiendat-app-java` (hoặc tên khác, ví dụ `duanmoi`).
  3. **Visibility:** chọn **Public**.
  4. Bấm **Create**.
- **Kết quả:** Bạn có repo dạng: `TEN_TAI_KHOAN/trinhkiendat-app-java`  
  Ví dụ: `trinhkiendat/trinhkiendat-app-java`.

---

## PHẦN 2: Trên máy tính của bạn (PowerShell / Terminal)

**Ở đâu:** Mở terminal (PowerShell hoặc CMD) **ngay trong thư mục project**:

```
D:\DuAnMonHoc_4MonC\CC&MTPTPM\trinhkiendat
```

(Có thể mở từ VS Code/Cursor: **Terminal → New Terminal** — đảm bảo đường dẫn hiện ra là thư mục có file `docker-compose.yml`.)

---

### Bước 2.1: Đăng nhập Docker từ máy

- **Lệnh (chạy trong terminal):**
  ```powershell
  docker login
  ```
- **Làm gì:**  
  Khi được hỏi:
  - **Username:** gõ đúng tên tài khoản Docker Hub (ví dụ `trinhkiendat`).
  - **Password:** gõ mật khẩu (hoặc Personal Access Token nếu bật 2FA).
- **Thành công:** Thấy dòng `Login Succeeded`.

---

### Bước 2.2: Kiểm tra image cần push

- **Lệnh:**
  ```powershell
  docker images
  ```
- **Cần thấy:** Dòng có tên **trinhkiendat-app-java** và tag **latest** (cột REPOSITORY và TAG).  
  Nếu không thấy, chạy lại `docker-compose up --build` một lần để tạo image.

---

### Bước 2.3: Gắn tag cho image (theo tên repo Docker Hub)

- **Cú pháp:**  
  `docker tag TÊN_IMAGE_LOCAL:TAG TÊN_TAI_KHOAN/TÊN_REPO:TAG`
- **Ví dụ** (thay `trinhkiendat` bằng username Docker Hub của bạn):
  ```powershell
  docker tag trinhkiendat-app-java:latest trinhkiendat/trinhkiendat-app-java:latest
  ```
- **Ở đâu:** Cùng terminal, thư mục project (không cần cd gì thêm).

---

### Bước 2.4: Push image lên Docker Hub

- **Lệnh (đổi username cho đúng):**
  ```powershell
  docker push trinhkiendat/trinhkiendat-app-java:latest
  ```
- **Ở đâu:** Cùng terminal.
- **Chờ:** Upload xong (vài phút tùy mạng).  
- **Kiểm tra:** Vào https://hub.docker.com → Repositories → mở repo vừa tạo → tab **Tags**: thấy tag **latest** và thời gian push.

---

## PHẦN 3: Chạy web từ Docker Hub (máy khác hoặc máy mới)

**Mục đích:** Máy không có source code, chỉ cần Docker + file compose để kéo image từ Docker Hub và chạy web.

---

### Bước 3.1: Tạo thư mục và file docker-compose

- **Ở đâu:** Máy muốn chạy web (có cài Docker Desktop).
- **Làm gì:**
  1. Tạo một thư mục, ví dụ: `D:\cv-app` (hoặc bất kỳ đường dẫn nào).
  2. Trong thư mục đó tạo file tên **docker-compose.yml** với nội dung bên dưới.

**Nội dung file docker-compose.yml** (thay `trinhkiendat` bằng username Docker Hub của bạn):

```yaml
version: "3.8"

services:
  app-java:
    image: trinhkiendat/trinhkiendat-app-java:latest
    container_name: cv-springboot-app
    ports:
      - "8080:8080"
    depends_on:
      db-mysql:
        condition: service_healthy
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://db-mysql:3306/cv_profile_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root
    restart: always

  db-mysql:
    image: mysql:8.0
    container_name: cv-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: cv_profile_db
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-proot"]
      interval: 5s
      timeout: 5s
      retries: 10
      start_period: 30s

volumes:
  db_data:
```

---

### Bước 3.2: Chạy ứng dụng

- **Ở đâu:** Terminal, **trong đúng thư mục chứa file docker-compose.yml** (ví dụ `D:\cv-app`).
- **Lệnh:**
  ```powershell
  cd D:\cv-app
  docker-compose up -d
  ```
  (Nếu bạn đặt thư mục ở chỗ khác thì `cd` vào đúng đường dẫn đó.)
- **Chờ:** Docker kéo image từ Hub (lần đầu sẽ tải xuống), rồi chạy app + MySQL.

---

### Bước 3.3: Mở web

- **Ở đâu:** Trình duyệt trên cùng máy đó.
- **Địa chỉ:** http://localhost:8080  
- **Kết quả:** Trang CV hiển thị.

---

## Tóm tắt nhanh

| Việc | Ở đâu | Lệnh / Hành động |
|------|--------|-------------------|
| Đăng ký / đăng nhập | Trình duyệt → hub.docker.com | Sign Up / Sign In |
| Tạo repo | Docker Hub → Create Repository | Tên: `trinhkiendat-app-java`, Public |
| Đăng nhập Docker | Terminal (thư mục project) | `docker login` |
| Tag image | Cùng terminal | `docker tag trinhkiendat-app-java:latest USER/trinhkiendat-app-java:latest` |
| Push image | Cùng terminal | `docker push USER/trinhkiendat-app-java:latest` |
| Chạy web từ Hub | Máy khác: tạo thư mục + file docker-compose.yml | `docker-compose up -d` → mở http://localhost:8080 |

**Lưu ý:** Mọi chỗ có `USER` hoặc `trinhkiendat` trong ví dụ, thay bằng **đúng username Docker Hub** của bạn.
