# 📚 WEB2 BookStore - Hệ thống quản lý cửa hàng sách

## 📖 Giới thiệu
Website bán sách trực tuyến được xây dựng bằng PHP thuần và MySQL, hỗ trợ quản lý sách, đơn hàng, giỏ hàng, bảo hành và phân quyền người dùng.

## ✨ Tính năng chính

### 👥 Người dùng
- Đăng ký/Đăng nhập tài khoản
- Xem danh sách sách theo danh mục
- Tìm kiếm sách
- Thêm sách vào giỏ hàng
- Đặt hàng và thanh toán
- Xem lịch sử đơn hàng
- Gửi yêu cầu bảo hành
- Đánh giá sách (feedback)

### 🔧 Admin
- Quản lý sách (CRUD)
- Quản lý danh mục sách
- Quản lý người dùng
- Quản lý đơn hàng
- Quản lý đơn bảo hành
- Xem thống kê

## 🛠️ Công nghệ sử dụng

### Backend
- **PHP 8.1+** - Server-side scripting
- **MySQL 8.0** - Database
- **Apache** - Web server

### Frontend
- **HTML5/CSS3** - Structure & Styling
- **JavaScript** - Client-side logic
- **Bootstrap** (nếu có) - Responsive design

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Git** - Version control
- **Render.com** - Cloud deployment

## 📁 Cấu trúc dự án

```
DOAN_WEB2/
├── CSS/                    # Stylesheets
├── PHP/                    # PHP files
│   ├── db_connect.php     # Database connection
│   ├── trangchu.php       # Homepage
│   ├── admin.php          # Admin dashboard
│   ├── giohang.php        # Shopping cart
│   ├── thanhtoan.php      # Checkout
│   └── ...
├── Picture/               # Images
│   └── Products/          # Product images
├── js/                    # JavaScript files
├── database/              # Database files
│   └── WEB2_BookStore.sql # Database schema & data
├── icon/                  # Icons
├── Dockerfile             # Docker configuration
├── docker-compose.yml     # Docker Compose config
└── README.md              # This file
```

## 🗄️ Database Schema

### Các bảng chính:
- **USER** - Thông tin người dùng (Admin/KhachHang)
- **SACH** - Thông tin sách
- **LOAISACH** - Danh mục sách
- **GIOHANG** - Giỏ hàng
- **DONHANG** - Đơn hàng
- **CHITIETDONHANG** - Chi tiết đơn hàng
- **CHITIETSACH** - Chi tiết từng bản sách (tracking)
- **DONBAOHANH** - Đơn bảo hành
- **FEEDBACK** - Đánh giá sách

## 🚀 Hướng dẫn cài đặt

### Cách 1: Chạy trên Local (XAMPP/WAMP)

1. **Cài đặt XAMPP/WAMP**
   - Download: https://www.apachefriends.org

2. **Copy dự án vào htdocs**
   ```bash
   # Windows (XAMPP)
   copy DOAN_WEB2 C:\xampp\htdocs\
   
   # Mac (MAMP)
   copy DOAN_WEB2 /Applications/MAMP/htdocs/
   ```

3. **Import database**
   - Mở phpMyAdmin: http://localhost/phpmyadmin
   - Tạo database: `WEB2_BookStore`
   - Import file: `database/WEB2_BookStore.sql`

4. **Truy cập website**
   - URL: http://localhost/DOAN_WEB2/PHP/trangchu.php

### Cách 2: Chạy bằng Docker (Khuyến nghị)

1. **Cài đặt Docker Desktop**
   - Download: https://www.docker.com/products/docker-desktop

2. **Build và chạy containers**
   ```bash
   cd DOAN_WEB2
   docker-compose up -d --build
   ```

3. **Truy cập website**
   - Website: http://localhost:8080/PHP/trangchu.php
   - phpMyAdmin: http://localhost:8081

4. **Xem logs**
   ```bash
   docker-compose logs -f
   ```

5. **Dừng containers**
   ```bash
   docker-compose down
   ```

**📖 Chi tiết:** Xem file [DOCKER_LOCAL_TEST.md](DOCKER_LOCAL_TEST.md)

### Cách 3: Deploy lên Render.com + TiDB Cloud (Production - Miễn phí)

**📖 Chi tiết:** Xem file [DEPLOY_RENDER.md](DEPLOY_RENDER.md)

**Stack:**
- **Web Server:** Render.com (Free - Docker)
- **Database:** TiDB Cloud (Free - MySQL-compatible, 5GB)

**Tóm tắt:**
1. Tạo TiDB Cloud cluster (MySQL-compatible)
2. Import database vào TiDB
3. Push code lên GitHub
4. Tạo Web Service trên Render từ GitHub repo
5. Thêm DATABASE_URL từ TiDB vào Render environment variables
6. Deploy tự động!

**Ưu điểm:**
- ✅ Hoàn toàn miễn phí
- ✅ MySQL native (không cần migrate)
- ✅ Auto-deploy từ Git
- ✅ SSL miễn phí
- ✅ Professional setup

**Nhược điểm:**
- ⚠️ Sleep sau 15 phút (web) và 1 giờ (database)
- ⚠️ Cold start ~30-60s

**Phù hợp cho:** Đồ án, Portfolio, Demo

### Admin
- **Username:** Le Van C
- **Password:** 123

### Khách hàng
- **Username:** Nguyen Van A
- **Password:** pass123

**⚠️ Lưu ý:** Đổi mật khẩu sau khi deploy production!

## 🔧 Cấu hình

### Environment Variables

Dự án hỗ trợ 3 môi trường:

1. **Local (XAMPP/WAMP)**
   - Tự động dùng `localhost`, `root`, `""`, `WEB2_BookStore`

2. **Docker**
   - Đọc từ `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
   - Cấu hình trong `docker-compose.yml`

3. **Render.com**
   - Đọc từ `DATABASE_URL`
   - Tự động parse connection string

### Sửa file `.env` (nếu cần)
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=root123
DB_NAME=WEB2_BookStore
```

## 📊 API Endpoints (nếu có)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| GET | `/PHP/trangchu.php` | Trang chủ |
| GET | `/PHP/category.php?id=1` | Sách theo danh mục |
| POST | `/PHP/add_to_cart.php` | Thêm vào giỏ |
| GET | `/PHP/giohang.php` | Xem giỏ hàng |
| POST | `/PHP/thanhtoan.php` | Thanh toán |
| GET | `/PHP/admin.php` | Admin dashboard |

## 🧪 Testing

### Test local với Docker
```bash
# Build và chạy
docker-compose up -d --build

# Xem logs
docker-compose logs -f web

# Test database connection
docker exec -it bookstore_db mysql -uroot -proot123 -e "SHOW DATABASES;"

# Dừng
docker-compose down
```

### Test trên Render
1. Truy cập URL: `https://your-app.onrender.com/PHP/trangchu.php`
2. Đăng nhập
3. Test các chức năng chính

## 🐛 Troubleshooting

### Lỗi: "Database connection failed"
- Kiểm tra thông tin database trong `db_connect.php`
- Đảm bảo MySQL service đang chạy
- Kiểm tra environment variables

### Lỗi: "404 Not Found"
- Kiểm tra đường dẫn file
- Đảm bảo Apache đang chạy
- Xem file `.htaccess` (nếu có)

### Lỗi: "Permission denied"
- Trên Linux/Mac: `chmod -R 755 DOAN_WEB2`
- Trên Docker: Đã được xử lý trong Dockerfile

### Website chậm trên Render Free Plan
- Free plan có giới hạn resources
- Service sleep sau 15 phút không hoạt động
- Lần đầu truy cập sau khi sleep mất ~30s
- Xem xét upgrade lên Starter Plan ($7/tháng)

## 📈 Roadmap (Tính năng tương lai)

- [ ] Tích hợp payment gateway (VNPay, Momo)
- [ ] Email notification cho đơn hàng
- [ ] Chatbot hỗ trợ khách hàng
- [ ] Mobile app (React Native)
- [ ] API RESTful
- [ ] Admin analytics dashboard
- [ ] Multi-language support
- [ ] Wishlist feature
- [ ] Product recommendations

## 🤝 Contributing

Nếu bạn muốn đóng góp:
1. Fork repository
2. Tạo branch mới: `git checkout -b feature/AmazingFeature`
3. Commit changes: `git commit -m 'Add some AmazingFeature'`
4. Push to branch: `git push origin feature/AmazingFeature`
5. Mở Pull Request

## 📄 License

Dự án này được phát triển cho mục đích học tập.

## 👨‍💻 Tác giả

- **Tên:** [Your Name]
- **Email:** [your.email@example.com]
- **GitHub:** [https://github.com/yourusername]

## 🙏 Acknowledgments

- Giảng viên hướng dẫn: [Tên giảng viên]
- Trường: [Tên trường]
- Môn học: Phát triển ứng dụng Web 2

## 📞 Liên hệ

Nếu có câu hỏi hoặc gặp vấn đề, vui lòng:
- Tạo Issue trên GitHub
- Email: [your.email@example.com]
- Facebook: [Link Facebook]

---

**⭐ Nếu thấy dự án hữu ích, hãy cho một star nhé! ⭐**

---

## 📚 Tài liệu tham khảo

- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Render Documentation](https://render.com/docs)
- [Git Documentation](https://git-scm.com/doc)

---

**Last Updated:** December 2025
