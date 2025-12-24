# 🚀 Hướng dẫn Deploy lên Render.com

## 📋 Yêu cầu
- Tài khoản GitHub (miễn phí)
- Tài khoản Render.com (miễn phí)
- Git đã cài đặt trên máy

---

## 🔧 Bước 1: Chuẩn bị Git Repository

### 1.1. Tạo file `.gitignore`
```bash
.env
.DS_Store
*.log
.vscode
.idea
```

### 1.2. Khởi tạo Git và push lên GitHub
```bash
# Di chuyển vào thư mục dự án
cd d:\Downloads\DOAN_WEB2\DOAN_WEB2

# Khởi tạo Git
git init

# Thêm tất cả file
git add .

# Commit
git commit -m "Initial commit - BookStore project"

# Tạo repository trên GitHub (https://github.com/new)
# Sau đó link và push:
git remote add origin https://github.com/YOUR_USERNAME/bookstore.git
git branch -M main
git push -u origin main
```

---

## 🗄️ Bước 2: Tạo MySQL Database trên Render

### 2.1. Đăng nhập Render.com
- Truy cập: https://render.com
- Đăng ký/Đăng nhập bằng GitHub

### 2.2. Tạo MySQL Database
1. Click **"New +"** → **"MySQL"**
2. Điền thông tin:
   - **Name**: `bookstore-db`
   - **Database**: `WEB2_BookStore`
   - **User**: `bookstore_user`
   - **Region**: `Singapore` (gần Việt Nam nhất)
   - **Plan**: **Free** (512MB RAM, 1GB Storage)
3. Click **"Create Database"**

### 2.3. Lấy thông tin kết nối
Sau khi tạo xong, Render sẽ cung cấp:
- **Internal Database URL**: `mysql://user:pass@host:port/dbname`
- **External Database URL**: Dùng để kết nối từ ngoài
- **Hostname**, **Port**, **Username**, **Password**

### 2.4. Import Database
**Cách 1: Dùng MySQL Workbench/phpMyAdmin**
1. Kết nối đến database bằng thông tin External URL
2. Import file `database/WEB2_BookStore.sql`

**Cách 2: Dùng MySQL CLI**
```bash
mysql -h <hostname> -P <port> -u <username> -p<password> WEB2_BookStore < database/WEB2_BookStore.sql
```

---

## 🌐 Bước 3: Deploy Web Service

### 3.1. Tạo Web Service
1. Click **"New +"** → **"Web Service"**
2. Chọn **"Build and deploy from a Git repository"**
3. Connect GitHub repository của bạn
4. Chọn repository `bookstore`

### 3.2. Cấu hình Service
Điền thông tin:
- **Name**: `bookstore-web`
- **Region**: `Singapore`
- **Branch**: `main`
- **Root Directory**: `.` (để trống)
- **Runtime**: **Docker**
- **Plan**: **Free** (512MB RAM, 400 build hours/month)

### 3.3. Thêm Environment Variables
Scroll xuống **Environment Variables**, thêm:

| Key | Value |
|-----|-------|
| `DATABASE_URL` | `mysql://user:pass@host:port/WEB2_BookStore` (copy từ Internal Database URL) |
| `DB_HOST` | `<hostname từ database>` |
| `DB_USER` | `bookstore_user` |
| `DB_PASSWORD` | `<password từ database>` |
| `DB_NAME` | `WEB2_BookStore` |

### 3.4. Deploy
1. Click **"Create Web Service"**
2. Render sẽ tự động:
   - Clone repository
   - Build Docker image
   - Deploy container
   - Cấp domain miễn phí: `https://bookstore-web.onrender.com`

---

## ✅ Bước 4: Kiểm tra

### 4.1. Truy cập website
- URL: `https://bookstore-web.onrender.com/PHP/trangchu.php`

### 4.2. Test các tính năng
- [ ] Đăng nhập (Admin: `Le Van C` / `123`)
- [ ] Xem danh sách sách
- [ ] Thêm vào giỏ hàng
- [ ] Đặt hàng
- [ ] Quản lý đơn hàng (Admin)

---

## 🔄 Bước 5: Cập nhật code (sau này)

Mỗi khi sửa code:
```bash
git add .
git commit -m "Update: mô tả thay đổi"
git push
```

Render sẽ **tự động deploy lại** (Auto-deploy)!

---

## ⚠️ Lưu ý quan trọng

### 1. **Free Plan Limitations**
- Web service sẽ **sleep sau 15 phút không hoạt động**
- Lần đầu truy cập sau khi sleep sẽ mất ~30 giây để wake up
- Database: 1GB storage, 512MB RAM
- 400 build hours/tháng

### 2. **Đường dẫn file**
Render deploy ở root `/var/www/html`, nên:
- Đường dẫn ảnh: `../Picture/Products/...` → OK ✅
- Đường dẫn CSS: `../CSS/...` → OK ✅

### 3. **Bảo mật**
- Đổi mật khẩu admin mặc định (`123`)
- Không commit file `.env` lên Git
- Dùng HTTPS (Render cung cấp SSL miễn phí)

### 4. **Performance**
- Nếu website chậm, xem xét:
  - Optimize query SQL (thêm index)
  - Cache kết quả
  - Nâng cấp lên Starter Plan ($7/tháng - không sleep)

---

## 🆘 Troubleshooting

### Lỗi: "Database connection failed"
- Kiểm tra `DATABASE_URL` trong Environment Variables
- Đảm bảo database đã import xong
- Check logs: Dashboard → Logs

### Lỗi: "404 Not Found"
- Kiểm tra đường dẫn: `/PHP/trangchu.php`
- Xem file structure trong container: Dashboard → Shell

### Website quá chậm
- Free plan có giới hạn, đợi 30s lần đầu
- Xem xét upgrade plan

---

## 💰 So sánh với các hosting khác

| Tiêu chí | Render Free | InfinityFree | Hostinger |
|----------|-------------|--------------|-----------|
| **Giá** | $0 | $0 | ~60k/tháng |
| **Docker** | ✅ | ❌ | ❌ |
| **Auto Deploy** | ✅ | ❌ | ❌ |
| **SSL** | ✅ Free | ✅ Free | ✅ Free |
| **Sleep** | Sau 15 phút | Không | Không |
| **Database** | MySQL/PostgreSQL | MySQL | MySQL |
| **Tốc độ** | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Phù hợp** | Demo, Portfolio | Test | Production |

---

## 🎯 Kết luận

**Render.com** là lựa chọn tốt nhất cho:
- ✅ Dự án học tập/đồ án
- ✅ Portfolio/Demo
- ✅ Muốn học Docker
- ✅ Auto-deploy từ Git

**Không phù hợp cho:**
- ❌ Website thương mại (do sleep)
- ❌ Traffic cao (giới hạn 400 build hours)

---

## 📚 Tài liệu tham khảo
- Render Docs: https://render.com/docs
- Docker Docs: https://docs.docker.com
- MySQL on Render: https://render.com/docs/databases

---

**Chúc bạn deploy thành công! 🎉**

Nếu gặp vấn đề, hãy check logs hoặc liên hệ support Render (rất responsive).
