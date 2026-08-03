# UML Class Diagram Analysis - Management Tour And Management Schedule

This analysis is based on repository-wide source inspection from the workspace root. The diagrams are Design Class Diagrams for SDS documentation and intentionally focus only on classes and artifacts that participate in the two requested modules.

Generated diagrams:

- `docs/uml/management-tour-class-diagram.mmd`
- `docs/uml/management-schedule-class-diagram.mmd`

## Repository-Wide Trace Summary

Search terms used across the repository included:

- `Tour`, `TourSchedule`, `TourScheduler`, `TourItinerary`, `TourImage`, `TourCategory`, `Region`, `AdministrativeUnit`
- `/staff/tour`, `/admin/tour`, `/tour`, `/schedule`
- create/add/edit/update/delete/view/submit/approve/reject/open/close/status methods
- SQL tables and foreign keys for `Tour`, `Tour_Scheduler`, `Tour_Itinerary`, `Tour_Image`, `Tour_Category`, `Region`, `Administrative_Unit`, `Booking_Detail`

Important source files inspected:

- Staff Tour controllers: `ListTourController`, `AddTourController`, `EditTourController`, `DetailTourController`, `SubmitTourForApprovalController`
- Staff Schedule controllers: `ListTourScheduleController`, `AddTourScheduleController`, `EditTourScheduleController`, `DetailTourScheduleController`, `CloseTourScheduleController`
- Admin Tour controllers: `AdminTourListController`, `AdminTourDetailController`, `AdminTourApproveController`, `AdminTourRejectController`, `AdminTourStatusController`
- Support classes: `StaffTourFormSupport`, `StaffTourScheduleSupport`
- DAO classes: `TourDAO`, `AdministrativeUnitDAO`, `BookingDAO`
- Utility class: `TourImageStorage`
- Entity/model classes: `Tour`, `TourSchedule`, `TourItinerary`, `TourImage`, `TourCategory`, `Region`, `AdministrativeUnit`, `User`, `Booking`, `BookingDetail`
- Authorization filters: `StaffAuthenticationFilter`, `AdminAuthenticationFilter`, `AuthenticationFilterSupport`
- JSP artifacts: staff/admin tour pages and staff schedule pages
- SQL/migration artifacts: `database/migrations/*`, `database/query-flows/*`, and the provided `D:/Downloads/5.0.sql`

## Diagram 1 - Management Tour

### Included Scope

The Tour Management diagram includes the actual Staff and Admin management flow:

- Staff lists/searches/filters Tour using `ListTourController`.
- Staff adds Tour using `AddTourController` through `StaffTourFormSupport`.
- Staff edits Tour using `EditTourController`; the support class enforces edit restrictions by status.
- Staff views Tour detail using `DetailTourController`.
- Staff submits Tour for Admin approval using `SubmitTourForApprovalController`.
- Admin lists/searches/filters tours using `AdminTourListController`.
- Admin views details using `AdminTourDetailController`.
- Admin approves/rejects/status-updates Tour using `AdminTourApproveController`, `AdminTourRejectController`, and `AdminTourStatusController`.
- Tour category, region, administrative units, managed images, itinerary, created/approved users, and schedule summary are included because source code directly joins or validates them.

### Main Structural Findings

- There is no separate service layer for these two modules. Business rules are split between controllers, support classes, and `TourDAO`.
- `AddTourController` and `EditTourController` inherit from `StaffTourFormSupport`.
- `StaffTourFormSupport` owns form reading, validation, entity construction, upload handling, and field preservation rules.
- `TourDAO` is the central persistence class for Tour CRUD, itinerary, managed images, approval readiness, submit/approve/reject, and status update.
- `AdministrativeUnitDAO` validates `startPlace` and `endPlace`.
- `TourImageStorage` persists uploaded tour images outside the database and returns a public path stored by Tour/Tour_Image rows.
- `Tour` owns `List<TourItinerary>` and `List<TourSchedule>` in the model.
- `TourImage` exists as a model class and database table. The current `Tour` model does not store `List<TourImage>`; `TourDAO` manages image rows by caption.

### Domain Multiplicity

- `TourCategory 1 -> 0..* Tour`
- `Region 0..1 -> 0..* Tour`
- `User 0..1 -> 0..* Tour` as creator and approver
- `Tour 1 -> 1..* TourItinerary`
- `Tour 1 -> 0..* TourImage` as managed image rows
- `Tour 1 -> 0..* TourSchedule` as schedule summary/detail loading

### Status Modeling

No `TourStatus` enum class exists in the current source. Tour status is stored as `String`, with source literals:

- `Draft`
- `Pending`
- `Active`
- `Rejected`
- `Inactive`

Display text is handled by `Tour.getDisplayStatus()`.

## Diagram 2 - Management Schedule

### Included Scope

The Schedule Management diagram includes:

- Staff views all schedules or schedules of a Tour through `ListTourScheduleController`.
- Staff adds schedule through `AddTourScheduleController`.
- Staff edits schedule through `EditTourScheduleController`.
- Staff views schedule detail through `DetailTourScheduleController`.
- Staff closes schedule through `CloseTourScheduleController`.
- Shared schedule rules live in `StaffTourScheduleSupport`.
- `TourDAO` handles schedule CRUD/status operations and duplicate/gap/price-warning checks.
- `BookingDAO`, `Booking`, and `BookingDetail` are included as an external booking dependency because `BookingDAO` directly reads and updates `Tour_Scheduler.quantity`.

### Main Structural Findings

- Every staff schedule controller extends `StaffTourScheduleSupport`.
- `StaffTourScheduleSupport` stores transport seat options and validates date, seat, price, booking deadline, duplicate date, date gap, and schedule status.
- `TourDAO.getTourForSchedule(...)` is reached through the support class and loads Tour plus schedules.
- `TourDAO.syncOpenSchedulesWithTourStatus(...)` and `syncOpenSchedulesWithTourStatuses(...)` keep schedule status aligned with Tour status.
- `TourDAO.insertTourSchedule(...)`, `updateTourSchedule(...)`, `updateTourScheduleLimited(...)`, and `closeTourSchedule(...)` are the central schedule persistence methods.
- `BookingDAO` creates, edits, cancels, and releases booking capacity by updating `Tour_Scheduler.quantity`.

### Domain Multiplicity

- `Tour 1 -> 0..* TourSchedule`
- `Booking 1 -> 0..* BookingDetail`
- `BookingDetail 0..* -> 0..1 TourSchedule`
- `Booking 0..* -> 0..1 TourSchedule` through `detailTourScheduleID` convenience fields on `Booking`

### Schedule Validation In Source

The source validates:

- Tour exists and is not `Inactive` for schedule management.
- Active Tours do not allow editing existing schedules; Staff should add new schedules instead.
- Start date and end date are required and must match Tour duration.
- Start date must not be in the past.
- Duplicate start date is checked with `TourDAO.isDuplicateScheduleStartDate(...)`.
- Minimum start-date gap is checked with `TourDAO.isScheduleStartDateTooClose(..., 3)`.
- Booking deadline must be before start date.
- Seat capacity must match `TRANSPORT_SEATS`.
- Max participants per booking must not exceed total seats and should not exceed 20.
- Adult price must be greater than `100000`.
- Child price must equal 50 percent of adult price.
- Infant price is currently validated as `0` in source.
- Single room surcharge must be greater than or equal to `0`.
- Final schedules cannot be edited.
- Schedules with existing bookings use limited update behavior.

### Status Modeling

No `ScheduleStatus` enum class exists in the current source. Schedule status is stored as `String`, with source literals:

- `Planned`
- `Open`
- `Closed`
- `Completed`
- `Cancelled`

Display text and "upcoming soon" behavior are handled by `TourSchedule.getDisplayScheduleStatus()` and `TourSchedule.isUpcomingSoon()`.

## Classes Deliberately Not Expanded

The following areas were found but not expanded in the diagrams to keep the SDS diagrams focused:

- Customer `TourController`: it displays published tours and details for customers, but it is not part of management.
- Tour guide assignment/resource allocation views: they reference schedules but represent assignment/resource modules, not Management Schedule itself.
- Accommodation, voucher, blog, room, payment, dashboard, and feedback modules: they are unrelated to the requested class diagrams.
- `AdminVatController.java`: not present in `src/main/java`; only an old compiled class remains under `out/production`, so it is not included.
- Enum classes for Tour/Schedule statuses: not found in source. Status is currently String-based.

## Diagram Usage Notes

- The Mermaid diagrams intentionally show important fields and business methods, not every getter/setter.
- JSP pages are represented as `<<view>>` artifacts so the SDS can show controller-forward and form-action relationships. They are not Java classes.
- `BookingDetail` exists as an empty Java class, while `BookingDAO` uses the `Booking_Detail` SQL table directly. The diagram marks this explicitly to avoid pretending the Java model has fields it does not currently implement.
