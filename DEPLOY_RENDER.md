# 🚀 Hướng dẫn Deploy lên Render.com + TiDB Cloud

## 📋 Tổng quan

**Vấn đề:** Render Free plan chỉ hỗ trợ PostgreSQL, không có MySQL miễn phí.

**Giải pháp:** Dùng **TiDB Cloud** (MySQL-compatible) làm database miễn phí!

### Stack cuối cùng:
- **Web Server:** Render.com (Free)
- **Database:** TiDB Cloud (Free - 5GB storage)
- **Deployment:** Docker + Auto-deploy từ GitHub

---

## 🗄️ Bước 1: Tạo Database trên TiDB Cloud

### 1.1. Đăng ký TiDB Cloud
1. Truy cập: https://tidbcloud.com
2. Click **"Sign Up"** (có thể dùng GitHub/Google)
3. Xác nhận email

### 1.2. Tạo Cluster (Database)
1. Sau khi đăng nhập, click **"Create Cluster"**
2. Chọn **"Serverless Tier"** (Free)
   - **Cluster Name:** `bookstore-db`
   - **Cloud Provider:** `AWS`
   - **Region:** `Singapore` (ap-southeast-1) - gần VN nhất
3. Click **"Create"**
4. Đợi 2-3 phút để cluster được tạo

### 1.3. Lấy Connection String
1. Vào cluster vừa tạo
2. Click **"Connect"**
3. Chọn tab **"Standard Connection"**
4. Copy **Connection String**, dạng:
   ```
   mysql://username.root:PASSWORD@gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/test?ssl-mode=VERIFY_IDENTITY
   ```
5. **Lưu lại** connection string này!

### 1.4. Tạo Database và Import dữ liệu

**Cách 1: Dùng MySQL Client**
```bash
# Kết nối đến TiDB
mysql --connect-timeout 15 \
  -u 'username.root' \
  -h gateway01.ap-southeast-1.prod.aws.tidbcloud.com \
  -P 4000 \
  -D test \
  --ssl-mode=VERIFY_IDENTITY \
  -p

# Nhập password khi được hỏi
```

Sau khi kết nối:
```sql
-- Tạo database
CREATE DATABASE WEB2_BookStore;
USE WEB2_BookStore;

-- Import từ file (hoặc copy-paste nội dung file SQL)
SOURCE d:/Downloads/DOAN_WEB2/DOAN_WEB2/database/WEB2_BookStore.sql;

-- Kiểm tra
SHOW TABLES;
SELECT COUNT(*) FROM SACH;
```

**Cách 2: Dùng TiDB Cloud Console**
1. Vào cluster → **"Import"**
2. Upload file `WEB2_BookStore.sql`
3. Chọn database: `WEB2_BookStore`
4. Click **"Import"**

**Cách 3: Dùng phpMyAdmin (nếu có)**
1. Kết nối đến TiDB bằng thông tin trên
2. Import file SQL như bình thường

---

## 🌐 Bước 2: Deploy Web Service lên Render

### 2.1. Đăng nhập Render.com
1. Truy cập: https://render.com
2. Đăng ký/Đăng nhập bằng GitHub
3. Authorize Render truy cập GitHub repo của bạn

### 2.2. Tạo Web Service
1. Click **"New +"** → **"Web Service"**
2. Chọn **"Build and deploy from a Git repository"**
3. Connect repository: `thanhhoa3514/doan_hobaokhang`
4. Click **"Connect"**

### 2.3. Cấu hình Service

**Basic Settings:**
- **Name:** `bookstore-web` (hoặc tên bạn thích)
- **Region:** `Singapore`
- **Branch:** `main`
- **Root Directory:** `.` (để trống)

**Build Settings:**
- **Runtime:** `Docker`
- **Dockerfile Path:** `./Dockerfile` (auto-detect)

**Instance Settings:**
- **Plan:** `Free` (512MB RAM, 400 build hours/month)

### 2.4. Thêm Environment Variables

Scroll xuống phần **"Environment Variables"**, click **"Add Environment Variable"**:

| Key | Value | Ghi chú |
|-----|-------|---------|
| `DATABASE_URL` | `mysql://username.root:PASSWORD@gateway...` | Copy từ TiDB Cloud |

**Lưu ý:** 
- Thay `PASSWORD` bằng password thật của bạn
- Đảm bảo connection string có `?ssl-mode=VERIFY_IDENTITY` ở cuối
- Thay `test` thành `WEB2_BookStore` trong path

**Ví dụ đầy đủ:**
```
mysql://4TqR3xYz.root:MyP@ssw0rd@gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/WEB2_BookStore?ssl-mode=VERIFY_IDENTITY
```

### 2.5. Advanced Settings (Optional)

**Health Check Path:**
- `/PHP/health.php`

**Auto-Deploy:**
- ✅ Enabled (mặc định)

### 2.6. Deploy!
1. Click **"Create Web Service"**
2. Render sẽ:
   - Clone repository từ GitHub
   - Build Docker image từ `Dockerfile`
   - Deploy container
   - Cấp domain miễn phí: `https://bookstore-web.onrender.com`

3. Theo dõi logs trong tab **"Logs"**
4. Đợi ~5-10 phút cho lần deploy đầu tiên

---

## ✅ Bước 3: Kiểm tra

### 3.1. Truy cập Website
- **URL:** `https://bookstore-web.onrender.com/PHP/trangchu.php`
- **Health Check:** `https://bookstore-web.onrender.com/PHP/health.php`

### 3.2. Test các tính năng
- [ ] Website load thành công
- [ ] Đăng nhập (Admin: `Le Van C` / `123`)
- [ ] Xem danh sách sách
- [ ] Thêm vào giỏ hàng
- [ ] Đặt hàng
- [ ] Admin panel hoạt động

### 3.3. Kiểm tra Database Connection
Truy cập: `https://bookstore-web.onrender.com/PHP/health.php`

Kết quả mong đợi:
```json
{
    "status": "healthy",
    "timestamp": "2025-12-24 14:52:00",
    "service": "BookStore Web",
    "checks": {
        "database": {
            "status": "up",
            "message": "Database connection OK"
        },
        "php": {
            "status": "up",
            "version": "8.1.x"
        }
    }
}
```

---

## 🔄 Bước 4: Cập nhật Code (Auto-Deploy)

Mỗi khi bạn sửa code:

```bash
# Sửa code trong dự án
# ...

# Commit và push
git add .
git commit -m "Update: mô tả thay đổi"
git push

# Render sẽ TỰ ĐỘNG deploy lại!
```

Theo dõi quá trình deploy:
1. Vào Render Dashboard
2. Chọn service `bookstore-web`
3. Tab **"Events"** hoặc **"Logs"**

---

## ⚙️ Environment Variables Reference

### DATABASE_URL Format

**TiDB Cloud Standard:**
```
mysql://[username]:[password]@[host]:[port]/[database]?ssl-mode=VERIFY_IDENTITY
```

**Ví dụ:**
```
mysql://4TqR3xYz.root:MyP@ssw0rd@gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/WEB2_BookStore?ssl-mode=VERIFY_IDENTITY
```

**Các thành phần:**
- `username`: Thường là `xxx.root` (TiDB cung cấp)
- `password`: Password bạn đặt khi tạo cluster
- `host`: Gateway endpoint (region-specific)
- `port`: `4000` (TiDB default)
- `database`: `WEB2_BookStore`
- `ssl-mode`: `VERIFY_IDENTITY` (bắt buộc cho TiDB Cloud)

### Optional Variables

Nếu muốn config riêng lẻ (không dùng DATABASE_URL):

| Key | Value | Mô tả |
|-----|-------|-------|
| `DB_HOST` | `gateway01.ap-southeast-1.prod...` | TiDB host |
| `DB_USER` | `4TqR3xYz.root` | TiDB username |
| `DB_PASSWORD` | `MyP@ssw0rd` | TiDB password |
| `DB_NAME` | `WEB2_BookStore` | Database name |
| `DB_PORT` | `4000` | TiDB port |

---

## 🐛 Troubleshooting

### Lỗi: "Database connection failed"

**Nguyên nhân:**
- DATABASE_URL sai format
- Password có ký tự đặc biệt chưa encode
- SSL mode không đúng
- TiDB cluster đang sleep (serverless tier)

**Giải pháp:**

1. **Kiểm tra DATABASE_URL:**
   ```bash
   # Trong Render Dashboard → Environment Variables
   # Đảm bảo có ?ssl-mode=VERIFY_IDENTITY
   ```

2. **Encode password nếu có ký tự đặc biệt:**
   ```
   @ → %40
   # → %23
   $ → %24
   & → %26
   ```
   
   Ví dụ: `P@ssw0rd!` → `P%40ssw0rd%21`

3. **Test connection từ local:**
   ```bash
   mysql --connect-timeout 15 \
     -u 'username.root' \
     -h gateway01... \
     -P 4000 \
     -D WEB2_BookStore \
     --ssl-mode=VERIFY_IDENTITY \
     -p
   ```

4. **Wake up TiDB cluster:**
   - Serverless tier sleep sau 1 giờ không hoạt động
   - Truy cập TiDB Console để wake up
   - Hoặc đợi ~30s cho lần kết nối đầu tiên

### Lỗi: "SSL connection error"

**Giải pháp:**
- Đảm bảo `?ssl-mode=VERIFY_IDENTITY` có trong DATABASE_URL
- File `db_connect.php` đã được cập nhật (version mới nhất)
- Kiểm tra logs: Render Dashboard → Logs

### Lỗi: "404 Not Found"

**Nguyên nhân:** URL sai

**Giải pháp:**
- URL phải là: `/PHP/trangchu.php`
- Không phải: `/trangchu.php`

### Website chậm/timeout

**Nguyên nhân:**
- Render Free plan sleep sau 15 phút
- TiDB Serverless sleep sau 1 giờ

**Giải pháp:**
- Lần đầu truy cập đợi ~30-60s
- Xem xét upgrade:
  - Render Starter: $7/tháng (không sleep)
  - TiDB Dedicated: $0.50/GB/tháng

### Lỗi: "Build failed"

**Kiểm tra:**
1. Dockerfile có đúng không
2. docker-compose.yml không được dùng trên Render (chỉ Dockerfile)
3. Xem logs chi tiết trong Render Dashboard

---

## 💰 Chi phí & Giới hạn

### TiDB Cloud Serverless (Free)
- ✅ **Storage:** 5GB
- ✅ **Request Units:** 50M RU/month
- ✅ **Row Storage:** 5GB
- ⚠️ **Sleep:** Sau 1 giờ không hoạt động
- ⚠️ **Cold start:** ~30s

### Render Free Plan
- ✅ **RAM:** 512MB
- ✅ **Build hours:** 400 hours/month
- ✅ **Bandwidth:** 100GB/month
- ⚠️ **Sleep:** Sau 15 phút không hoạt động
- ⚠️ **Cold start:** ~30s

### Tổng chi phí: **$0/tháng** 🎉

---

## 🚀 Nâng cấp (Nếu cần)

### Khi nào nên nâng cấp?

**Nâng cấp Render ($7/tháng):**
- Website có traffic thường xuyên
- Không muốn sleep
- Cần response time nhanh

**Nâng cấp TiDB ($0.50/GB):**
- Database > 5GB
- Cần performance cao hơn
- Cần backup tự động

---

## 📊 So sánh các phương án Database

| Database | Giá | Storage | Sleep | SSL | Phù hợp |
|----------|-----|---------|-------|-----|---------|
| **TiDB Cloud** | $0 | 5GB | 1h | ✅ | ✅ **Tốt nhất** |
| Render PostgreSQL | $0 | 1GB | Không | ✅ | ⚠️ Phải migrate sang PostgreSQL |
| PlanetScale | $0 | 5GB | Không | ✅ | ✅ Tốt (nhưng phức tạp hơn) |
| Railway MySQL | $5 | 1GB | Không | ✅ | ⚠️ Tốn phí |
| Aiven MySQL | $0 | 1GB | 7 ngày | ✅ | ⚠️ Giới hạn thời gian |

---

## 🎯 Checklist Deploy

### Pre-deployment
- [x] Code đã push lên GitHub
- [x] Dockerfile đã có
- [x] db_connect.php hỗ trợ TiDB
- [ ] TiDB cluster đã tạo
- [ ] Database đã import

### TiDB Cloud
- [ ] Đã tạo account
- [ ] Đã tạo Serverless cluster
- [ ] Đã copy Connection String
- [ ] Đã import database/WEB2_BookStore.sql
- [ ] Test connection thành công

### Render.com
- [ ] Đã tạo account
- [ ] Đã connect GitHub
- [ ] Đã tạo Web Service
- [ ] Đã thêm DATABASE_URL
- [ ] Deploy thành công

### Post-deployment
- [ ] Website accessible
- [ ] Health check OK
- [ ] Đăng nhập thành công
- [ ] Database queries hoạt động
- [ ] Giỏ hàng OK
- [ ] Đặt hàng OK

---

## 📚 Tài liệu tham khảo

- **TiDB Cloud:** https://docs.pingcap.com/tidbcloud
- **Render Docs:** https://render.com/docs
- **MySQL SSL:** https://dev.mysql.com/doc/refman/8.0/en/using-encrypted-connections.html

---

## 🎉 Kết luận

**Setup cuối cùng:**
- ✅ Web: Render.com (Free)
- ✅ Database: TiDB Cloud (Free)
- ✅ Total: $0/tháng
- ✅ Auto-deploy từ GitHub
- ✅ SSL miễn phí
- ✅ MySQL-compatible

**Ưu điểm:**
- Hoàn toàn miễn phí
- MySQL native (không cần migrate)
- Auto-deploy
- Professional setup

**Nhược điểm:**
- Sleep sau 15 phút (web) và 1 giờ (db)
- Cold start ~30-60s
- Giới hạn resources

**Phù hợp cho:**
- ✅ Đồ án/Luận văn
- ✅ Portfolio/Demo
- ✅ Học tập
- ⚠️ Không phù hợp production có traffic cao

---

**Chúc bạn deploy thành công! 🚀**

Nếu gặp vấn đề, check logs hoặc liên hệ support!
