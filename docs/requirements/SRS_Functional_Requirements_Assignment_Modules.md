# SRS Yêu Cầu Chức Năng - Module Phân Công

Bằng chứng nguồn:

- `docs/SRS_Functional_Requirements_Assignment_Modules.docx`
- `docs/srs_assignment_assets/build_srs_functional_requirements.py`
- `src/main/java/vn/edu/fpt/controller/staff/ManageAssignmentTourController.java`
- `src/main/java/vn/edu/fpt/controller/tourguide/TourGuideScheduleController.java`
- `src/main/java/vn/edu/fpt/DAO/AssignmentDAOImpl.java`
- `src/main/java/vn/edu/fpt/DAO/BookingTravelerDAO.java`
- `src/main/java/vn/edu/fpt/DAO/ItineraryLogDAO.java`
- `src/main/webapp/views/staff/assignment-*.jsp`
- `src/main/webapp/views/guide/assignment-*.jsp`
- `src/main/webapp/views/guide/passenger-status-edit.jsp`
- `src/main/webapp/views/guide/tour-progress-log-create.jsp`

Tài liệu Markdown này ghi lại cùng phạm vi requirement với file SRS DOCX hiện có: Staff quản lý phân công tour và hướng dẫn viên quản lý tour được phân công.

## 3.3 Quản Lý Phân Công Tour

Chức năng quản lý phân công tour hỗ trợ Staff phân công các booking tour đủ điều kiện và đã thanh toán cho hướng dẫn viên còn khả dụng, xem chi tiết phân công, thay thế hướng dẫn viên và kiểm soát bản ghi phân công theo workflow và quy tắc trùng lịch.

### 3.3.1 Danh Sách Phân Công Tour

Tác nhân: Staff

Màn hình cho phép Staff:

- Xem tất cả bản ghi phân công tour.
- Xem mã phân công, booking, tour, hướng dẫn viên được phân công, điểm hẹn, thời gian đón và ngày phân công.
- Nhận biết phân công bị hướng dẫn viên từ chối và xem lý do từ chối.
- Mở màn hình chi tiết phân công tour.
- Mở màn hình chỉnh sửa phân công tour khi phân công chưa bị khóa.
- Xóa phân công chưa bị khóa sau khi xác nhận thao tác.
- Chuyển đến màn hình thêm phân công tour.
- Quay về màn hình Staff Home.

Màn hình cũng hỗ trợ:

- Hiển thị thông báo thành công sau khi tạo, cập nhật hoặc xóa phân công.
- Hiển thị thông báo lỗi khi không tìm thấy hoặc không thể xóa phân công.
- Hiển thị nhãn `Locked` thay cho thao tác edit/delete sau khi hướng dẫn viên xác nhận hoặc bắt đầu tour.
- Hiển thị empty-state khi chưa có phân công.

Quy tắc nghiệp vụ:

- Staff luôn có thể xem phân công.
- Staff không thể sửa hoặc xóa phân công ở trạng thái `Accepted`, `Confirmed`, `In Progress` hoặc `Completed`.
- Phân công bị từ chối vẫn hiển thị cho đến khi được phân công lại hoặc được xử lý theo cách khác.
- Thao tác xóa yêu cầu xác nhận trên trình duyệt và được server kiểm tra lại.

Mô tả trường:

| Trường | Mô tả |
|---|---|
| Assignment Code | Hiển thị mã phân công được sinh, hoặc ID số nếu chưa có mã. |
| Rejected Indicator | Hiển thị `Rejected` và lý do từ chối của hướng dẫn viên. |
| Booking | Hiển thị booking code và booking ID nội bộ; hiển thị fallback khi không có dữ liệu. |
| Tour | Hiển thị tên tour liên quan đến phân công. |
| Tour Guide | Hiển thị tên và số điện thoại hướng dẫn viên. |
| Meeting Point | Hiển thị điểm hẹn đã cấu hình hoặc fallback khi trống. |
| Pickup Time | Hiển thị thời gian đón theo định dạng `dd/MM/yyyy HH:mm`. |
| Assignment Date | Hiển thị ngày tạo phân công theo định dạng `dd/MM/yyyy HH:mm`. |
| View Button | Mở màn hình xem phân công tour. |
| Edit Button | Mở màn hình chỉnh sửa khi phân công chưa bị khóa. |
| Delete Button | Xóa phân công sau xác nhận khi phân công chưa bị khóa. |
| Locked Label | Thay thế Edit/Delete sau khi hướng dẫn viên xác nhận, bắt đầu hoặc hoàn tất tour. |
| Add Assignment Button | Mở màn hình thêm phân công tour. |
| Staff Home Button | Quay về Staff Home. |

### 3.3.2 Thêm Phân Công Tour

Tác nhân: Staff

Màn hình cho phép Staff:

- Chọn booking tour đã thanh toán và đủ điều kiện.
- Chọn hướng dẫn viên còn khả dụng.
- Nhập điểm hẹn.
- Xem thời gian đón và hạn check-in được tính tự động.
- Xem thông tin khách hàng, tuyến đường, lịch tour, số khách, trạng thái booking và tổng tiền trước khi phân công.
- Lưu phân công tour mới.
- Hủy thao tác và quay về danh sách phân công.

Màn hình cũng hỗ trợ:

- Chỉ hiển thị booking tour đã thanh toán và có lịch tour hợp lệ.
- Chỉ hiển thị hướng dẫn viên active và không có phân công đang mở khác.
- Hiển thị lỗi khi booking không đủ điều kiện, hướng dẫn viên không khả dụng, trùng khách hàng/hướng dẫn viên hoặc trùng lịch.
- Hiển thị thông báo thành công sau khi lưu phân công.

Quy tắc nghiệp vụ:

- Booking phải là booking loại `Tour`, có trạng thái booking đủ điều kiện và có bản ghi thanh toán thành công.
- Hướng dẫn viên được chọn phải có role TourGuide, active và không có phân công chưa hoàn tất.
- Cùng khách hàng hoặc cùng booking không được phân công hai lần cho cùng lịch tour.
- Cùng hướng dẫn viên không được phân công hai lần cho cùng lịch tour.
- Không được phân công hướng dẫn viên nếu khoảng ngày của tour ứng viên bị chồng với một phân công đang mở khác.
- Thời gian đón cố định bằng thời điểm khởi hành trừ 30 phút.
- Hạn check-in cố định bằng thời điểm khởi hành trừ 10 phút.

Mô tả trường:

| Trường | Mô tả |
|---|---|
| Booking Tour | Bắt buộc. Chỉ liệt kê booking tour đã thanh toán và đủ điều kiện. |
| Tour Guide | Bắt buộc. Chỉ liệt kê hướng dẫn viên active và đang khả dụng. |
| Meeting Point | Trường text tùy chọn cho điểm tập trung hoặc điểm đón. |
| Pickup Time | Giá trị chỉ đọc, tính bằng thời điểm khởi hành trừ 30 phút. |
| Check-in Deadline | Giá trị chỉ đọc, tính bằng thời điểm khởi hành trừ 10 phút. |
| Save Assignment Button | Kiểm tra dữ liệu và tạo phân công với mã `ASG` được sinh. |
| Cancel Button | Quay về danh sách phân công mà không lưu. |
| Available Booking Table | Hiển thị các booking hiện đủ điều kiện để phân công. |
| Booking Code | Hiển thị mã booking public và booking ID nội bộ. |
| Customer | Hiển thị tên và số điện thoại khách hàng. |
| Tour | Hiển thị tên tour. |
| Route | Hiển thị điểm bắt đầu và điểm kết thúc tour. |
| Schedule | Hiển thị ngày bắt đầu và ngày kết thúc theo định dạng `dd/MM/yyyy`. |
| Guest Count | Hiển thị tổng số người lớn và trẻ em. |
| Payment Status | Hiển thị `Paid` cho booking đủ điều kiện. |
| Total Price | Hiển thị tổng tiền booking với nhóm chữ số và hậu tố `VNĐ`. |

### 3.3.3 Chỉnh Sửa Phân Công Tour

Tác nhân: Staff

Màn hình cho phép Staff:

- Xem lại thông tin booking, tour, tuyến đường, lịch tour, khách hàng và Staff đã phân công.
- Thay hướng dẫn viên phụ trách.
- Cập nhật điểm hẹn.
- Xem thời gian đón và hạn check-in cố định.
- Lưu phân công đã cập nhật.
- Hủy và quay về danh sách phân công.

Màn hình cũng hỗ trợ:

- Phân công lại tour bị hướng dẫn viên trước đó từ chối.
- Chỉ hiển thị hướng dẫn viên đủ điều kiện thay thế.
- Hiển thị lỗi khi trùng khách hàng, trùng hướng dẫn viên, hướng dẫn viên không khả dụng hoặc trùng lịch.
- Quay về danh sách phân công sau khi cập nhật thành công.

Quy tắc nghiệp vụ:

- Staff không thể mở hoặc cập nhật màn hình này sau khi phân công đạt trạng thái `Accepted`, `Confirmed`, `In Progress` hoặc `Completed`.
- Khi thay hướng dẫn viên, hệ thống kiểm tra lại khả dụng, trùng dữ liệu và trùng ngày.
- Khi phân công bị từ chối được phân công lại, trạng thái trở về `Pending` và thông tin từ chối được xóa.
- Booking ID và tour schedule ID không được thay đổi trên màn hình này.
- Thời gian đón và hạn check-in được tính lại từ thời gian khởi hành của tour.

Mô tả trường:

| Trường | Mô tả |
|---|---|
| Assignment Code | Hiển thị mã phân công hoặc ID số. |
| Booking | Booking code chỉ đọc gắn với phân công. |
| Tour | Tên tour chỉ đọc. |
| Route | Điểm bắt đầu và điểm kết thúc chỉ đọc. |
| Tour Schedule | Ngày bắt đầu và kết thúc chỉ đọc theo định dạng `dd/MM/yyyy`. |
| Customer | Tên khách hàng chỉ đọc từ booking. |
| Assigned By | Tên Staff đã tạo phân công, chỉ đọc. |
| Responsible Tour Guide | Bắt buộc. Chọn hướng dẫn viên hiện tại hoặc hướng dẫn viên thay thế còn khả dụng. |
| Meeting Point | Điểm đón hoặc điểm tập trung có thể chỉnh sửa. |
| Pickup Time | Ngày giờ chỉ đọc, tính từ thời điểm khởi hành. |
| Check-in Deadline | Ngày giờ chỉ đọc, tính từ thời điểm khởi hành. |
| Update Button | Kiểm tra và lưu thay đổi phân công. |
| Cancel Button | Quay về danh sách phân công mà không lưu. |

### 3.3.4 Xem Phân Công Tour

Tác nhân: Staff

Màn hình cho phép Staff:

- Xem đầy đủ thông tin phân công, booking, tour, hướng dẫn viên, khách hàng, lịch tour và giá.
- Xem điểm hẹn, thời gian đón và hạn check-in.
- Xem số người lớn, trẻ em và tổng số khách trong booking.
- Xem sức chứa tour và số chỗ còn lại.
- Mở màn hình chỉnh sửa phân công khi phân công chưa bị khóa.
- Quay về danh sách phân công.

Màn hình cũng hỗ trợ:

- Hiển thị fallback khi thiếu dữ liệu booking, điểm hẹn hoặc Staff.
- Hiển thị mọi giá trị ngày giờ theo định dạng ngày/tháng/năm Việt Nam.
- Hiển thị tổng tiền booking với nhóm chữ số và hậu tố `VNĐ`.
- Ẩn nút Edit sau khi hướng dẫn viên xác nhận, bắt đầu hoặc hoàn tất tour.

Quy tắc nghiệp vụ:

- Màn hình chỉ đọc.
- Chỉ thao tác điều hướng sang edit phụ thuộc vào quy tắc khóa của Staff.
- Thông tin khách hàng và tổng tiền hiển thị đến từ booking gắn với phân công.

Mô tả trường:

| Trường | Mô tả |
|---|---|
| Assignment Code | Hiển thị mã phân công được sinh. |
| Booking | Hiển thị booking code hoặc booking ID nội bộ. |
| Booking Type | Hiển thị loại dịch vụ booking. |
| Tour | Hiển thị tên tour. |
| Tour Route | Hiển thị điểm bắt đầu và điểm kết thúc tour. |
| Schedule ID | Hiển thị ID lịch tour nội bộ. |
| Schedule | Hiển thị ngày bắt đầu và kết thúc theo định dạng `dd/MM/yyyy`. |
| Tour Guide | Hiển thị họ tên hướng dẫn viên. |
| Guide Contact | Hiển thị số điện thoại và email hướng dẫn viên. |
| Assigned By | Hiển thị Staff đã tạo phân công. |
| Assignment Date | Hiển thị ngày giờ phân công. |
| Meeting Point | Hiển thị điểm đón hoặc điểm tập trung. |
| Pickup / Check-in | Hiển thị thời gian đón và hạn check-in. |
| Customer | Hiển thị họ tên khách hàng trong booking. |
| Customer Contact | Hiển thị số điện thoại và email khách hàng. |
| Guest Count | Hiển thị tổng khách, số người lớn và số trẻ em. |
| Schedule Capacity | Hiển thị số chỗ đã đặt, sức chứa tối đa và số chỗ còn lại. |
| Booking Total | Hiển thị tổng tiền định dạng `VNĐ`. |
| Booking Date | Hiển thị ngày tạo booking. |
| Edit Assignment Button | Mở Edit Assignment khi phân công chưa bị khóa. |
| Back Button | Quay về danh sách phân công. |

## 3.4 Quản Lý Tour Được Phân Công

Chức năng quản lý tour được phân công hỗ trợ hướng dẫn viên xem các tour được phân công, xác nhận phân công, cập nhật điểm danh hành khách, ghi nhận tiến trình tour theo thời gian thực, báo cáo sự cố và hoàn tất tour.

### 3.4.1 Danh Sách Tour Được Phân Công

Tác nhân: Hướng dẫn viên

Màn hình cho phép Tour Guide:

- Xem tất cả tour được phân công cho hướng dẫn viên đang đăng nhập.
- Xem mã phân công, tour, ngày tour, tuyến đường, điểm hẹn, thời gian đón và trạng thái.
- Mở màn hình xem tour được phân công.
- Xác nhận tour ở trạng thái `Pending` hoặc `Assigned`.
- Quay về Tour Guide Home.

Màn hình cũng hỗ trợ:

- Phân biệt trạng thái phân công bằng nhãn trạng thái và màu sắc.
- Chỉ hiển thị nút Confirm cho tour `Pending` hoặc `Assigned`.
- Hiển thị empty-state khi chưa có tour được phân công.
- Chỉ hiển thị phân công thuộc tài khoản hướng dẫn viên hiện tại.

Quy tắc nghiệp vụ:

- Hướng dẫn viên chỉ được truy cập các phân công có `userID` khớp với hướng dẫn viên đã xác thực.
- Phân công `Cancelled` và `Rejected` bị loại khỏi danh sách active assigned-tour.
- Xác nhận phân công chuyển trạng thái sang `Confirmed` và mở khóa thao tác passenger/progress.
- Tour đã hoàn tất vẫn hiển thị để tham khảo nhưng không còn thao tác bổ sung.

Mô tả trường:

| Trường | Mô tả |
|---|---|
| Assignment Code | Hiển thị mã phân công hoặc ID số. |
| Tour | Hiển thị tên tour được phân công. |
| Tour Schedule | Hiển thị ngày khởi hành theo định dạng `dd/MM/yyyy`. |
| Route | Hiển thị điểm bắt đầu và kết thúc tour. |
| Meeting Point | Hiển thị điểm hẹn và thời gian đón. |
| Assignment Status | Hiển thị trạng thái workflow đã địa phương hóa kèm màu. |
| Detail Button | Mở màn hình xem tour được phân công. |
| Confirm Button | Xác nhận tour `Pending` hoặc `Assigned`; ẩn với trạng thái khác. |
| Tour Guide Home Button | Quay về dashboard của hướng dẫn viên. |

### 3.4.2 Xem Tour Được Phân Công

Tác nhân: Hướng dẫn viên

Màn hình cho phép Tour Guide:

- Xem tour được phân công, tuyến đường, lịch tour, điểm hẹn, thời gian đón và hạn check-in.
- Xem booking code, tên khách hàng, số điện thoại, email và tổng số khách.
- Xác nhận tour `Pending` hoặc `Assigned`.
- Cập nhật trạng thái phân công được hỗ trợ theo workflow hiện tại.
- Mở màn hình chỉnh sửa trạng thái hành khách sau khi xác nhận tour.
- Mở màn hình thêm log tiến trình tour sau khi xác nhận tour.
- Xem lịch sử progress log.

Màn hình cũng hỗ trợ:

- Hiển thị thông báo thành công/lỗi cho xác nhận, cập nhật hành khách, cập nhật trạng thái và progress log.
- Hiển thị trạng thái tiến trình với màu tương ứng completed, issue, pickup và in-progress.
- Không hiển thị control thao tác sau khi tour completed, cancelled hoặc rejected.
- Quay về danh sách tour được phân công.

Quy tắc nghiệp vụ:

- Thao tác passenger và progress chỉ khả dụng với phân công `Accepted`, `Confirmed` hoặc `In Progress`.
- Hướng dẫn viên phải xác nhận phân công trước khi cập nhật hành khách hoặc tiến trình.
- Tour đã hoàn tất không được nhận cập nhật bổ sung.
- Chuyển trạng thái phân công được server kiểm tra và giới hạn theo trạng thái hiện tại.
- Hoàn tất tour cập nhật phân công sang `Completed` và booking liên quan sang `End`.

Mô tả trường:

| Trường | Mô tả |
|---|---|
| Assignment Code | Hiển thị mã phân công hoặc ID số. |
| Confirm Tour Button | Xác nhận tour pending/assigned và bật thao tác tour. |
| Trip Status | Hiển thị và cập nhật trạng thái phân công hợp lệ tiếp theo. |
| Guide Note | Lưu ghi chú do hướng dẫn viên nhập cho cập nhật trạng thái. |
| Save Status Button | Gửi trạng thái workflow và guide note. |
| Tour | Hiển thị tên tour. |
| Route | Hiển thị điểm bắt đầu và kết thúc. |
| Tour Schedule | Hiển thị ngày bắt đầu/kết thúc. |
| Meeting Point | Hiển thị điểm hẹn đã cấu hình. |
| Pickup / Check-in | Hiển thị thời gian đón và hạn check-in. |
| Booking | Hiển thị booking code hoặc ID nội bộ. |
| Customer | Hiển thị tên khách hàng. |
| Customer Contact | Hiển thị số điện thoại và email khách hàng. |
| Guest Count | Hiển thị tổng số hành khách. |
| Update Passenger Button | Mở Edit Passenger Status khi phân công còn thao tác được. |
| Add Progress Log Button | Mở Add Tour Progress Log khi phân công còn thao tác được. |
| Progress Time | Hiển thị thời điểm log tiến trình. |
| Progress Status | Hiển thị trạng thái tiến trình đã địa phương hóa và màu. |
| Progress Title | Hiển thị title đã lưu hoặc title mặc định. |
| Progress Content | Hiển thị nội dung đã lưu hoặc fallback. |
| Back Button | Quay về danh sách tour được phân công. |

### 3.4.3 Chỉnh Sửa Trạng Thái Hành Khách

Tác nhân: Hướng dẫn viên

Màn hình cho phép Tour Guide:

- Xem tất cả traveler được sinh hoặc đã lưu cho booking của phân công.
- Cập nhật tên và số điện thoại của traveler không phải người đặt chính.
- Cập nhật trạng thái tham gia của từng traveler.
- Thêm hoặc cập nhật ghi chú vận hành cho từng traveler.
- Lưu từng dòng traveler độc lập.
- Quay về màn hình xem tour được phân công.

Màn hình cũng hỗ trợ:

- Hiển thị danh tính và liên hệ của khách đặt chính ở dạng chỉ đọc.
- Phân biệt người đặt chính với người lớn/trẻ em bổ sung.
- Hiển thị thông báo thành công sau khi lưu traveler.
- Hiển thị lỗi khi trạng thái không hợp lệ hoặc thao tác cập nhật traveler không được phép.

Quy tắc nghiệp vụ:

- Tên và số điện thoại của khách đặt chính là cố định.
- Tên và số điện thoại của traveler bổ sung có thể chỉnh sửa.
- Trạng thái traveler hợp lệ gồm `Pending`, `Checked-in`, `Absent` và `Completed`.
- Phân công phải thuộc hướng dẫn viên đang đăng nhập và ở trạng thái `Accepted`, `Confirmed` hoặc `In Progress`.
- Mỗi lần lưu chỉ cập nhật traveler được chọn.

Mô tả trường:

| Trường | Mô tả |
|---|---|
| Booking | Hiển thị booking code gắn với traveler. |
| Passenger | Hiển thị tên cố định của người đặt chính hoặc tên có thể sửa của traveler bổ sung. |
| Booker Indicator | Đánh dấu traveler đầu tiên là khách đặt booking. |
| Passenger Type | Hiển thị Adult hoặc Child. |
| Contact | Hiển thị liên hệ cố định của booker hoặc phone editable cho traveler khác. |
| Passenger Status | Chọn Not Checked-in, Checked-in, Absent hoặc Completed. |
| Note | Lưu ghi chú vận hành ngắn. |
| Save Button | Lưu dòng traveler được chọn. |
| Tour Header | Hiển thị tên tour, ngày khởi hành và điểm hẹn. |
| Back to Tour Button | Quay về màn hình xem tour được phân công. |

### 3.4.4 Thêm Log Tiến Trình Tour

Tác nhân: Hướng dẫn viên

Màn hình cho phép Tour Guide:

- Chọn trạng thái tiến trình cho tour được phân công.
- Nhập title progress log.
- Nhập nội dung chi tiết về tiến trình hoặc sự cố.
- Lưu progress log.
- Xem các log gần đây của cùng phân công.
- Hủy và quay về màn hình xem tour được phân công.

Màn hình cũng hỗ trợ:

- Ghi nhận các sự kiện pickup, depart, arrive, returning, completion hoặc issue.
- Hiển thị thời gian log, trạng thái đã địa phương hóa, title và content của log hiện có.
- Hiển thị màu theo từng trạng thái trong bảng recent log.
- Tự động thông báo cho Staff khi tạo log `Issue`.

Quy tắc nghiệp vụ:

- Phân công phải thuộc hướng dẫn viên đang đăng nhập và ở trạng thái `Accepted`, `Confirmed` hoặc `In Progress`.
- Trạng thái progress hợp lệ gồm `Pickup Completed`, `Departed`, `Arrived`, `Returning`, `Completed` và `Issue`.
- Progress bình thường chuyển phân công sang `In Progress`.
- `Issue` tạo notification chưa đọc cho Staff đã phân công tour.
- `Completed` hoàn tất phân công, đặt booking status thành `End` và giải phóng hướng dẫn viên để nhận phân công khác.
- Không thể thêm progress log sau khi tour hoàn tất.

Mô tả trường:

| Trường | Mô tả |
|---|---|
| Progress Status | Bắt buộc. Chọn Picked Up, Departed, Arrived, Returning, End Tour hoặc Issue. |
| Title | Title ngắn tùy chọn cho sự kiện tiến trình. |
| Content | Nội dung chi tiết tùy chọn cho tiến trình hoặc sự cố. |
| Save Log Button | Kiểm tra và lưu progress log, sau đó cập nhật trạng thái workflow. |
| Cancel Button | Quay về View Assigned Tour mà không lưu. |
| Tour Header | Hiển thị tên tour, ngày khởi hành và điểm hẹn. |
| Log Time | Hiển thị thời điểm tạo progress entry. |
| Log Status | Hiển thị progress status đã địa phương hóa kèm màu. |
| Log Title | Hiển thị title đã lưu hoặc title mặc định. |
| Log Content | Hiển thị content đã lưu hoặc fallback. |
| Recent Log Table | Hiển thị toàn bộ progress log của phân công hiện tại theo thứ tự mới nhất trước. |

## Khoảng Trống Yêu Cầu

- Requirement cho các module ngoài `3.3 Quản Lý Phân Công Tour` và `3.4 Quản Lý Tour Được Phân Công` là Chưa xác minh trong SRS này.
- DDL tạo schema chính xác cho các bảng assignment liên quan là Chưa xác minh từ migration trong repository.
- Asset screenshot tồn tại trong `docs/srs_assignment_assets/screens`, nhưng việc QA hình ảnh của DOCX sinh ra là Chưa xác minh trong file Markdown này.
