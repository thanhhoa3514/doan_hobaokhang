<?php
// Hỗ trợ cả môi trường local, Docker và production (Render + TiDB Cloud)

// Khởi tạo biến
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WEB2_BookStore";
$port = 3306;
$ssl_ca = null;
$ssl_verify = false;

// 1. Kiểm tra DATABASE_URL (TiDB Cloud/Render cung cấp)
// Format: mysql://username:password@host:port/database?ssl-mode=VERIFY_IDENTITY&ssl-ca=/path/to/ca.pem
if (getenv('DATABASE_URL')) {
    $url = parse_url(getenv('DATABASE_URL'));
    $servername = $url['host'];
    $username = $url['user'];
    $password = isset($url['pass']) ? $url['pass'] : '';
    $dbname = ltrim($url['path'], '/');
    $port = isset($url['port']) ? $url['port'] : 4000; // TiDB default port
    
    // Parse query string cho SSL options
    if (isset($url['query'])) {
        parse_str($url['query'], $params);
        if (isset($params['ssl-mode']) && $params['ssl-mode'] === 'VERIFY_IDENTITY') {
            $ssl_verify = true;
        }
    }
}
// 2. Kiểm tra individual environment variables (Docker/Manual config)
elseif (getenv('DB_HOST')) {
    $servername = getenv('DB_HOST');
    $username = getenv('DB_USER') ?: 'root';
    $password = getenv('DB_PASSWORD') ?: '';
    $dbname = getenv('DB_NAME') ?: 'WEB2_BookStore';
    $port = getenv('DB_PORT') ?: 3306;
    
    // Check SSL options
    if (getenv('DB_SSL_CA')) {
        $ssl_ca = getenv('DB_SSL_CA');
        $ssl_verify = true;
    }
}
// 3. Fallback cho môi trường local (XAMPP/WAMP)
// Giữ nguyên giá trị mặc định đã khởi tạo ở trên

// Kết nối database
$conn = mysqli_init();

if (!$conn) {
    die("mysqli_init failed");
}

// Nếu cần SSL (TiDB Cloud yêu cầu)
if ($ssl_verify && $ssl_ca) {
    $conn->ssl_set(NULL, NULL, $ssl_ca, NULL, NULL);
    $conn->options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, true);
} elseif ($ssl_verify) {
    // TiDB Cloud không cần CA file nếu dùng public endpoint
    $conn->options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, false);
}

// Thực hiện kết nối
$connected = @$conn->real_connect(
    $servername,
    $username,
    $password,
    $dbname,
    $port,
    NULL,
    $ssl_verify ? MYSQLI_CLIENT_SSL : 0
);

// Kiểm tra kết nối
if (!$connected) {
    // Log error cho debugging (không expose ra production)
    error_log("Database connection failed: " . $conn->connect_error);
    die("Kết nối database thất bại. Vui lòng kiểm tra cấu hình.");
}

// Set charset UTF-8
$conn->set_charset("utf8mb4");

// Optional: Set timezone
$conn->query("SET time_zone = '+07:00'");
