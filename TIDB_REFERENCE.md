# 🗄️ TiDB Cloud Quick Reference

## 📋 Thông tin quan trọng

### Connection String Format
```
mysql://[username]:[password]@[host]:[port]/[database]?ssl-mode=VERIFY_IDENTITY
```

### Ví dụ thực tế
```
mysql://4TqR3xYz.root:MyP@ssw0rd@gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/WEB2_BookStore?ssl-mode=VERIFY_IDENTITY
```

---

## 🔧 Các lệnh thường dùng

### Kết nối từ Terminal

**MySQL CLI:**
```bash
mysql --connect-timeout 15 \
  -u '4TqR3xYz.root' \
  -h gateway01.ap-southeast-1.prod.aws.tidbcloud.com \
  -P 4000 \
  -D WEB2_BookStore \
  --ssl-mode=VERIFY_IDENTITY \
  -p
```

**Với password trong command (không an toàn):**
```bash
mysql --connect-timeout 15 \
  -u '4TqR3xYz.root' \
  -pMyP@ssw0rd \
  -h gateway01.ap-southeast-1.prod.aws.tidbcloud.com \
  -P 4000 \
  -D WEB2_BookStore \
  --ssl-mode=VERIFY_IDENTITY
```

### Import Database

**Từ file SQL:**
```bash
mysql --connect-timeout 15 \
  -u '4TqR3xYz.root' \
  -h gateway01.ap-southeast-1.prod.aws.tidbcloud.com \
  -P 4000 \
  -D WEB2_BookStore \
  --ssl-mode=VERIFY_IDENTITY \
  -p < database/WEB2_BookStore.sql
```

**Từ MySQL shell:**
```sql
SOURCE d:/Downloads/DOAN_WEB2/DOAN_WEB2/database/WEB2_BookStore.sql;
```

### Backup Database

```bash
mysqldump --connect-timeout 15 \
  -u '4TqR3xYz.root' \
  -h gateway01.ap-southeast-1.prod.aws.tidbcloud.com \
  -P 4000 \
  --ssl-mode=VERIFY_IDENTITY \
  -p WEB2_BookStore > backup_$(date +%Y%m%d).sql
```

---

## 🔍 Kiểm tra Database

### Kiểm tra tables
```sql
USE WEB2_BookStore;
SHOW TABLES;
```

### Kiểm tra dữ liệu
```sql
-- Đếm số sách
SELECT COUNT(*) FROM SACH;

-- Xem 5 sách đầu tiên
SELECT * FROM SACH LIMIT 5;

-- Kiểm tra user
SELECT * FROM USER;

-- Kiểm tra đơn hàng
SELECT * FROM DONHANG ORDER BY ngay_dat DESC LIMIT 10;
```

### Kiểm tra kết nối
```sql
SELECT 1;
SHOW VARIABLES LIKE 'version';
```

---

## 🌐 Environment Variables cho Render

### Cách 1: DATABASE_URL (Khuyến nghị)

**Trong Render Dashboard:**
```
Key: DATABASE_URL
Value: mysql://4TqR3xYz.root:MyP@ssw0rd@gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/WEB2_BookStore?ssl-mode=VERIFY_IDENTITY
```

### Cách 2: Individual Variables

```
DB_HOST=gateway01.ap-southeast-1.prod.aws.tidbcloud.com
DB_USER=4TqR3xYz.root
DB_PASSWORD=MyP@ssw0rd
DB_NAME=WEB2_BookStore
DB_PORT=4000
```

---

## 🔐 Password Encoding

Nếu password có ký tự đặc biệt, cần encode:

| Ký tự | Encoded |
|-------|---------|
| `@` | `%40` |
| `#` | `%23` |
| `$` | `%24` |
| `%` | `%25` |
| `&` | `%26` |
| `+` | `%2B` |
| ` ` (space) | `%20` |
| `/` | `%2F` |
| `?` | `%3F` |
| `=` | `%3D` |

**Ví dụ:**
- Password: `P@ss#123`
- Encoded: `P%40ss%23123`
- Full URL: `mysql://user:P%40ss%23123@host:4000/db?ssl-mode=VERIFY_IDENTITY`

**Tool online:** https://www.urlencoder.org/

---

## 📊 TiDB Cloud Limits (Free Tier)

| Resource | Limit |
|----------|-------|
| **Storage** | 5 GB |
| **Request Units** | 50M RU/month |
| **Connections** | 1000 concurrent |
| **Sleep** | After 1 hour inactive |
| **Cold Start** | ~30 seconds |
| **Regions** | AWS: us-east-1, us-west-2, ap-southeast-1, eu-central-1 |

---

## 🐛 Troubleshooting

### Lỗi: "Access denied"
```
ERROR 1045 (28000): Access denied for user 'xxx'
```

**Giải pháp:**
- Kiểm tra username (phải có `.root`)
- Kiểm tra password
- Đảm bảo cluster đang active

### Lỗi: "SSL connection error"
```
ERROR 2026 (HY000): SSL connection error
```

**Giải pháp:**
- Thêm `--ssl-mode=VERIFY_IDENTITY`
- Hoặc `--ssl-mode=REQUIRED`
- Kiểm tra MySQL client version (>= 5.7)

### Lỗi: "Connection timeout"
```
ERROR 2003 (HY000): Can't connect to MySQL server
```

**Giải pháp:**
- Cluster đang sleep → đợi 30s
- Kiểm tra network/firewall
- Thêm `--connect-timeout 15`

### Lỗi: "Unknown database"
```
ERROR 1049 (42000): Unknown database 'WEB2_BookStore'
```

**Giải pháp:**
```sql
-- Tạo database
CREATE DATABASE WEB2_BookStore;
USE WEB2_BookStore;

-- Import lại
SOURCE database/WEB2_BookStore.sql;
```

---

## 💡 Tips & Best Practices

### 1. Connection Pooling
TiDB hỗ trợ connection pooling tốt, không cần close/reopen liên tục.

### 2. Wake-up Cluster
Nếu cluster sleep, lần kết nối đầu tiên sẽ mất ~30s. Sau đó sẽ nhanh.

### 3. Monitoring
- Vào TiDB Console → Cluster → Monitoring
- Xem Request Units usage
- Xem Storage usage

### 4. Backup
Tự động backup mỗi tuần:
```bash
# Tạo cron job (Linux/Mac)
0 0 * * 0 mysqldump ... > backup_weekly.sql
```

### 5. Security
- ✅ Luôn dùng SSL (`ssl-mode=VERIFY_IDENTITY`)
- ✅ Không commit password vào Git
- ✅ Dùng environment variables
- ✅ Đổi password định kỳ

---

## 🔄 Migration từ Local MySQL

### Export từ local
```bash
mysqldump -u root -p WEB2_BookStore > local_backup.sql
```

### Import vào TiDB
```bash
mysql --connect-timeout 15 \
  -u 'username.root' \
  -h gateway01... \
  -P 4000 \
  -D WEB2_BookStore \
  --ssl-mode=VERIFY_IDENTITY \
  -p < local_backup.sql
```

---

## 📱 TiDB Cloud Console

### Truy cập
https://tidbcloud.com → Login → Select Cluster

### Các tính năng
- **Overview:** Cluster status, storage, RU usage
- **Connect:** Connection strings, CA certificates
- **Monitoring:** Performance metrics, slow queries
- **Backup:** Manual backup/restore
- **Settings:** Change password, scaling

---

## 🆘 Support

### TiDB Community
- Docs: https://docs.pingcap.com/tidbcloud
- Forum: https://ask.pingcap.com
- Discord: https://discord.gg/DQZ2dy3cuc
- GitHub: https://github.com/pingcap/tidb

### Quick Links
- Dashboard: https://tidbcloud.com
- Status: https://status.tidbcloud.com
- Pricing: https://www.pingcap.com/tidb-cloud-pricing/

---

**Lưu file này để tham khảo nhanh! 📌**
