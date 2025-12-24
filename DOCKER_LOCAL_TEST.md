# 🧪 Test Docker Locally (Trước khi deploy lên Render)

## 📋 Yêu cầu
- Docker Desktop đã cài đặt
- Docker Compose đã cài đặt

---

## 🚀 Bước 1: Build và chạy containers

### 1.1. Mở Terminal/PowerShell tại thư mục dự án
```bash
cd d:\Downloads\DOAN_WEB2\DOAN_WEB2
```

### 1.2. Build và start containers
```bash
docker-compose up -d --build
```

**Giải thích:**
- `up`: Khởi động containers
- `-d`: Chạy ở background (detached mode)
- `--build`: Build lại image nếu có thay đổi

### 1.3. Kiểm tra containers đang chạy
```bash
docker-compose ps
```

Bạn sẽ thấy 3 containers:
- `bookstore_web` (port 8080)
- `bookstore_db` (port 3306)
- `bookstore_phpmyadmin` (port 8081)

---

## 🌐 Bước 2: Truy cập ứng dụng

### 2.1. Website
- URL: http://localhost:8080/PHP/trangchu.php

### 2.2. phpMyAdmin (quản lý database)
- URL: http://localhost:8081
- Username: `root`
- Password: `root123`

---

## 🔍 Bước 3: Kiểm tra logs

### 3.1. Xem logs của web container
```bash
docker-compose logs -f web
```

### 3.2. Xem logs của database
```bash
docker-compose logs -f db
```

**Tip:** Nhấn `Ctrl+C` để thoát

---

## 🛠️ Bước 4: Debugging

### 4.1. Vào shell của web container
```bash
docker exec -it bookstore_web bash
```

Sau đó bạn có thể:
```bash
# Xem cấu trúc thư mục
ls -la /var/www/html

# Kiểm tra PHP version
php -v

# Test kết nối database
php -r "echo new mysqli('db', 'root', 'root123', 'WEB2_BookStore') ? 'OK' : 'Failed';"
```

### 4.2. Vào MySQL shell
```bash
docker exec -it bookstore_db mysql -uroot -proot123 WEB2_BookStore
```

Sau đó:
```sql
-- Xem các bảng
SHOW TABLES;

-- Xem dữ liệu
SELECT * FROM USER;
SELECT * FROM SACH LIMIT 5;

-- Thoát
EXIT;
```

---

## 🔄 Bước 5: Thay đổi code

### 5.1. Sửa code PHP
- Sửa file bất kỳ trong thư mục dự án
- **Không cần restart container** (do volume mount)
- Refresh browser để thấy thay đổi

### 5.2. Sửa Dockerfile
- Sau khi sửa `Dockerfile`
- Phải rebuild:
```bash
docker-compose up -d --build
```

### 5.3. Sửa database
- Vào phpMyAdmin: http://localhost:8081
- Hoặc dùng MySQL shell (xem bước 4.2)

---

## 🛑 Bước 6: Dừng và xóa containers

### 6.1. Dừng containers (giữ data)
```bash
docker-compose stop
```

### 6.2. Dừng và xóa containers (giữ data)
```bash
docker-compose down
```

### 6.3. Xóa tất cả (bao gồm data)
```bash
docker-compose down -v
```

**⚠️ Cảnh báo:** `-v` sẽ xóa cả database volume!

---

## ✅ Checklist trước khi deploy lên Render

- [ ] Website chạy OK trên http://localhost:8080
- [ ] Đăng nhập thành công
- [ ] Thêm sách vào giỏ hàng
- [ ] Đặt hàng thành công
- [ ] Admin panel hoạt động
- [ ] Database có đủ dữ liệu
- [ ] Không có lỗi trong logs
- [ ] File `db_connect.php` đã cập nhật (hỗ trợ env vars)

---

## 🐛 Troubleshooting

### Lỗi: "Port already in use"
```bash
# Kiểm tra port nào đang dùng
netstat -ano | findstr :8080

# Đổi port trong docker-compose.yml
ports:
  - "9090:80"  # Thay 8080 thành 9090
```

### Lỗi: "Database connection failed"
```bash
# Kiểm tra db container đang chạy
docker-compose ps

# Xem logs database
docker-compose logs db

# Restart database
docker-compose restart db
```

### Lỗi: "Permission denied"
```bash
# Trên Windows, chạy Docker Desktop as Administrator
# Hoặc thêm quyền cho thư mục:
icacls "d:\Downloads\DOAN_WEB2\DOAN_WEB2" /grant Everyone:F
```

### Website hiển thị lỗi PHP
```bash
# Vào container và check PHP error log
docker exec -it bookstore_web bash
tail -f /var/log/apache2/error.log
```

---

## 📊 Monitoring

### Xem resource usage
```bash
docker stats
```

### Xem disk usage
```bash
docker system df
```

---

## 🎯 Tips

1. **Development workflow:**
   ```bash
   # Lần đầu
   docker-compose up -d --build
   
   # Sau đó chỉ cần
   docker-compose up -d
   
   # Khi xong việc
   docker-compose stop
   ```

2. **Backup database:**
   ```bash
   docker exec bookstore_db mysqldump -uroot -proot123 WEB2_BookStore > backup.sql
   ```

3. **Restore database:**
   ```bash
   docker exec -i bookstore_db mysql -uroot -proot123 WEB2_BookStore < backup.sql
   ```

4. **Clean up:**
   ```bash
   # Xóa tất cả containers, images, volumes không dùng
   docker system prune -a --volumes
   ```

---

**Sau khi test OK trên local, bạn có thể tự tin deploy lên Render! 🚀**
