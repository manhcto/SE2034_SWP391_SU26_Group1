# Ma Trận Bao Phủ Yêu Cầu

Ma trận này map bằng chứng trong repository với source code WonderVN hiện tại. Các mục được đánh dấu `Chưa xác minh` là các mục chưa có tài liệu requirement trong repository chứng minh hành vi mong muốn.

## Bằng Chứng Đã Đọc

- `pom.xml`
- `src/main/java`
- `src/main/webapp`
- `database/migrations`
- `PAYOS_SETUP.md`
- `docs/business-process/Staff_Tour_Main_Business_Process_Analysis.md`
- `docs/SRS_Functional_Requirements_Assignment_Modules.docx`
- `docs/SDS_Manage_Tour_Assignment_and_Manage_Assigned_Tour.docx`
- `docs/SDS_Manage_Tour_Assignment_and_Manage_Assigned_Tour_Final.docx`
- `docs/srs_assignment_assets/build_srs_functional_requirements.py`
- `docs/sds_assignment_assets/build_sds.py`

## Kết Quả Kiểm Kê Markdown

Các file Markdown đã xác minh trong working tree tại thời điểm audit:

- `PAYOS_SETUP.md`
- `docs/business-process/Staff_Tour_Main_Business_Process_Analysis.md`
- `.agents/skills/**.md`

Không tìm thấy `README.md` hoặc `AGENTS.md` trong working tree tại thời điểm audit ban đầu. Git history không có bằng chứng file `.md` nào từng bị xóa hoặc rename.

## Ma Trận Bao Phủ

| Khu vực requirement | Bằng chứng source | Bằng chứng requirement | Mức bao phủ hiện tại | Thông tin thiếu | Hành động đề xuất |
|---|---|---|---|---|---|
| Tổng quan project/build/runtime | `pom.xml`, cây thư mục source | Không có trước `README.md` | Một phần sau khi tạo `README.md` | Cấu hình deploy runtime, thiết lập kết nối DB, thứ tự seed và cấu hình Tomcat là Chưa xác minh. | Duy trì `README.md` làm tài liệu tổng quan source. |
| Staff quản lý phân công tour | `ManageAssignmentTourController`, `AssignmentDAOImpl`, staff assignment JSPs | SRS/SDS assignment docs | Đã bao phủ | Base schema DDL đầy đủ là Chưa xác minh. | Cập nhật SRS/SDS Markdown khi source thay đổi. |
| Hướng dẫn viên quản lý tour được phân công | `TourGuideScheduleController`, `TourGuideHomeController`, `BookingTravelerDAO`, `ItineraryLogDAO`, guide JSPs | SRS/SDS assignment docs | Đã bao phủ | Base schema DDL đầy đủ là Chưa xác minh; screenshot chưa được xác minh bằng Markdown. | Cập nhật SRS/SDS Markdown khi source thay đổi. |
| Staff tạo tour, lịch tour, gửi duyệt | Staff tour controllers, `TourDAO`, staff tour JSPs | Business-process analysis Markdown | Một phần | Đóng lịch, upload ảnh, quy tắc sẵn sàng, trạng thái lịch và validation DAO cụ thể chưa được document đầy đủ. | Mở rộng business-process doc hoặc tạo SRS/SDS riêng cho quản lý tour. |
| Admin duyệt/từ chối tour | Admin tour controllers, `TourDAO`, admin tour JSPs | Business-process analysis Markdown | Một phần | Bộ lọc danh sách/chi tiết của admin, endpoint cập nhật trạng thái, validation lý do từ chối và hành vi mở lịch chưa được document đầy đủ. | Tạo section requirement cho Admin Tour Approval. |
| Thanh toán PayOS | `PaymentController`, `PaymentDAO`, `PayOSService`, payment JSP | `PAYOS_SETUP.md` | Một phần | Cơ chế kiểm tra trạng thái định kỳ, endpoint QR, hết hạn, hủy, hành vi lỗi webhook, đồng bộ Booking-Payment, file cấu hình local dự phòng và DDL bảng chưa đầy đủ. | Duy trì `docs/operations/PayOS_Payment_Flow.md`. |
| Vòng đời booking và phòng | `BookingController`, `BookingDAO`, `RoomBookingDAO`, `RoomDAO`, `20260716_booking_room_lifecycle.sql` | Không có | Chưa bao phủ | Intent requirement cho khách đặt chỗ, sức chứa phòng, giữ chỗ thanh toán, hủy và hoàn voucher là Chưa xác minh. | Tạo SRS/SDS cho vòng đời booking. |
| Accommodation và room management | `AccommodationController`, `ManageAccommodationController`, `ManageRoomController`, `AccommodationDAO`, `RoomDAO` | Không có | Chưa bao phủ | Requirement intent, role, validation, facility rule, room availability rule là Chưa xác minh. | Tạo SRS/SDS cho accommodation module. |
| Quản lý voucher và lưu voucher của khách | `ManageVoucherController`, `VoucherPromotionController`, `VoucherListController`, `SaveVoucherController`, voucher DAOs | Không có | Chưa bao phủ | Intent requirement cho danh sách khuyến mãi, lưu/dùng voucher và thao tác staff/admin là Chưa xác minh. | Tạo SRS/SDS cho module voucher. |
| Quản lý phản hồi | `FeedbackController`, `ManageFeedbackController`, `AdminFeedbackController`, `FeedbackDAO`, feedback migration | Không có | Chưa bao phủ | Intent requirement cho hiển thị phản hồi, quy tắc một phản hồi cho mỗi booking và luồng kiểm duyệt/trạng thái là Chưa xác minh. | Tạo SRS/SDS cho module phản hồi. |
| Quản lý blog và blog dành cho khách | `BlogController`, `ManageBlogController`, `BlogDAO`, blog JSPs | Không có | Chưa bao phủ | Intent requirement cho trạng thái xuất bản, soạn bài và danh sách/chi tiết blog của khách là Chưa xác minh. | Tạo SRS/SDS cho module blog. |
| User/admin account management | `ManageUserController`, `UpdateUserController`, `DeleteUserController`, `RestoreUserController`, `UserDAO` | Không có | Chưa bao phủ | Requirement intent cho soft delete/restore/update và role restriction là Chưa xác minh. | Tạo SRS/SDS cho user management. |
| Authentication/password recovery/profile | auth controllers, `EmailUtil`, profile controllers, auth/profile JSPs | Không có | Chưa bao phủ | Requirement intent cho OTP, reset password, registration, profile update/delete là Chưa xác minh. | Tạo SRS/SDS cho authentication và account profile. |
| Bảng điều khiển admin | `DashboardController`, `DashboardDAO`, dashboard JSP | Không có | Chưa bao phủ | Định nghĩa KPI, khoảng ngày, hành vi biểu đồ và quy tắc truy cập là Chưa xác minh. | Tạo SRS/SDS cho dashboard. |
| Quản lý VAT | `AdminVatController` | Không có | Chưa bao phủ | Intent requirement và data model là Chưa xác minh. | Tạo section requirement/design cho VAT. |
| Schema database/migrations | `database/migrations`, DAO SQL | Chỉ có migration | Một phần | Base `CREATE TABLE` DDL không có; schema đầy đủ là Chưa xác minh. | Duy trì `docs/database/Database_Schema_And_Migrations.md`. |
| Markdown của agent skill | `.agents/skills/**.md` | Skill frontmatter/docs | Không phải product requirement | Không bao phủ chức năng WonderVN. | Loại khỏi coverage requirement WonderVN. |

## Khoảng Trống Tổng Thể

- Chưa có SRS toàn repository cho mọi module đã triển khai.
- Chưa có SDS toàn repository cho mọi module đã triển khai.
- Chưa có file schema database nền; migration và DAO SQL cho thấy cách dùng bảng nhưng không cho thấy DDL đầy đủ.
- Chưa có tài liệu cài đặt/deploy xác minh Tomcat, kết nối SQL Server, tạo schema, thứ tự seed hoặc thiết lập runtime local.
- Chưa có ma trận bao phủ test liên kết JUnit test với requirement.
- Requirement intent ngoài assignment modules và Staff tour main business process là Chưa xác minh.
