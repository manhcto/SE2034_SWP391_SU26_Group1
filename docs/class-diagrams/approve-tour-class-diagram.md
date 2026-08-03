# Approve Tour Class Diagram

## Scope

Diagram này mô tả luồng duyệt Tour hiện tại phía Admin. Source có màn chi tiết để Admin xem dữ liệu trước khi duyệt (`AdminTourDetailController`) và request duyệt chính thức qua `AdminTourApproveController`.

Điều kiện được xác nhận từ source:

- Tour phải đang có `status = "Pending"` trước khi duyệt.
- `TourDAO.getTourReadinessErrors(tourID)` kiểm tra dữ liệu sẵn sàng, gồm thông tin Tour, ảnh, itinerary, lịch hợp lệ và ngày khởi hành trùng.
- `TourDAO.approveTour(tourID, adminUserID, openValidSchedules)` update Tour thành `Active`, set `approvedByUserID`, `approvedAt`, clear `rejectionReason`, update `updatedAt`.
- Mở lịch là tùy chọn theo tham số `openSchedules`; chỉ các lịch `Planned`, còn hiệu lực và còn chỗ mới được đổi sang `Open`.
- Reject Tour là endpoint/use case riêng (`AdminTourRejectController`, `TourDAO.rejectTour`) nên không đưa vào diagram này.
- Booking/BookingDetail không được đưa vào vì source duyệt Tour hiện tại không gọi trực tiếp các class đó.

## Confirmed Classes

| Class | Package | Stereotype | Use Case | Evidence |
|---|---|---|---|---|
| `AdminAuthenticationFilter` | `vn.edu.fpt.filter` | `<<filter>>` | Approve Tour | `@WebFilter` bảo vệ `/admin/*`, `extends AuthenticationFilterSupport`, `implements Filter`. |
| `AuthenticationFilterSupport` | `vn.edu.fpt.filter` | `<<filter>>` | Approve Tour | Cung cấp `getCurrentUser`, `hasRole`, `redirectToLogin`, `deny` cho Admin filter. |
| `AdminTourDetailController` | `vn.edu.fpt.controller.admin` | `<<controller>>` | Approve Tour | Load Tour, itineraries, schedules, images và readiness trước khi Admin duyệt. |
| `AdminTourApproveController` | `vn.edu.fpt.controller.admin` | `<<controller>>` | Approve Tour | `@WebServlet("/admin/tour/approve")`, kiểm tra status/readiness và gọi `approveTour`. |
| `TourDAO` | `vn.edu.fpt.DAO` | `<<dao>>` | Approve Tour | Load Tour, kiểm tra readiness, itinerary, schedule, duplicate date, approve transaction. |
| `DBConnection` | `vn.edu.fpt.common` | `<<utility>>` | Approve Tour | DAO mở connection để query/update. |
| `User` | `vn.edu.fpt.model` | `<<entity>>` | Approve Tour | Admin lấy từ session và dùng `userID` làm `approvedByUserID`. |
| `Tour` | `vn.edu.fpt.model` | `<<entity>>` | Approve Tour | Entity được kiểm tra trạng thái và update metadata duyệt. |
| `TourSchedule` | `vn.edu.fpt.model` | `<<entity>>` | Approve Tour | Readiness kiểm tra lịch hợp lệ; approval có thể mở lịch `Planned`. |
| `TourItinerary` | `vn.edu.fpt.model` | `<<entity>>` | Approve Tour | Readiness kiểm tra số ngày itinerary active. |
| `TourImage` | `vn.edu.fpt.model` | `<<entity>>` | Approve Tour | Detail controller load managed images để Admin xem. |
| `TourCategory` | `vn.edu.fpt.model` | `<<entity>>` | Approve Tour | Quan hệ domain của `Tour`. |
| `Region` | `vn.edu.fpt.model` | `<<entity>>` | Approve Tour | Quan hệ domain của `Tour`. |

## Class Diagram

```mermaid
classDiagram
direction TB

class HttpServlet {
  <<framework>>
}

class Filter {
  <<interface>>
  +doFilter(request: ServletRequest, response: ServletResponse, chain: FilterChain): void
}

class AuthenticationFilterSupport {
  <<filter>>
  #getCurrentUser(request: HttpServletRequest): User
  #hasRole(user: User, roleID: int, roleNames: String): boolean
  #redirectToLogin(request: HttpServletRequest, response: HttpServletResponse): void
  #deny(response: HttpServletResponse): void
}

class AdminAuthenticationFilter {
  <<filter>>
  +doFilter(request: ServletRequest, response: ServletResponse, chain: FilterChain): void
}

class AdminTourDetailController {
  <<controller>>
  -tourDAO: TourDAO
  +init(): void
  #doGet(request: HttpServletRequest, response: HttpServletResponse): void
  -resolveDisplayAdultPrice(tour: Tour): BigDecimal
  -parseInt(raw: String): int
}

class AdminTourApproveController {
  <<controller>>
  -tourDAO: TourDAO
  +init(): void
  #doPost(request: HttpServletRequest, response: HttpServletResponse): void
  -parseInt(raw: String): int
}

class TourDAO {
  <<dao>>
  +getTourById(tourID: int): Tour
  +getItinerariesByTourId(tourID: int): List~TourItinerary~
  +getSchedulesByTourId(tourID: int): List~TourSchedule~
  +loadManagedImages(tour: Tour): void
  +getTourReadinessErrors(tourID: int): List~String~
  +getDuplicateScheduleStartDateMap(tourID: int): Map
  +approveTour(tourID: int, adminUserID: int, openValidSchedules: boolean): boolean
  -countActiveItineraries(tourID: int): int
  -countValidSchedulesForApproval(tourID: int): int
}

class DBConnection {
  <<utility>>
  +getConnection(): Connection
}

class User {
  <<entity>>
  -userID: int
  -email: String
  -roleID: int
  -roleName: String
  -status: String
}

class Tour {
  <<entity>>
  -tourID: int
  -tourCategoryID: int
  -tourName: String
  -tourCode: String
  -numberOfDay: int
  -startPlace: String
  -endPlace: String
  -image: String
  -adultPrice: BigDecimal
  -status: String
  -regionID: Integer
  -approvedByUserID: Integer
  -approvedAt: Timestamp
  -rejectionReason: String
  -updatedAt: Timestamp
  -itineraryList: List~TourItinerary~
  -scheduleList: List~TourSchedule~
}

class TourSchedule {
  <<entity>>
  -tourScheduleID: int
  -tourID: int
  -startDate: Timestamp
  -endDate: Timestamp
  -bookingDeadline: Timestamp
  -maxParticipants: int
  -quantity: int
  -adultPrice: BigDecimal
  -childPrice: BigDecimal
  -singleRoomSurcharge: BigDecimal
  -scheduleStatus: String
}

class TourItinerary {
  <<entity>>
  -itineraryID: int
  -tourID: int
  -dayNumber: int
  -title: String
  -description: String
  -status: String
}

class TourImage {
  <<entity>>
  -imageID: int
  -tourID: int
  -imageUrl: String
  -caption: String
  -displayOrder: int
  -status: String
}

class TourCategory {
  <<entity>>
  -tourCategoryID: int
  -categoryName: String
  -status: String
}

class Region {
  <<entity>>
  -regionID: int
  -regionName: String
  -status: String
}

HttpServlet <|-- AdminTourDetailController
HttpServlet <|-- AdminTourApproveController
AuthenticationFilterSupport <|-- AdminAuthenticationFilter
Filter <|.. AdminAuthenticationFilter

AuthenticationFilterSupport ..> User : reads session user
AdminTourDetailController ..> TourDAO : loads review data
AdminTourDetailController ..> Tour : displays approval detail
AdminTourApproveController ..> TourDAO : approves
AdminTourApproveController ..> User : reads admin session
AdminTourApproveController ..> Tour : checks status
TourDAO ..> DBConnection : opens connection
TourDAO ..> Tour : maps and updates
TourDAO ..> TourItinerary : checks active days
TourDAO ..> TourSchedule : checks and opens
TourDAO ..> TourImage : loads managed images

TourCategory "1" <-- "0..*" Tour : category
Region "1" <-- "0..*" Tour : region
User "0..1" <-- "0..*" Tour : approvedBy
Tour "1" *-- "1..*" TourItinerary : readiness
Tour "1" *-- "0..*" TourSchedule : schedules
Tour "1" o-- "0..*" TourImage : managedImages
```
