# Cấu hình PayOS thật

Ứng dụng đọc bốn biến môi trường hoặc Java system properties sau:

```text
PAYOS_CLIENT_ID=...
PAYOS_API_KEY=...
PAYOS_CHECKSUM_KEY=...
APP_BASE_URL=https://ten-mien-cong-khai/WonderVN
```

`APP_BASE_URL` phải là URL HTTPS công khai và phải bao gồm context path của ứng dụng nếu WAR không chạy ở root.

Trong trang quản trị PayOS, cấu hình webhook:

```text
https://ten-mien-cong-khai/WonderVN/payment/webhook
```

Không đưa ba khóa PayOS vào Git. Sau khi cấu hình, khởi động lại Tomcat để JVM nhận biến môi trường.
