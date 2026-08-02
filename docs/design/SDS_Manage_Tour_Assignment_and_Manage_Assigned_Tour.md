# SDS - Quản Lý Phân Công Tour Và Tour Được Phân Công

Bằng chứng nguồn:

- `docs/SDS_Manage_Tour_Assignment_and_Manage_Assigned_Tour.docx`
- `docs/SDS_Manage_Tour_Assignment_and_Manage_Assigned_Tour_Final.docx`
- `docs/sds_assignment_assets/build_sds.py`
- `src/main/java/vn/edu/fpt/controller/staff/ManageAssignmentTourController.java`
- `src/main/java/vn/edu/fpt/controller/tourguide/TourGuideScheduleController.java`
- `src/main/java/vn/edu/fpt/controller/tourguide/TourGuideHomeController.java`
- `src/main/java/vn/edu/fpt/DAO/AssignmentDAOImpl.java`
- `src/main/java/vn/edu/fpt/DAO/BookingTravelerDAO.java`
- `src/main/java/vn/edu/fpt/DAO/ItineraryLogDAO.java`
- `src/main/java/vn/edu/fpt/model/TourAssignments.java`
- `src/main/java/vn/edu/fpt/model/AssignmentView.java`
- `src/main/java/vn/edu/fpt/model/BookingTraveler.java`
- `src/main/java/vn/edu/fpt/model/ItineraryLog.java`

Hai file SDS DOCX có text trích xuất giống nhau. File Markdown này dùng nội dung chung đó làm bản Markdown canonical bám sát source.

## 1. Bối Cảnh Hệ Thống

| Mục | Giá trị |
|---|---|
| Hệ thống | WonderVN Travel Management System |
| Kiến trúc | Java Servlet/JSP MVC, DAO/JDBC, Microsoft SQL Server |
| Phạm vi | Staff quản lý phân công tour và Tour Guide xử lý tour được phân công |
| Source baseline | Implementation hiện tại trong repository, gồm assignment workflow được khôi phục ngày 27/07/2026 |

Các ví dụ SQL trong tài liệu dùng tham số đặt tên để dễ đọc. Phần triển khai Java thực tế dùng placeholder của `PreparedStatement`.

## 2. Quản Lý Phân Công Tour

Module này cho phép Staff xem, tạo, phân công lại và xóa phân công hướng dẫn viên. Hệ thống chỉ hiển thị booking tour đủ điều kiện và đã thanh toán. Controller và DAO ngăn phân công trùng khách hàng/hướng dẫn viên, chặn lịch hướng dẫn viên bị chồng và khóa bản ghi sau khi hướng dẫn viên xác nhận hoặc bắt đầu tour.

### 2.1 Các Lớp Chính

| Lớp | Vai trò |
|---|---|
| `StaffAuthenticationFilter` | Cho phép request role 2/Staff và redirect user chưa xác thực về login. |
| `ManageAssignmentTourController` | Điều hướng màn hình và command phân công của Staff. |
| `AssignmentDAOImpl` | Thực hiện query, validation, insert, update, delete assignment và các thao tác assignment thuộc guide. |
| `TourAssignments` | Entity model của phân công. |
| `AssignmentView` | View model join thông tin phân công, tour, guide, booking, customer, capacity và pricing. |
| `DBConnection` | Tạo kết nối JDBC đến SQL Server. |

### 2.2 Thiết Kế `ManageAssignmentTourController`

| Method | Mô tả |
|---|---|
| `init()` | Khởi tạo `AssignmentDAOImpl`. |
| `doGet()` | Điều hướng `list`, `view`, `create`, `edit`; từ chối write action qua GET. |
| `doPost()` | Điều hướng `insert`, `update`, `delete`. |
| `listAssignment()` | Load các phân công Staff được xem và forward đến JSP danh sách. |
| `viewAssignment()` | Load `AssignmentView` đầy đủ và tính trạng thái khóa thao tác Staff. |
| `showCreateForm()` | Load booking đủ điều kiện đã thanh toán và guide đang khả dụng. |
| `insertAssignment()` | Kiểm tra booking, guide availability, duplicate customer/guide và overlap trước khi insert. |
| `showEditForm()` | Load assignment có thể chỉnh sửa và danh sách guide thay thế đủ điều kiện. |
| `updateAssignment()` | Cập nhật assignment chưa khóa hoặc reset assignment bị từ chối về pending sau validation. |
| `deleteAssignment()` | Xóa assignment khi DAO cho phép. |
| `applyScheduledCheckpoints()` | Đặt pickup time bằng departure minus 30 phút và check-in deadline bằng departure minus 10 phút. |
| `isStaffLockedAssignmentStatus()` | Khóa Staff edit/delete với `Accepted`, `Confirmed`, `In Progress`, `Completed`. |

### 2.3 Thiết Kế Phía Staff Trong `AssignmentDAOImpl`

| Method | Mô tả |
|---|---|
| `getAllAssignments()` | Lấy các assignment Staff được thấy, gồm rejected record chưa được thay thế. |
| `getAssignmentById()` | Lấy `TourAssignments` theo primary key. |
| `getAssignmentDetail()` | Lấy chi tiết join assignment, tour, guide, booking, customer và schedule. |
| `getAllBookingsForAssignment()` | Trả về booking tour đã thanh toán/đủ điều kiện và chưa bị assign cho cùng customer/schedule. |
| `getAllGuides()` | Trả về guide active không có assignment đang mở. |
| `getScheduleDepartureAt()` | Kết hợp ngày schedule và departure time. |
| `isGuideAvailableForAssignment()` | Kiểm tra role TourGuide active và không có assignment chưa đóng. |
| `isCompletedTourBookingForAssignment()` | Kiểm tra booking tour đủ điều kiện và có payment thành công. |
| `hasAssignmentForSameTourGuide()` | Phát hiện trùng guide cho cùng schedule. |
| `hasAssignmentForSameTourCustomer()` | Phát hiện trùng customer/booking bằng ID, user, email hoặc phone. |
| `hasOverlappingAssignmentForGuide()` | Phát hiện overlap date-range dạng inclusive với assignment đang mở khác. |
| `addAssignment()` | Insert assignment trong transaction và sinh mã dạng `ASG-000000`. |
| `updateAssignment()` | Update assignment trong transaction và hỗ trợ thay thế tour bị từ chối. |
| `deleteAssignment()` | Xóa progress log rồi xóa assignment. |

### 2.4 Trình Tự Phân Công Của Staff

Thêm phân công tour:

1. Staff gửi `GET /staff/assignment?action=create`.
2. `StaffAuthenticationFilter` xác thực request Staff.
3. Controller load booking đủ điều kiện và guide khả dụng.
4. DAO query SQL Server.
5. Controller render `assignment-create.jsp`.
6. Staff post `action=insert`, `bookingID`, `userID` và meeting point tùy chọn.
7. Controller kiểm tra paid booking, guide availability, duplicate customer, duplicate guide và overlap lịch.
8. Controller tính pickup/check-in checkpoint từ departure time.
9. DAO insert `Tour_Assignments` trong transaction và sinh assignment code.
10. Controller redirect về danh sách assignment với success hoặc error.

Phân công lại tour bị từ chối:

1. Staff mở màn hình edit cho assignment bị từ chối.
2. Controller load assignment detail và các guide thay thế đủ điều kiện.
3. Staff post guide thay thế và cập nhật meeting point.
4. Controller kiểm tra lại availability, duplicate và overlap.
5. Assignment bị từ chối được reset sang `Pending`; `rejectionReason`, `guideNote` và rejected timestamp bị xóa.
6. DAO update assignment trong transaction.
7. Controller redirect về danh sách assignment với message kết quả.

### 2.5 Trách Nhiệm Truy Vấn Của Phân Công Staff

| Query | Trách nhiệm |
|---|---|
| MTA-01 Eligible paid tour bookings | Chọn booking `Tour` có trạng thái booking đủ điều kiện, `Payment` thành công, `Tour_Scheduler` hợp lệ và không có assignment active cho cùng booking/customer. |
| MTA-02 Available tour guides | Chọn `User` active có role TourGuide/Guide và không có assignment chưa đóng. |
| MTA-03 Detect overlapping guide schedules | Từ chối guide khi khoảng ngày ứng viên giao với assignment chưa đóng khác. |
| MTA-04 Insert assignment | Insert vào `Tour_Assignments` chỉ khi user là TourGuide active và không có assignment đang mở. |
| MTA-05 Reassign rejected assignment | Thay guide và reset assignment bị từ chối về `Pending`. |

Bảng đã xác minh có được tham chiếu: `Booking`, `Booking_Detail`, `Payment`, `Tour_Scheduler`, `Tour`, `Tour_Assignments`, `[User]`, `[Role]`.

## 3. Quản Lý Tour Được Phân Công

Module này là không gian làm việc của hướng dẫn viên. Hướng dẫn viên chỉ xem được phân công thuộc mình, xác nhận hoặc từ chối phân công đang chờ, và chỉ dùng các thao tác hành khách/tiến độ sau khi xác nhận. Khi hoàn tất tour, phân công chuyển sang `Completed`, booking chuyển sang `End`, hướng dẫn viên được giải phóng để nhận phân công khác.

### 3.1 Các Lớp Chính

| Lớp | Vai trò |
|---|---|
| `GuideAuthenticationFilter` | Cho phép request role 3/TourGuide và redirect user chưa xác thực về login. |
| `TourGuideHomeController` | Load dashboard guide, số lượng assignment theo trạng thái và log gần đây. |
| `TourGuideScheduleController` | Điều hướng list, detail, passenger status, status update, confirmation và progress log của assigned tour. |
| `AssignmentDAOImpl` | Load guide-owned assignment và cập nhật assignment state. |
| `BookingTravelerDAO` | Load/sinh traveler và cập nhật traveler status cho assignment thuộc guide. |
| `ItineraryLogDAO` | Insert và đọc progress log; tạo issue notification. |
| `BookingTraveler` | Entity traveler. |
| `ItineraryLog` | Entity progress log. |
| `AssignmentView` / `TourAssignments` | View/entity model của assignment. |

### 3.2 Thiết Kế `TourGuideScheduleController`

| Method | Mô tả |
|---|---|
| `init()` | Khởi tạo assignment DAO, traveler DAO và itinerary-log DAO. |
| `doGet()` | Điều hướng list assigned-tour, detail, passenger status và progress-log form. |
| `doPost()` | Điều hướng confirm, passenger update, progress-log submit và assignment status update. |
| `listAssignments()` | Load assignment không cancelled/rejected thuộc guide hiện tại. |
| `viewAssignmentDetail()` | Hiển thị assignment đã chọn và lịch sử progress. |
| `showEditPassengerStatus()` | Load traveler đã có hoặc được sinh cho assignment còn thao tác được. |
| `updatePassengerStatus()` | Validate và cập nhật traveler status, tên editable, phone và note. |
| `showProgressLogForm()` | Load progress form và log hiện có. |
| `addProgressLog()` | Tạo progress log và chuyển assignment sang `In Progress` hoặc `Completed`. |
| `confirmAssignment()` | Xác nhận assignment pending/assigned thuộc guide. |
| `updateAssignmentStatus()` | Áp dụng chuyển trạng thái đã được server validate và lưu guide note. |
| `canUseTourActions()` | Cho phép passenger/progress chỉ với `Accepted`, `Confirmed`, `In Progress`. |
| `isValidTravelerStatus()` | Chấp nhận `Pending`, `Checked-in`, `Absent`, `Completed`. |
| `isValidProgressStatus()` | Chấp nhận `Pickup Completed`, `Departed`, `Arrived`, `Returning`, `Completed`, `Issue`. |

Ghi chú: SDS DOCX hiện có nhắc `rejectAssignment()`. Source hiện tại dùng `updateAssignmentStatus()` trong `TourGuideScheduleController` và `AssignmentDAOImpl.updateAssignmentStatusForGuide()` cho cập nhật trạng thái, bao gồm `Rejected` khi được `AssignmentView.canGuideTransitionStatus()` cho phép.

### 3.3 Thiết Kế DAO

| DAO | Method | Mô tả |
|---|---|---|
| `AssignmentDAOImpl` | `getAssignmentsByGuide()` | Trả về assignment không rejected/cancelled thuộc guide. |
| `AssignmentDAOImpl` | `getAssignmentDetailForGuide()` | Load detail chỉ khi `assignmentID` và `guideID` khớp. |
| `AssignmentDAOImpl` | `confirmAssignmentForGuide()` | Xác nhận pending guide assignment. |
| `AssignmentDAOImpl` | `updateAssignmentStatusForGuide()` | Ghi nhận cập nhật trạng thái và note của guide; kết thúc booking khi completed. |
| `AssignmentDAOImpl` | `updateAssignmentStatusFromProgressForGuide()` | Cập nhật tiến trình và kết thúc booking khi completed. |
| `BookingTravelerDAO` | `getTravelersByAssignment()` | Đảm bảo traveler row tồn tại và lấy traveler của booking trong assignment. |
| `BookingTravelerDAO` | `updateTravelerStatusForGuide()` | Chỉ cập nhật traveler thuộc assignment của guide; giữ nguyên danh tính booker chính. |
| `BookingTravelerDAO` | `ensureTravelersForAssignment()` | Tạo traveler mặc định từ số lượng adult/child khi chưa có detail. |
| `ItineraryLogDAO` | `addProgressLog()` | Insert progress log trong transaction và tạo staff notification khi `Issue`. |
| `ItineraryLogDAO` | `getLogsByAssignmentForGuide()` | Lấy lịch sử progress của assignment thuộc guide. |
| `ItineraryLogDAO` | `getRecentLogsByGuide()` | Lấy progress log gần đây cho home screen của guide. |

### 3.4 Trình Tự Phân Công Của Hướng Dẫn Viên

Xác nhận assignment:

1. Tour Guide post `action=confirmAssignment`.
2. `GuideAuthenticationFilter` xác thực request guide.
3. Controller load assignment detail thuộc guide.
4. Controller kiểm tra assignment chưa completed và chưa ở trạng thái actionable.
5. DAO cập nhật status sang `Confirmed`, đồng thời set accepted/confirmed timestamp.
6. Controller redirect về assignment detail.

Thêm progress log và hoàn tất tour:

1. Tour Guide post `action=addProgressLog` với progress status, title và content.
2. Controller load assignment detail thuộc guide.
3. Controller kiểm tra các thao tác hành khách/tiến độ còn được phép.
4. Controller validate progress status.
5. `ItineraryLogDAO.addProgressLog()` insert vào `Tour_Progress_Log`.
6. Progress `Issue` tạo `Notification` chưa đọc cho Staff đã phân công.
7. `AssignmentDAOImpl.updateAssignmentStatusFromProgressForGuide()` chuyển assignment sang `In Progress` hoặc `Completed`.
8. Progress `Completed` cập nhật `Booking` liên quan sang `End` trong cùng transaction với cập nhật assignment.

### 3.5 Trách Nhiệm Truy Vấn Của Phân Công Hướng Dẫn Viên

| Query | Trách nhiệm |
|---|---|
| MAT-01 Guide assigned-tour list | Trả về assignment active/completed thuộc guide đang đăng nhập; loại rejected/cancelled. |
| MAT-02 Confirm assignment | Chỉ xác nhận assignment pending/assigned/accepted thuộc guide. |
| MAT-03 Load assignment passengers | Trả về traveler của booking trong assignment và đánh dấu traveler đầu tiên là booker cố định. |
| MAT-04 Update passenger status | Chỉ cập nhật traveler thuộc assignment của guide; giữ nguyên tên/phone booker chính. |
| MAT-05 Add progress log and issue notification | Lưu sự kiện progress và tạo staff notification chưa đọc khi `Issue`. |
| MAT-06 Complete tour and end booking | Hoàn tất assignment và cập nhật booking liên quan sang `End`. |

Bảng đã xác minh có được tham chiếu: `Tour_Assignments`, `Tour_Scheduler`, `Tour`, `Booking`, `Booking_Detail`, `Booking_Traveler`, `Tour_Progress_Log`, `Notification`, `[User]`.

## 4. Tóm Tắt Quy Tắc Thiết Kế

- Booking tour chỉ được phân công khi trạng thái booking đủ điều kiện và có row `Payment` thành công.
- Guide khả dụng khi user active, có role TourGuide và không có assignment chưa đóng.
- Cùng customer hoặc guide không được phân công hai lần cho cùng schedule.
- Date range được tính inclusive; mọi overlap đều chặn phân công cùng guide.
- Pickup time là 30 phút trước departure.
- Check-in deadline là 10 phút trước departure.
- Staff không thể edit/delete assignment `Accepted`, `Confirmed`, `In Progress` hoặc `Completed`.
- Passenger/progress action của guide bị khóa cho đến khi xác nhận và bị khóa lại sau khi completed.
- Progress `Issue` tạo staff notification.
- Progress `Completed` kết thúc booking liên quan.

## 5. Chưa Xác Minh

- Base SQL DDL cho mọi bảng liên quan assignment không có trong migration của repository; việc tạo schema đầy đủ là Chưa xác minh.
- Chất lượng render hình ảnh của DOCX gốc là Chưa xác minh trong bản chuyển đổi Markdown này.
- Các module ngoài assignment không nằm trong phạm vi SDS này.
