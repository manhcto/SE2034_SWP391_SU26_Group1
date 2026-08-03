# Staff Tour Main Business Process Analysis

## Checked Code

- `src/main/java/vn/edu/fpt/controller/staff/ListTourController.java`
- `src/main/java/vn/edu/fpt/controller/staff/AddTourController.java`
- `src/main/java/vn/edu/fpt/controller/staff/EditTourController.java`
- `src/main/java/vn/edu/fpt/controller/staff/DetailTourController.java`
- `src/main/java/vn/edu/fpt/controller/staff/ListTourScheduleController.java`
- `src/main/java/vn/edu/fpt/controller/staff/AddTourScheduleController.java`
- `src/main/java/vn/edu/fpt/controller/staff/EditTourScheduleController.java`
- `src/main/java/vn/edu/fpt/controller/staff/SubmitTourForApprovalController.java`
- `src/main/java/vn/edu/fpt/controller/admin/AdminTourListController.java`
- `src/main/java/vn/edu/fpt/controller/admin/AdminTourDetailController.java`
- `src/main/java/vn/edu/fpt/controller/admin/AdminTourApproveController.java`
- `src/main/java/vn/edu/fpt/controller/admin/AdminTourRejectController.java`
- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- `src/main/java/vn/edu/fpt/model/Tour.java`
- `src/main/java/vn/edu/fpt/model/TourSchedule.java`
- `../../src/main/webapp/views/staff/tour-list.jsp`
- `src/main/webapp/views/staff/tour-form.jsp`
- `src/main/webapp/views/staff/tour-detail.jsp`
- `src/main/webapp/views/staff/tour-schedule-list.jsp`
- `src/main/webapp/views/staff/tour-schedule-form.jsp`
- `src/main/webapp/views/admin/admin-tour-list.jsp`
- `src/main/webapp/views/admin/admin-tour-detail.jsp`
- `D:/SWP391_G1/SQLQuery1.sql`

## Actual Business Flow Found From Code

1. Staff opens Tour Management.
2. System displays the tour management page and tour creation form.
3. Staff creates a tour and fills in tour details, images, and itinerary.
4. Staff submits tour information.
5. System validates and saves tour information when valid.
6. Staff prepares departure schedules for the tour.
7. System validates and saves schedule information when valid.
8. Staff reviews the prepared tour and sends an approval request.
9. System checks whether the tour is ready for approval.
10. Admin receives and reviews the approval request.
11. Admin approves or rejects the request.
12. If approved, System saves the approval result and notifies Staff.
13. If rejected, Admin provides a rejection reason, System saves the rejection result and notifies Staff.
14. Staff revises the tour or schedule and sends the approval request again.

## Business Rules Reflected In Diagram

- Staff is responsible for creating the package tour, entering tour details, preparing schedules, submitting the approval request, and revising rejected tours.
- System is responsible for displaying forms, validating submitted information, saving information, checking readiness, saving approval results, and notifying Staff.
- Admin is responsible for reviewing the approval request and deciding whether to approve or reject it.
- Invalid tour or schedule information returns to the related Staff input step.
- Not-ready approval requests return to Staff revision.
- Rejected requests return to Staff revision and resubmission.
- Approved requests end with Staff receiving an approval notice.

## Diagram Scope Notes

- The diagram intentionally does not display internal status names such as approval states or schedule states.
- The diagram intentionally does not include class names, controller names, DAO methods, URLs, SQL statements, database tables, HTTP methods, transactions, or field-level validation.
- The diagram does not include Customer Booking, Payment, Accommodation, Voucher, Feedback, Blog, Dashboard, Assignment, Resource Allocation, reports, or login details.

## Old Or Excluded Code

- `src/main/java/vn/edu/fpt/controller/staff/ManageTourController.java` was excluded because it has no servlet mapping and no implemented process.
- `src/main/java/vn/edu/fpt/controller/staff/ManageTourGuideController.java` was excluded because it has no servlet mapping and is outside this tour creation and approval process.
- Admin inactive/reactivate operations were excluded because they are outside the requested main business process.

## Unresolved Findings

- The schema defaults for new tour and schedule records do not fully match the application-created values. The diagram follows the application flow discovered from controller, DAO, JSP, and model usage.
