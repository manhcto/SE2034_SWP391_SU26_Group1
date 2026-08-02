# Luồng Thanh Toán PayOS

Bằng chứng nguồn:

- `PAYOS_SETUP.md`
- `pom.xml`
- `src/main/java/vn/edu/fpt/service/PayOSService.java`
- `src/main/java/vn/edu/fpt/controller/customer/PaymentController.java`
- `src/main/java/vn/edu/fpt/DAO/PaymentDAO.java`
- `src/main/java/vn/edu/fpt/DAO/BookingDAO.java`
- `src/main/java/vn/edu/fpt/model/Payment.java`
- `src/main/webapp/views/customer/payment.jsp`

## Cấu Hình Bắt Buộc

Ứng dụng đọc các key sau từ Java system properties, environment variables hoặc `payos-local.properties` trên classpath:

- `PAYOS_CLIENT_ID`
- `PAYOS_API_KEY`
- `PAYOS_CHECKSUM_KEY`
- `APP_BASE_URL`

`APP_BASE_URL` phải là URL HTTPS public và phải bao gồm context path của web app khi WAR không được deploy ở root.

Webhook URL trên PayOS nên là:

```text
{APP_BASE_URL}/payment/webhook
```

Không commit secret PayOS vào Git.

## Thư Viện Phụ Thuộc Đã Xác Minh

`pom.xml` có:

- `vn.payos:payos-java:2.0.1`
- `com.google.zxing:core:3.5.3`

PayOS được dùng để tạo liên kết thanh toán và xác minh webhook. ZXing được dùng để tạo ảnh QR.

## Endpoint Đã Xác Minh

`PaymentController` map các endpoint:

| Endpoint | Phương thức | Mục đích |
|---|---|---|
| `/payment` | GET | Hiển thị trang thanh toán cho booking. |
| `/payment/return` | GET | Nhận lượt quay lại từ PayOS và hiển thị thông báo đang đối chiếu. |
| `/payment/cancel` | GET | Hủy session thanh toán của khách và giải phóng pending reservation. |
| `/payment/webhook` | POST | Xác minh webhook PayOS và đánh dấu thanh toán là thành công hoặc thất bại. |
| `/payment/qr` | GET | Tạo ảnh QR cho URL checkout/thanh toán. |
| `/payment/status` | GET | Kiểm tra trạng thái thanh toán/booking hiện tại dưới dạng JSON. |

## Luồng Trang Thanh Toán

1. Customer mở `/payment?bookingID=...`.
2. Controller load booking summary qua `BookingDAO.getBookingSummaryByID`.
3. Controller xác minh session hiện tại có quyền truy cập booking.
4. Controller tính amount từ total price của booking.
5. `ensurePaymentRecord()` tạo row `Payment` pending khi booking đang processing, payable và reservation hợp lệ.
6. Pending payment hết hạn được giải phóng qua `PaymentDAO.expirePendingPayment()`.
7. Booking state được đồng bộ qua `PaymentDAO.synchronizeBookingState()`.
8. Nếu PayOS đã cấu hình và chưa có checkout/QR, `PayOSService.createPaymentLink()` tạo payment link.
9. `PaymentDAO.prepareCheckout()` lưu checkout URL và gia hạn expiry.
10. Dữ liệu QR/checkout được lưu trong session attribute theo prefix gắn với booking.
11. Controller forward đến `/views/customer/payment.jsp`.

## Tạo Liên Kết Thanh Toán

`PayOSService.createPaymentLink()`:

- Yêu cầu đủ PayOS config key và `APP_BASE_URL`.
- Dùng booking ID làm PayOS `orderCode`.
- Làm tròn amount về đơn vị VND nguyên.
- Dùng return URL `{APP_BASE_URL}/payment/return?bookingID=...`.
- Dùng cancel URL `{APP_BASE_URL}/payment/cancel?bookingID=...`.
- Đặt thời hạn payment link là 15 phút từ thời điểm tạo.
- Chuẩn hóa description tối đa 25 ký tự.

Service hiện có thông tin ngân hàng hiển thị được set cố định trong source để hiển thị trên payment page. Các giá trị đó có đúng production hay không là Chưa xác minh.

## Luồng Kiểm Tra Trạng Thái Định Kỳ

`/payment/status`:

1. Xác minh quyền truy cập booking.
2. Đảm bảo có pending payment record nếu cần.
3. Expire pending payment nếu cần.
4. Đồng bộ booking state theo payment state.
5. Trả JSON gồm:
   - `success`
   - `changed`
   - `message`
   - `bookingStatus`
   - `paymentStatus`

Message đã xác minh trong source gồm `paid` và `expired`.

## Luồng Nhận Webhook

`/payment/webhook`:

1. Đọc request body.
2. `PayOSService.verifyWebhook()` xác minh chữ ký/dữ liệu webhook.
3. Dùng PayOS order code làm `bookingID`.
4. Bỏ qua webhook hợp lệ khi booking không tồn tại.
5. Từ chối webhook khi PayOS code không phải `00` hoặc amount không khớp tổng tiền booking.
6. Mark payment failed khi status/amount không hợp lệ.
7. Mark payment paid khi webhook hợp lệ.
8. Đồng bộ booking sang completed qua `BookingDAO.syncCompletedBookingFromPaidPayment()`.
9. Trả JSON success/error message.

## Luồng Hủy Và Hết Hạn

Customer hủy qua `/payment/cancel`:

- Xác minh quyền truy cập booking.
- Gọi `BookingDAO.releasePendingPaymentReservation()`.
- Xóa session value checkout/QR.
- Hiển thị lại payment page với kết quả hủy.

Xử lý hết hạn:

- `PaymentDAO.createPending()` đặt `expiredAt` là 15 phút từ thời điểm tạo.
- `PaymentDAO.prepareCheckout()` refresh `expiredAt` thành 15 phút từ thời điểm tạo checkout.
- `PaymentDAO.expirePendingPayment()` giải phóng reservation khi pending payment hết hạn.

## Trạng Thái Thanh Toán

Constant đã xác minh trong source:

- `Pending`
- `Paid`
- `Failed`
- `Cancelled`

`Payment.isPaid()` cũng chấp nhận trạng thái tiếng Việt `Đã thanh toán`.

`Payment.getDisplayStatus()` map status sang label hiển thị tiếng Việt.

## Cách Sử Dụng Cơ Sở Dữ Liệu

Source Java đã xác minh dùng `[dbo].[Payment]` với các field gồm:

- `paymentID`
- `bookingID`
- `payment_method`
- `totalAmount`
- `status`
- `paymentDate`
- `description`
- `transactionReference`
- `paymentLinkId`
- `createdAt`
- `expiredAt`
- `paymentType`
- `checkoutUrl`
- `payosOrderCode`
- `transactionCode`
- `note`

DDL đầy đủ của bảng là Chưa xác minh.

## Khoảng Trống Đã Biết

- Cấu hình dashboard PayOS là Chưa xác minh từ trạng thái repository.
- Secret PayOS production không nằm trong Git theo đúng chính sách.
- Base DDL của bảng `Payment` là Chưa xác minh.
- Migration seed `20260726_seed_paid_bookings_and_available_guides.sql` có điểm không nhất quán tên bảng `Payment`/`Payments` cần xác minh với database.
- Error message trong source đang trộn tiếng Việt không dấu, tiếng Việt có dấu và tiếng Anh; requirement về ngôn ngữ hiển thị là Chưa xác minh.
- End-to-end payment tests là Chưa xác minh từ tài liệu hiện tại trong repository.
