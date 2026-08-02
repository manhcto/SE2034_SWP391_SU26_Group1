# SRS - Các Module Chính Đã Triển Khai

Tài liệu này ghi lại chức năng phát hiện từ source code hiện tại. Đây không phải bằng chứng rằng các module chưa có tài liệu requirement đã được stakeholder phê duyệt. Khi repository không có tài liệu requirement cho một module, intent của requirement được đánh dấu là `Chưa xác minh`.

Bằng chứng nguồn:

- `src/main/java/vn/edu/fpt/controller`
- `src/main/java/vn/edu/fpt/DAO`
- `src/main/java/vn/edu/fpt/model`
- `src/main/java/vn/edu/fpt/filter`
- `src/main/java/vn/edu/fpt/service`
- `src/main/webapp/views`
- `database/migrations`
- Các tài liệu SRS/SDS/business-process hiện có trong `docs`

## Tóm Tắt Module

| Module | Bằng chứng trong source đã triển khai | Trạng thái requirement |
|---|---|---|
| Xác thực và truy cập tài khoản | `LoginController`, `LogoutController`, `RegisterController`, `ForgotPasswordController`, `ResetPasswordController`, `VerifyOTPController`, auth JSPs | Chưa xác minh |
| Bộ lọc phân quyền theo vai trò | `AdminAuthenticationFilter`, `StaffAuthenticationFilter`, `GuideAuthenticationFilter`, `CustomerAuthenticationFilter`, `AuthenticationFilterSupport` | Chưa xác minh |
| Hồ sơ cá nhân và xóa tài khoản | `ProfileController`, `EditProfileController`, `DeleteAccountController`, profile JSPs | Chưa xác minh |
| Khách xem danh sách/chi tiết tour công khai | `TourController`, `TourDAO`, customer tour JSPs, `TourImageController` | Chưa xác minh |
| Staff quản lý tour và lịch tour | Staff tour controllers, `TourDAO`, staff tour JSPs | Được bao phủ một phần bởi business-process Markdown |
| Admin duyệt/từ chối/cập nhật trạng thái tour | Admin tour controllers, `TourDAO`, admin tour JSPs | Được bao phủ một phần bởi business-process Markdown |
| Khách xem cơ sở lưu trú và đặt phòng | `AccommodationController`, accommodation JSPs, `AccommodationDAO`, `RoomDAO`, `RoomBookingDAO` | Chưa xác minh |
| Staff/admin quản lý cơ sở lưu trú và phòng | `ManageAccommodationController`, `ManageRoomController`, staff accommodation JSPs | Chưa xác minh |
| Vòng đời đặt chỗ của khách | `BookingController`, `BookingEditController`, `BookingListController`, `BookingSummaryController`, `BookingDAO`, booking JSPs | Chưa xác minh |
| Thanh toán PayOS | `PaymentController`, `PaymentDAO`, `PayOSService`, payment JSP | Được bao phủ một phần bởi `PAYOS_SETUP.md` và `docs/operations/PayOS_Payment_Flow.md` |
| Staff quản lý đặt chỗ | `ManageBookingController`, staff booking JSPs | Chưa xác minh |
| Khách gửi phản hồi | `FeedbackController`, customer feedback JSPs, `FeedbackDAO` | Chưa xác minh |
| Staff/admin kiểm duyệt phản hồi | `ManageFeedbackController`, `AdminFeedbackController`, staff/admin feedback JSPs | Chưa xác minh |
| Khuyến mãi voucher và voucher của khách | `VoucherPromotionController`, `VoucherListController`, `SaveVoucherController`, voucher DAOs/JSPs | Chưa xác minh |
| Staff/admin quản lý voucher | `ManageVoucherController`, voucher management JSP | Chưa xác minh |
| Blog dành cho khách | `BlogController`, customer blog JSPs, `BlogDAO` | Chưa xác minh |
| Staff quản lý blog | `ManageBlogController`, staff blog JSPs | Chưa xác minh |
| Staff quản lý phân công tour | `ManageAssignmentTourController`, `AssignmentDAOImpl`, staff assignment JSPs | Đã bao phủ bởi SRS/SDS assignment |
| Hướng dẫn viên quản lý tour được phân công | `TourGuideScheduleController`, `TourGuideHomeController`, `BookingTravelerDAO`, `ItineraryLogDAO`, guide JSPs | Đã bao phủ bởi SRS/SDS assignment |
| Bảng điều khiển admin | `DashboardController`, `DashboardDAO`, dashboard JSP | Chưa xác minh |
| Admin quản lý người dùng | `ManageUserController`, `UpdateUserController`, `DeleteUserController`, `RestoreUserController`, user management JSP | Chưa xác minh |
| Admin quản lý VAT | `AdminVatController` | Chưa xác minh |

## Xác Thực Và Truy Cập Tài Khoản

Hành vi đã xác minh từ source:

- Đăng nhập bằng email/password.
- Chuyển hướng người dùng đã xác thực theo vai trò đến Admin, Tour Guide, Staff hoặc luồng trang chủ khách hàng.
- Đăng ký tài khoản customer mới với role ID 4.
- Đăng xuất session.
- Luồng quên/đặt lại mật khẩu với xác minh OTP.

Requirement intent, validation rule, password policy, thời hạn OTP, retry policy và yêu cầu gửi email là Chưa xác minh.

## Phân Quyền Theo Vai Trò

Hành vi đã xác minh từ source:

- Admin filter bảo vệ `/admin/*` và `/views/admin/*`.
- Staff filter bảo vệ `/staff/*` và `/views/staff/*`.
- Guide filter bảo vệ `/guide/*`.
- Customer filter bảo vệ các path và view dành cho customer.
- Kiểm tra vai trò bằng role ID và tên vai trò đã được chuẩn hóa.

Ma trận phân quyền chính xác và trải nghiệm khi người dùng không có quyền là Chưa xác minh.

## Quản Lý Tour

Hành vi đã xác minh từ source:

- Staff có thể xem danh sách, thêm, sửa, xem chi tiết và gửi tour để duyệt.
- Staff có thể xem danh sách, thêm, sửa, xem chi tiết và đóng lịch tour.
- Tạo/sửa tour của Staff hỗ trợ multipart upload.
- Staff chỉ được gửi duyệt tour có trạng thái `Draft` hoặc `Rejected`.
- Độ sẵn sàng của tour được kiểm tra trước khi gửi duyệt và phê duyệt.
- Admin có thể list/detail tour, approve pending tour, reject pending tour với reason validation và update tour status.
- Admin approval có thể mở các schedule planned hợp lệ.

Được bao phủ bởi business-process Markdown hiện có:

- Staff tạo tour.
- Staff chuẩn bị schedule.
- Staff gửi yêu cầu duyệt.
- Admin approve hoặc reject.
- Tour bị reject quay về Staff để chỉnh sửa.

Thiếu hoặc Chưa xác minh:

- Requirement từng field của tour và schedule.
- Requirement upload image.
- Tiêu chí readiness chính xác.
- Quy tắc close schedule.
- Filter list/detail phía Admin.
- Status transition matrix.

## Đặt Chỗ, Phòng Và Cơ Sở Lưu Trú

Hành vi đã xác minh từ source:

- Customer có thể browse tour và accommodation.
- Customer có thể tạo booking.
- Customer có thể xem booking list/history/summary và edit booking.
- Booking và room lifecycle tương tác với room/date availability.
- Migration chuẩn hóa booking status và reset room availability về operational room capacity.
- Staff có thể quản lý accommodation, room và room facility qua staff views.

Requirement intent là Chưa xác minh.

Thông tin còn thiếu:

- State machine của booking.
- Quy tắc giữ chỗ reservation.
- Ràng buộc cancellation/editing.
- Rule validation của accommodation và room.
- Rule gán facility.
- Hành vi accommodation read-only của Admin.

## Thanh Toán

Hành vi đã xác minh từ source:

- Tạo pending payment row.
- Tạo PayOS payment link.
- Render QR.
- Xác minh webhook.
- Return/cancel endpoints.
- Status polling.
- Pending payment expiry và reservation release.
- Đồng bộ booking sau payment paid/cancelled/failed.

Trạng thái requirement:

- Cấu hình được bao phủ một phần bởi `PAYOS_SETUP.md`.
- Runtime flow được ghi trong `docs/operations/PayOS_Payment_Flow.md`.

Thiếu hoặc Chưa xác minh:

- DDL bảng Payment.
- Setup PayOS dashboard ngoài webhook URL.
- Requirement test scenario end-to-end.
- Requirement copy hiển thị cho customer.

## Phản Hồi

Hành vi đã xác minh từ source:

- Customer có màn hình feedback list/detail/add.
- Staff có feedback list/detail/status management.
- Admin có feedback list/detail.
- Migration tạo unique index để enforce một feedback cho một booking.
- Migration seed feedback cho accommodation.

Requirement intent, rating rule, visibility workflow, moderation rule và eligible booking rule là Chưa xác minh.

## Voucher

Hành vi đã xác minh từ source:

- Customer có trang voucher promotion.
- Customer có danh sách voucher đã lưu.
- Endpoint save voucher.
- Endpoint staff/admin voucher management.
- Migration seed voucher mẫu.

Requirement intent, eligibility, redemption, inventory, expiration và khác biệt quyền Staff/Admin là Chưa xác minh.

## Blog

Hành vi đã xác minh từ source:

- Customer có blog list/detail.
- Staff có blog management.
- File staff blog add page tồn tại trong working tree.

Requirement intent, publish workflow, content validation, author permission và status rule là Chưa xác minh.

## Module Phân Công

Trạng thái requirement: Đã bao phủ.

Xem:

- `docs/requirements/SRS_Functional_Requirements_Assignment_Modules.md`
- `docs/design/SDS_Manage_Tour_Assignment_and_Manage_Assigned_Tour.md`

Hành vi đã bao phủ:

- Staff list/create/edit/view/delete assignment.
- Chọn booking tour đã thanh toán và đủ điều kiện.
- Chọn guide active và khả dụng.
- Validate duplicate customer/guide.
- Validate overlap lịch guide.
- Tự động tính pickup/check-in.
- Khóa assignment theo workflow status.
- Guide list/detail assigned tour.
- Guide confirm assignment.
- Guide cập nhật passenger status.
- Guide thêm progress log.
- Issue notification.
- Completion kết thúc booking liên quan.

## Bảng Điều Khiển Và Quản Trị Admin

Hành vi đã xác minh từ source:

- Admin home/dashboard controller.
- Dashboard DAO và dashboard JSP.
- Admin booking list/detail.
- Admin feedback list/detail.
- Admin user manage/update/delete/restore.
- Controller VAT của admin.
- Admin voucher path thông qua shared voucher management controller.

Requirement intent, định nghĩa KPI, date filtering rule, user-management constraint, VAT rule và hành vi admin-voucher là Chưa xác minh.

## Tài Liệu Yêu Cầu Cần Bổ Sung Tiếp

Để biến hành vi phát hiện từ source thành requirement có traceability, cần tạo SRS/SDS riêng cho:

- Authentication và account management.
- Customer tour/accommodation browsing và booking.
- Booking lifecycle và payment reservation.
- PayOS payment operations.
- Staff/Admin tour management và approval.
- Accommodation và room management.
- Voucher management và redemption.
- Feedback và moderation.
- Blog management.
- Quản lý bảng điều khiển/người dùng/VAT của admin.
- Database baseline schema và migration strategy.
