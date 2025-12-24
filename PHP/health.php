<?php
/**
 * Health Check Endpoint
 * Render.com sẽ ping endpoint này để kiểm tra service còn sống không
 */

header('Content-Type: application/json');

$health = [
    'status' => 'healthy',
    'timestamp' => date('Y-m-d H:i:s'),
    'service' => 'BookStore Web',
    'checks' => []
];

// Check database connection
try {
    require_once __DIR__ . '/db_connect.php';
    
    if ($conn->ping()) {
        $health['checks']['database'] = [
            'status' => 'up',
            'message' => 'Database connection OK'
        ];
    } else {
        $health['checks']['database'] = [
            'status' => 'down',
            'message' => 'Database ping failed'
        ];
        $health['status'] = 'unhealthy';
    }
    
    $conn->close();
} catch (Exception $e) {
    $health['checks']['database'] = [
        'status' => 'down',
        'message' => $e->getMessage()
    ];
    $health['status'] = 'unhealthy';
}

// Check PHP version
$health['checks']['php'] = [
    'status' => 'up',
    'version' => phpversion()
];

// Check disk space (nếu cần)
$health['checks']['disk'] = [
    'status' => 'up',
    'free_space' => disk_free_space('/') . ' bytes'
];

// Return JSON response
http_response_code($health['status'] === 'healthy' ? 200 : 503);
echo json_encode($health, JSON_PRETTY_PRINT);
