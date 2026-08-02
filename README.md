# WonderVN

WonderVN là ứng dụng web Java phục vụ quản lý du lịch. Bằng chứng trong repository cho thấy đây là dự án Maven đóng gói dạng WAR, sử dụng Java 17, Jakarta Servlet/JSP, JSTL, Microsoft SQL Server JDBC, PayOS, Jakarta Mail, ZXing và JUnit 5.

## Công Nghệ Đã Xác Minh

- Build: Maven WAR (`pom.xml`)
- Java: 17
- Web layer: Jakarta Servlet 6, JSP 3.1, JSTL
- Server mục tiêu: Tomcat 10.1 ở scope `provided`
- Database: Microsoft SQL Server thông qua `mssql-jdbc`
- Tích hợp thanh toán: PayOS Java SDK
- Sinh mã QR: ZXing
- Email: Jakarta Mail
- Test: JUnit 5

## Cấu Trúc Mã Nguồn Đã Xác Minh

- `src/main/java/vn/edu/fpt/controller`: servlet controller, chia theo authentication, customer, staff, admin và tour guide.
- `src/main/java/vn/edu/fpt/DAO`: các lớp DAO dùng JDBC cho user, tour, assignment, booking, payment, room, accommodation, feedback, voucher, blog và dashboard.
- `src/main/java/vn/edu/fpt/model`: model domain, model hiển thị và model dữ liệu trung gian.
- `src/main/java/vn/edu/fpt/filter`: filter xác thực theo vai trò Admin, Staff, Customer và Tour Guide.
- `src/main/java/vn/edu/fpt/service`: service thanh toán PayOS và wrapper kết quả thanh toán.
- `src/main/webapp/views`: JSP cho public, customer, staff, admin và guide.
- `src/main/webapp/assets`: CSS, JavaScript, ảnh và thư mục upload placeholder.
- `database/migrations`: migration và script seed SQL.
- `docs`: tài liệu requirement, design và business-process.

## Các Khu Vực Chức Năng Đã Xác Minh Từ Mã Nguồn

- Đăng nhập, đăng ký, đăng xuất và khôi phục mật khẩu.
- Điều hướng và phân quyền theo vai trò Admin, Staff, Tour Guide và Customer.
- Customer xem tour, xem accommodation, booking, thanh toán, feedback, voucher, blog và profile.
- Staff quản lý tour và lịch tour.
- Staff quản lý phân công tour cho hướng dẫn viên.
- Staff quản lý accommodation, room, booking, feedback, voucher và blog.
- Tour Guide xem tour được phân công, cập nhật trạng thái hành khách và ghi log tiến trình tour.
- Admin xem dashboard, booking, feedback, duyệt tour, VAT, voucher và quản lý user.
- PayOS tạo checkout, hiển thị QR, xác minh webhook, polling trạng thái, hủy thanh toán, xử lý hết hạn và đồng bộ Booking-Payment.

## Tài Liệu Yêu Cầu Hiện Có

Repository có bằng chứng requirement/design cho các phần sau:

- Business process chính của Staff khi tạo tour: `docs/business-process/Staff_Tour_Main_Business_Process_Analysis.md`
- SRS cho assignment modules: `docs/SRS_Functional_Requirements_Assignment_Modules.docx`
- SDS cho assignment modules: `docs/SDS_Manage_Tour_Assignment_and_Manage_Assigned_Tour.docx`
- Bản SDS duplicate/final có text trích xuất giống bản SDS trên: `docs/SDS_Manage_Tour_Assignment_and_Manage_Assigned_Tour_Final.docx`

Các bản Markdown được thêm để tài liệu bám sát source:

- `docs/requirements/SRS_Functional_Requirements_Assignment_Modules.md`
- `docs/design/SDS_Manage_Tour_Assignment_and_Manage_Assigned_Tour.md`
- `docs/requirements/Requirement_Coverage_Matrix.md`
- `docs/database/Database_Schema_And_Migrations.md`
- `docs/operations/PayOS_Payment_Flow.md`
- `docs/requirements/SRS_Implemented_Core_Modules.md`

Ý định requirement cho các module ngoài SRS/SDS/business-process hiện có là Chưa xác minh.

## Cách Biên Dịch Và Đóng Gói

Repository có Maven wrapper và cấu hình Maven WAR.

```powershell
.\mvnw.cmd clean package
```

Cấu hình deploy runtime, Tomcat local, giá trị kết nối SQL Server và biến môi trường production là Chưa xác minh từ tài liệu repository.

## Cấu Hình PayOS

Cấu hình PayOS được ghi trong `PAYOS_SETUP.md` và được mở rộng ở `docs/operations/PayOS_Payment_Flow.md`.

Các key cấu hình đã xác minh từ source:

- `PAYOS_CLIENT_ID`
- `PAYOS_API_KEY`
- `PAYOS_CHECKSUM_KEY`
- `APP_BASE_URL`

Không commit secret PayOS vào Git.
