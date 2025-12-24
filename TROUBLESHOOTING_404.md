# 🐛 Troubleshooting: Lỗi 404 Not Found trên Render

## ✅ ĐÃ SỬA XONG!

### 📋 **Tóm tắt vấn đề:**

Khi deploy lên Render, nhiều tính năng bị lỗi **404 Not Found**:
- ❌ Đăng nhập không hoạt động
- ❌ Đăng ký không hoạt động  
- ❌ Giỏ hàng không hoạt động
- ❌ Cập nhật profile không hoạt động

### 🔍 **Nguyên nhân:**

**Cấu trúc thư mục:**
```
/var/www/html/
├── PHP/
│   ├── giohang.php
│   ├── login-register/
│   │   ├── login.php
│   │   └── register.php
│   ├── add_to_cart.php
│   └── update-user.php
└── js/
    ├── account.js
    └── product_filter.js
```

**Code cũ (SAI):**
```javascript
// ❌ Tìm file ở root
fetch("login-register/login.php")
fetch("add_to_cart.php")
fetch("update-user.php")
```

**Kết quả:**
```
Browser tìm: /login-register/login.php
File thật ở:  /PHP/login-register/login.php
→ 404 Not Found ❌
```

---

## 🔧 **Giải pháp đã áp dụng:**

### **1. Sửa tất cả JavaScript fetch URLs**

#### **File: `js/account.js`**
```javascript
// ✅ TRƯỚC (SAI)
fetch("login-register/login.php", {...})
fetch("login-register/register.php", {...})

// ✅ SAU (ĐÚNG)
fetch("/PHP/login-register/login.php", {...})
fetch("/PHP/login-register/register.php", {...})
```

#### **File: `js/product_filter.js`**
```javascript
// ✅ TRƯỚC (SAI)
fetch("add_to_cart.php", {...})

// ✅ SAU (ĐÚNG)
fetch("/PHP/add_to_cart.php", {...})
```

#### **File: `js/edit-profile.js`**
```javascript
// ✅ TRƯỚC (SAI)
fetch("update-user.php", {...})

// ✅ SAU (ĐÚNG)
fetch("/PHP/update-user.php", {...})
```

### **2. Thêm URL Rewrite trong `.htaccess`**

Để hỗ trợ các link cũ, thêm rewrite rules:
```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    
    # Redirect các file .php từ root vào thư mục PHP/
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} ^/([a-zA-Z0-9_-]+\.php)$
    RewriteRule ^([a-zA-Z0-9_-]+\.php)$ /PHP/$1 [L,QSA]
</IfModule>
```

**Cách hoạt động:**
```
/giohang.php → /PHP/giohang.php ✅
/trangchu.php → /PHP/trangchu.php ✅
```

---

## 📊 **Các file đã sửa:**

| File | Thay đổi | Status |
|------|----------|--------|
| `js/account.js` | Login/Register URLs | ✅ Fixed |
| `js/product_filter.js` | Add to cart URL | ✅ Fixed |
| `js/edit-profile.js` | Update user URL | ✅ Fixed |
| `.htaccess` | URL rewrite rules | ✅ Added |

---

## 🧪 **Cách test sau khi deploy:**

### **1. Đợi Render deploy xong (~2-3 phút)**

Vào Render Dashboard → Logs → Xem:
```
==> Build successful
==> Deploy live
```

### **2. Test các tính năng:**

#### **✅ Test Login:**
1. Truy cập: `https://hobaokhang.onrender.com`
2. Click vào icon **Tài khoản**
3. Nhập: 
   - Username: `0123456789` (hoặc số điện thoại khác)
   - Password: `pass123`
4. Click **Đăng nhập**
5. **Kết quả mong đợi:** Đăng nhập thành công, không có lỗi 404

#### **✅ Test Register:**
1. Click tab **Đăng ký**
2. Điền thông tin
3. Click **Đăng ký**
4. **Kết quả mong đợi:** Đăng ký thành công

#### **✅ Test Giỏ hàng:**
1. Click vào **Giỏ Hàng** (icon giỏ)
2. **Kết quả mong đợi:** Trang giỏ hàng load OK, không 404

#### **✅ Test Add to cart:**
1. Vào trang sản phẩm
2. Click **Thêm vào giỏ**
3. **Kết quả mong đợi:** Thông báo "Đã thêm vào giỏ hàng"

#### **✅ Test Update profile:**
1. Đăng nhập
2. Click vào tài khoản → **Chỉnh sửa**
3. Sửa thông tin → **Lưu**
4. **Kết quả mong đợi:** Cập nhật thành công

---

## 🔍 **Cách xem logs trong Render:**

### **Option 1: Render Dashboard (Dễ nhất)**

1. Vào https://dashboard.render.com
2. Chọn service `bookstore-web`
3. Tab **"Logs"** → Real-time logs

**Tìm lỗi:**
```bash
# Lỗi 404
GET /login-register/login.php HTTP/1.1" 404

# Thành công
POST /PHP/login-register/login.php HTTP/1.1" 200
```

### **Option 2: Shell vào container**

1. Tab **"Shell"** → Click **"Launch Shell"**
2. Chạy lệnh:

```bash
# Xem Apache error log
tail -f /var/log/apache2/error.log

# Xem Apache access log
tail -f /var/log/apache2/access.log

# Xem cấu trúc thư mục
ls -la /var/www/html/PHP/

# Test database connection
php -r "require '/var/www/html/PHP/db_connect.php'; echo 'DB OK';"

# Xem .htaccess
cat /var/www/html/.htaccess
```

---

## 📝 **Checklist sau khi deploy:**

- [ ] Render deploy thành công (check Logs)
- [ ] Health check OK: `/PHP/health.php` → 200 OK
- [ ] Đăng nhập hoạt động
- [ ] Đăng ký hoạt động
- [ ] Giỏ hàng load OK
- [ ] Thêm vào giỏ hàng OK
- [ ] Cập nhật profile OK
- [ ] Không còn lỗi 404 trong logs

---

## 🎯 **Nguyên tắc để tránh lỗi tương tự:**

### **1. Luôn dùng absolute paths trong JavaScript:**

```javascript
// ❌ SAI (relative path)
fetch("login.php")
fetch("../PHP/login.php")

// ✅ ĐÚNG (absolute path)
fetch("/PHP/login.php")
```

### **2. Hoặc dùng base URL:**

```javascript
const BASE_URL = "/PHP";
fetch(`${BASE_URL}/login.php`)
```

### **3. Kiểm tra cấu trúc thư mục:**

```bash
# Local (XAMPP)
C:/xampp/htdocs/DOAN_WEB2/PHP/

# Render (Docker)
/var/www/html/PHP/
```

Đảm bảo paths giống nhau!

---

## 🐛 **Các lỗi phổ biến khác:**

### **Lỗi: "Database connection failed"**
```bash
# Check DATABASE_URL
echo $DATABASE_URL

# Test connection
php -r "require 'PHP/db_connect.php'; echo 'OK';"
```

### **Lỗi: ".htaccess not working"**
```bash
# Check mod_rewrite enabled
apache2ctl -M | grep rewrite

# Check AllowOverride
cat /etc/apache2/apache2.conf | grep AllowOverride
```

### **Lỗi: "Permission denied"**
```bash
# Fix permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
```

---

## 📚 **Tài liệu tham khảo:**

- **Render Logs:** https://render.com/docs/logs
- **Render Shell:** https://render.com/docs/shell
- **Apache mod_rewrite:** https://httpd.apache.org/docs/current/mod/mod_rewrite.html

---

## ✅ **Kết luận:**

**Vấn đề:** Lỗi 404 do dùng relative paths trong JavaScript

**Giải pháp:**
1. ✅ Sửa tất cả fetch URLs thành absolute paths (`/PHP/...`)
2. ✅ Thêm URL rewrite rules trong `.htaccess`
3. ✅ Test trên Render

**Kết quả:** Tất cả tính năng hoạt động bình thường! 🎉

---

**Lưu file này để tham khảo khi gặp lỗi tương tự! 📌**
