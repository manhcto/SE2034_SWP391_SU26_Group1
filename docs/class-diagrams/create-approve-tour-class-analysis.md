# Create and Approve Tour Class Analysis

## Source Of Truth

Phân tích này dựa trên source code hiện tại trong repository. Các file Java/JSP/SQL/business logic không được chỉnh sửa trong tác vụ này; chỉ tạo tài liệu class diagram.

## Repository Evidence

Các vùng source đã được rà soát:

- Staff create controllers: `AddTourController`, `AddTourScheduleController`, `SubmitTourForApprovalController`.
- Shared staff support classes: `StaffTourFormSupport`, `StaffTourScheduleSupport`.
- Admin approval controllers: `AdminTourDetailController`, `AdminTourApproveController`.
- Filters: `StaffAuthenticationFilter`, `AdminAuthenticationFilter`, `AuthenticationFilterSupport`.
- DAO and utilities: `TourDAO`, `AdministrativeUnitDAO`, `DBConnection`, `TourImageStorage`.
- Models: `Tour`, `TourSchedule`, `TourItinerary`, `TourImage`, `TourCategory`, `Region`, `AdministrativeUnit`, `User`.

## Confirmed Class Inventory

| Class | Package | Stereotype | Use Case | Evidence |
|---|---|---|---|---|
| `HttpServlet` | `jakarta.servlet.http` | `<<framework>>` | Create, Approve | Base framework class extended by controllers/support classes. |
| `Filter` | `jakarta.servlet` | `<<interface>>` | Create, Approve | Implemented by Staff/Admin authentication filters. |
| `AuthenticationFilterSupport` | `vn.edu.fpt.filter` | `<<filter>>` | Create, Approve | Shared auth helper for role checks and redirect/deny behavior. |
| `StaffAuthenticationFilter` | `vn.edu.fpt.filter` | `<<filter>>` | Create | Protects `/staff/*`; checks Staff role. |
| `AdminAuthenticationFilter` | `vn.edu.fpt.filter` | `<<filter>>` | Approve | Protects `/admin/*`; checks Admin role. |
| `AddTourController` | `vn.edu.fpt.controller.staff` | `<<controller>>` | Create | Handles `/staff/tour/add`, creates base Tour and redirects to schedule add. |
| `StaffTourFormSupport` | `vn.edu.fpt.controller.staff` | `<<support>>` | Create | Reads, validates, builds Tour; owns `TourDAO` and `AdministrativeUnitDAO`. |
| `TourFormData` | `vn.edu.fpt.controller.staff.StaffTourFormSupport` | `<<form_data>>` | Create | Nested class used to move add/edit Tour form values through validation/building. |
| `AddTourScheduleController` | `vn.edu.fpt.controller.staff` | `<<controller>>` | Create | Handles `/staff/tour/schedule/add`, creates schedule after Tour exists. |
| `StaffTourScheduleSupport` | `vn.edu.fpt.controller.staff` | `<<support>>` | Create | Reads/validates/builds schedule; checks duplicate date, min date gap, capacity, prices. |
| `ScheduleFormData` | `vn.edu.fpt.controller.staff.StaffTourScheduleSupport` | `<<form_data>>` | Create | Nested class used to move schedule form values through validation/building. |
| `SubmitTourForApprovalController` | `vn.edu.fpt.controller.staff` | `<<controller>>` | Related but excluded from Create diagram | Separate endpoint `/staff/tour/submit`; source does not auto-execute it during create. |
| `AdminTourDetailController` | `vn.edu.fpt.controller.admin` | `<<controller>>` | Approve | Loads Tour, itinerary, schedule, managed images and readiness errors before approval. |
| `AdminTourApproveController` | `vn.edu.fpt.controller.admin` | `<<controller>>` | Approve | Handles `/admin/tour/approve`, validates status/readiness and calls DAO approval. |
| `TourDAO` | `vn.edu.fpt.DAO` | `<<dao>>` | Create, Approve | Central persistence class for Tour, Itinerary, Image, Schedule, readiness and approval. |
| `AdministrativeUnitDAO` | `vn.edu.fpt.DAO` | `<<dao>>` | Create | Validates active province names used by start/end place fields. |
| `DBConnection` | `vn.edu.fpt.common` | `<<utility>>` | Create, Approve | DAO opens JDBC connection through this utility. |
| `TourImageStorage` | `vn.edu.fpt.common` | `<<utility>>` | Create | Validates and saves multipart tour image uploads. |
| `User` | `vn.edu.fpt.model` | `<<entity>>` | Create, Approve | Session user supplies Staff creator and Admin approver IDs. |
| `Tour` | `vn.edu.fpt.model` | `<<entity>>` | Create, Approve | Main aggregate/entity for created and approved Tour data. |
| `TourSchedule` | `vn.edu.fpt.model` | `<<entity>>` | Create, Approve | Schedule is created after Tour; approval can optionally open valid Planned schedules. |
| `TourItinerary` | `vn.edu.fpt.model` | `<<entity>>` | Create, Approve | Itinerary days are inserted during create and checked for readiness during approval. |
| `TourImage` | `vn.edu.fpt.model` | `<<entity>>` | Create, Approve | Managed image records are inserted/loaded by `TourDAO`. |
| `TourCategory` | `vn.edu.fpt.model` | `<<entity>>` | Create, Approve | `Tour` references category; create validates active category. |
| `Region` | `vn.edu.fpt.model` | `<<entity>>` | Create, Approve | `Tour` references region; create validates active region. |
| `AdministrativeUnit` | `vn.edu.fpt.model` | `<<entity>>` | Create | Returned by `AdministrativeUnitDAO` for active province data. |

## Create Tour Findings

- `AddTourController.doPost` forces `data.status = "Draft"`.
- `AddTourController` calls `validateTourData(data, false)` and then `buildTourFromData(data, currentUserID, false)`.
- Because `includeInitialSchedule` is passed as `false`, base Tour creation does not insert schedule through `StaffTourFormSupport.buildInitialSchedule`.
- `TourDAO.insertTourWithItineraries` inserts Tour, updates/generated `tourCode`, inserts itineraries, replaces managed images, and returns the generated `tourID`.
- On successful Tour insert, `AddTourController` redirects to `/staff/tour/schedule/add?tourID=...&message=tourCreated`.
- `AddTourScheduleController` loads the created Tour using `getTourForSchedule`, checks `canManageScheduleForTour`, reads form data, validates schedule and inserts via `TourDAO.insertTourSchedule`.
- Schedule status is resolved by support/controller logic, not freely selected by Staff in the create path. Default schedule status is `Open` only when `canOpenScheduleForTour(tour)` is true; otherwise `Planned`.
- Creating a schedule does not submit the Tour for approval. `SubmitTourForApprovalController` is a separate action and validates readiness before calling `TourDAO.submitTourForApproval`.

## Approve Tour Findings

- Admin auth is handled by `AdminAuthenticationFilter`, using `AuthenticationFilterSupport` and `User` from session.
- `AdminTourApproveController.doPost` reads `tourID` and admin `User` from the session.
- It loads the Tour through `TourDAO.getTourById`.
- Source requires `tour.getStatus()` to equal `"Pending"` before approval.
- Approval is blocked when `TourDAO.getTourReadinessErrors(tourID)` returns errors.
- `TourDAO.getTourReadinessErrors` checks Tour base data, image, itinerary count, valid schedule count and duplicate schedule start dates.
- `TourDAO.approveTour` updates the Tour to `Active`, stores `approvedByUserID`, stores `approvedAt`, clears `rejectionReason`, updates `updatedAt`, and optionally opens valid `Planned` schedules.
- Only schedules satisfying the DAO update condition are opened: same Tour, `scheduleStatus = 'Planned'`, future/current `startDate`, and `quantity < maxParticipants`.

## Multiplicity Decisions

| Relationship | Multiplicity | Evidence |
|---|---:|---|
| `TourCategory` to `Tour` | `1` to `0..*` | Create validates category; many tours can share category. |
| `Region` to `Tour` | `1` to `0..*` | Create validates region; many tours can share region. |
| `User` to created `Tour` | `0..1` to `0..*` | `createdByUserID` is `Integer`; source sets from session when present. |
| `User` to approved `Tour` | `0..1` to `0..*` | Draft/Pending tours have no approver; approval sets `approvedByUserID`. |
| `Tour` to `TourItinerary` | `1` to `1..*` | Valid create requires itinerary by number of days; DAO inserts itinerary rows for Tour. |
| `Tour` to `TourSchedule` | `1` to `0..*` | Tour is inserted first and may exist before schedule; one Tour can have many schedules. |
| `Tour` to `TourImage` | `1` to `0..*` | Managed images are optional during create but required by readiness before approval. |

## Exclusions

- Staff/Admin actors are represented by the existing `User` model with role data, not separate classes.
- JSP pages, URLs, form buttons, request/response/session objects, SQL statements and database tables are not drawn as classes.
- `SubmitTourForApprovalController` is analyzed but excluded from the Create Tour diagram because it is a separate endpoint and is not automatically invoked by Tour or Schedule creation.
- `AdminTourRejectController` and `TourDAO.rejectTour` are excluded from the Approve Tour diagram because Reject Tour is a separate endpoint/use case.
- Booking and BookingDetail are excluded from the Approve Tour diagram because the current approval implementation does not directly call those classes.

## Generated Files

- `docs/class-diagrams/create-tour-class-diagram.mmd`
- `docs/class-diagrams/approve-tour-class-diagram.mmd`
- `docs/class-diagrams/create-tour-class-diagram.md`
- `docs/class-diagrams/approve-tour-class-diagram.md`
- `docs/class-diagrams/create-approve-tour-class-analysis.md`
