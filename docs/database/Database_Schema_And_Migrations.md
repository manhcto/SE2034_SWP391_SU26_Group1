# Lược Đồ Cơ Sở Dữ Liệu Và Migration

Bằng chứng nguồn:

- `database/migrations/20260716_booking_room_lifecycle.sql`
- `database/migrations/20260722_seed_10_records_v5.sql`
- `database/migrations/20260726_feedback_ratings_and_seed.sql`
- `database/migrations/20260726_seed_5_users_per_role.sql`
- `database/migrations/20260726_seed_paid_bookings_and_available_guides.sql`
- SQL trong DAO tại `src/main/java/vn/edu/fpt/DAO`
- Model tại `src/main/java/vn/edu/fpt/model`

## Cơ Sở Dữ Liệu

Các script migration dùng tên database `WonderVn`.

DDL nền đầy đủ là Chưa xác minh vì các migration đã đọc trong repository không chứa đầy đủ `CREATE TABLE` cho toàn bộ database ứng dụng.

## Danh Sách Migration

| File | Mục đích đã xác minh từ SQL | Bảng được tham chiếu | Ghi chú |
|---|---|---|---|
| `20260716_booking_room_lifecycle.sql` | Chuẩn hóa legacy booking status, reset room availability về room capacity và tạo index tra cứu. | `Booking`, `Room`, `Booking_Detail`, `Payment` | Tạo index `IX_BookingDetail_Room_DateRange`, `IX_Booking_Status_Type`, `IX_Payment_Status_ExpiredAt`. |
| `20260722_seed_10_records_v5.sql` | Seed accommodation, room, tour và voucher. | `User`, `Accommodation`, `Room`, `Tour`, `Voucher` | Cung cấp dữ liệu mẫu tour/accommodation/voucher; không phải schema DDL. |
| `20260726_feedback_ratings_and_seed.sql` | Thêm unique index một feedback cho một booking và seed feedback accommodation. | `Feedback`, `User`, `Role`, `Booking`, `Booking_Detail`, `Accommodation`, `Room` | Tạo `UX_Feedback_BookingID`. |
| `20260726_seed_5_users_per_role.sql` | Seed user cho từng role. | `User`, `Role` | Phụ thuộc vào role đã tồn tại. |
| `20260726_seed_paid_bookings_and_available_guides.sql` | Seed paid tour booking và guide khả dụng để test assignment. | `Booking`, `Booking_Detail`, `Payments`, `Payment`, `Tour_Scheduler`, `Tour`, `Role`, `User`, `Tour_Assignments` | Có điểm không nhất quán: phần object check/insert dùng `dbo.Payments`, nhưng verification query join `dbo.Payment`; source Java dùng `[dbo].[Payment]`. Cần xác minh database. |

## Cách Các Bảng Được Dùng Theo Chức Năng

| Chức năng | Bảng được source/migration tham chiếu |
|---|---|
| Xác thực/vai trò người dùng | `[User]`, `[Role]` |
| Tour | `Tour`, `Tour_Scheduler`, các bảng ảnh/lịch trình tour được suy ra từ tên DAO/model; DDL đầy đủ Chưa xác minh |
| Tour assignments | `Tour_Assignments`, `Tour_Scheduler`, `Tour`, `Booking`, `Booking_Detail`, `Payment`, `[User]`, `[Role]` |
| Tour guide passengers | `Booking_Traveler`, `Booking`, `Booking_Detail`, `Tour_Assignments` |
| Tour guide progress logs | `Tour_Progress_Log`, `Tour_Assignments`, `Notification` |
| Đặt chỗ và thanh toán | `Booking`, `Booking_Detail`, `Payment`, các bảng phòng/lịch tour |
| Cơ sở lưu trú và phòng | `Accommodation`, `Room`, các bảng tiện ích được suy ra từ DAO/model; DDL đầy đủ Chưa xác minh |
| Feedback | `Feedback`, `Booking`, `Booking_Detail`, `Accommodation`, `Room`, `[User]`, `[Role]` |
| Voucher | `Voucher`, bảng user-voucher được suy ra từ `UserVoucherDAO` và model `UserVoucher`; DDL đầy đủ Chưa xác minh |
| Blog | Bảng blog được suy ra từ `BlogDAO` và model `BlogPost`; DDL đầy đủ Chưa xác minh |
| Bảng điều khiển | Các bảng booking, payment, feedback, hiệu suất tour/cơ sở lưu trú được suy ra từ `DashboardDAO`; DDL đầy đủ Chưa xác minh |

## Quy Tắc Dữ Liệu Của Module Phân Công

Đã xác minh từ SRS/SDS/source:

- Booking tour có thể phân công phải là `Tour` booking có trạng thái booking đủ điều kiện và có `Payment` thành công.
- Guide ứng viên phải là `User` active có role TourGuide/Guide.
- Assignment chưa đóng sẽ chặn khả dụng của guide.
- Trạng thái assignment đã đóng gồm `Completed`, `Cancelled`, `Rejected` và các biến thể tiếng Việt tương ứng.
- Kiểm tra trùng assignment dùng booking ID, user ID, email hoặc phone cho cùng tour schedule.
- Kiểm tra overlap lịch guide dùng date-range inclusive.
- Khi assignment completed, booking liên quan được cập nhật trạng thái `End`.
- Progress log `Issue` tạo notification chưa đọc cho Staff.

## Ghi Chú Về Bảng Thanh Toán

Source Java nhất quán query `[dbo].[Payment]` trong `PaymentDAO` và `AssignmentDAOImpl`.

Script seed `20260726_seed_paid_bookings_and_available_guides.sql` kiểm tra/insert `dbo.Payments` nhưng sau đó verify bằng `dbo.Payment`. Đây là điểm không nhất quán trong repository và là Chưa xác minh với database thực tế.

## Thông Tin Cơ Sở Dữ Liệu Còn Thiếu

- Schema nền `CREATE TABLE` đầy đủ.
- Định nghĩa foreign key.
- Kiểu dữ liệu và default của mọi cột.
- Chiến lược index ngoài các migration đã đọc.
- Stored procedure hoặc trigger nếu có.
- Thứ tự chạy migration ngoài thứ tự theo tên file.
- Chiến lược rollback.
- Cấu hình kết nối theo môi trường.
