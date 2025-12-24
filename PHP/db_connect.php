<?php
// Hỗ trợ cả môi trường local và production (Docker/Render)

// Kiểm tra nếu có DATABASE_URL (Render.com cung cấp)
if (isset($_ENV['DATABASE_URL'])) {
    $url = parse_url($_ENV['DATABASE_URL']);
    $servername = $url['host'];
    $username = $url['user'];
    $password = $url['pass'];
    $dbname = ltrim($url['path'], '/');
    $port = isset($url['port']) ? $url['port'] : 3306;
} 
// Kiểm tra environment variables từ Docker
elseif (getenv('DB_HOST')) {
    $servername = getenv('DB_HOST');
    $username = getenv('DB_USER');
    $password = getenv('DB_PASSWORD');
    $dbname = getenv('DB_NAME');
    $port = 3306;
} 
// Fallback cho môi trường local
else {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "WEB2_BookStore";
    $port = 3306;
}

// Kết nối database
$conn = new mysqli($servername, $username, $password, $dbname, $port);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
}

// Set charset UTF-8
$conn->set_charset("utf8mb4");
