# Screen Flow Analysis

## Repository-Wide Search Performed

Inspected the complete source tree from the repository root, including:

- Java controllers under `src/main/java/vn/edu/fpt/controller`.
- Authentication and authorization filters under `src/main/java/vn/edu/fpt/filter`.
- JSP views under `src/main/webapp/views` and `src/main/webapp/WEB-INF/views`.
- Shared headers, sidebars and footers under `views/common` and `WEB-INF/views/common`.
- JavaScript files under `src/main/webapp/assets/js`.
- `src/main/webapp/WEB-INF/web.xml`.
- Existing docs and database folders were checked for context, but screens were included only when an active route/view/link was confirmed in source.

## Confirmed Screens

The complete confirmed inventory is maintained in `screen-inventory.md`. The inventory contains 58 confirmed screen nodes.

## Confirmed Roles

| Role | Evidence |
|---|---|
| Shared/Public | Public controllers such as `HomeController`, `LoginController`, `RegisterController`; public header/footer links. |
| Customer | `CustomerAuthenticationFilter` checks role ID `4` or role name `Customer`; protected account/booking/profile routes. |
| Staff | `StaffAuthenticationFilter` checks role ID `2` or role name `Staff`; `/staff/*` screens. |
| Admin | `AdminAuthenticationFilter` checks role ID `1` or role name `Admin`; `/admin/*` screens. |
| TourGuide | `GuideAuthenticationFilter` checks role ID `3` or role names `TourGuide`, `Tour Guide`, `Guide`; `/guide/*` screens. |

## Entry Points

- `/home`: public home and role-aware redirect hub for logged-in Admin, Staff and TourGuide users.
- `/login`: authentication entry point and protected-route redirect target.
- `/register`, `/forgot-password`: public authentication support entry points.
- `/tour`, `/accommodation`, `/vouchers`, `/blog`: public module entry points from client header/footer.
- `/admin/home`, `/staff/home`, `/guide/home`: role dashboard entry points after login.

## Navigation Evidence

| From Screen | Action | To Screen | Evidence |
|---|---|---|---|
| Home | Header/footer Tour link | Tour List | `client-header.jsp`, `client-footer.jsp`, `TourController` |
| Home | Header Accommodation link | Accommodation List | `client-header.jsp`, `AccommodationController` |
| Home | Header Voucher link | Voucher Promotions | `client-header.jsp`, `VoucherPromotionController` |
| Home | Header Blog link | Blog List | `client-header.jsp`, `BlogController` |
| Home | Header auth links | Login/Register | `client-header.jsp` |
| Login | Login success Admin | Admin Home | `LoginController.redirectByRole` |
| Login | Login success Staff | Staff Home | `LoginController.redirectByRole` |
| Login | Login success TourGuide | Guide Home | `LoginController.redirectByRole` |
| Login | Login success Customer/default | Home or safe redirect | `LoginController.getRedirectAfterLogin` |
| Login | Forgot password link | Forgot Password | `login.jsp` |
| Login | Register link | Register | `login.jsp` |
| Forgot Password | Submit valid email | Verify OTP | `ForgotPasswordController` |
| Verify OTP | Submit valid OTP | Reset Password | `VerifyOTPController` |
| Reset Password | Submit success | Login | `ResetPasswordController` |
| Profile | Edit profile link | Edit Profile | `profile.jsp`, `ProfileController` attributes |
| Edit Profile | Save/cancel | Profile | `EditProfileController`, `edit-profile.jsp` |
| Tour List | View detail | Tour Detail | `tour-list.jsp`, `TourController` |
| Tour Detail | Booking form/link | Checkout | `tour-detail.jsp`, `BookingController` |
| Checkout | Submit booking | Payment | `BookingController` redirects to `/payment?bookingID=...` |
| Payment | Return/cancel/result | Booking Summary or Booking History | `PaymentController`, `payment.jsp` |
| Accommodation List | View detail | Accommodation Detail | `AccommodationController`, accommodation JSP links |
| Accommodation Detail | View room | Room Detail | `AccommodationController`, `room-detail.jsp` breadcrumbs/forms |
| Room Detail | Book room | Accommodation Booking | `room-detail.jsp` action `/booking/accommodation/form` |
| Accommodation Booking | Submit booking | Payment | `AccommodationController.handleAccommodationBooking` |
| Voucher Promotions | Save voucher | Voucher Promotions/Login/My Vouchers context | `SaveVoucherController`, `voucher-promotions.jsp` |
| Blog List | Read post | Blog Detail | `BlogController`, `blog-list.jsp` |
| My Blogs | View own post | Blog Detail | `BlogController.showMyBlogs` |
| Tour Detail/Feedback List | Add feedback | Add Feedback | `tour-detail.jsp`, `feedback-list.jsp` |
| Add Feedback | Submit | Feedback List or Tour Detail | `FeedbackController` redirects |
| Admin Home | Sidebar/dashboard navigation | Admin Dashboard, User, Tour, Booking, Feedback, Blog, Voucher, Profile | `admin-sidebar.jsp`, `admin-home.jsp` |
| Admin Tour List | View/review | Admin Tour Detail | `admin-tour-list.jsp` |
| Admin Tour Detail | Approve/reject/status POST | Admin Tour Detail | `admin-tour-detail.jsp`, Admin tour action controllers |
| Admin Booking List | View detail | Admin Booking Detail | `admin-booking-list.jsp` |
| Admin Booking Detail | Back/status | Admin Booking List | `AdminBookingController`, `admin-booking-detail.jsp` |
| Admin Feedback List | View detail | Admin Feedback Detail | `AdminFeedbackController`, admin feedback JSPs |
| Staff Home | Sidebar/module navigation | Tour, Accommodation, Booking, Assignment, Blog, Voucher, Feedback, Profile | `staff-sidebar.jsp`, `staff-home.jsp` |
| Staff Tour Management | Add tour | Create/Edit Tour | `tour-list.jsp`, `AddTourController` |
| Create/Edit Tour | Create success | Create/Edit Schedule | `AddTourController` redirect to `/staff/tour/schedule/add` |
| Create/Edit Tour | Edit success | Staff Tour Detail | `EditTourController` redirect |
| Create/Edit Schedule | First schedule saved | Tour Management | `AddTourScheduleController` first-schedule redirect |
| Create/Edit Schedule | Later schedule saved | Staff Tour Detail | `AddTourScheduleController`, `EditTourScheduleController` redirects |
| Staff Tour Management | View detail | Staff Tour Detail | `tour-list.jsp` |
| Staff Tour Management | Open schedules | Schedule List | `tour-list.jsp` |
| Staff Tour Detail | Add schedule | Create/Edit Schedule | `tour-detail.jsp` |
| Staff Tour Detail | Submit approval | Staff Tour Detail | `tour-detail.jsp`, `SubmitTourForApprovalController` |
| Schedule List | Add/edit/view schedule | Schedule Form or Schedule Detail | `tour-schedule-list.jsp` |
| Schedule Detail | Close/edit/back | Schedule List or Schedule Form | `tour-schedule-detail.jsp`, schedule controllers |
| Staff Accommodation Management | Detail/actions | Staff Accommodation Detail or self | `ManageAccommodationController` |
| Staff Booking Management | View/status | Staff Booking Detail or self | `ManageBookingController` |
| Staff Feedback Management | View/status | Staff Feedback Detail or self | `ManageFeedbackController` |
| Staff Assignment Management | Create/edit/view | Assignment Form or Assignment Detail | `ManageAssignmentTourController`, assignment JSPs |
| Staff/Admin Home | Blog/Voucher navigation | Blog Management, Voucher Management | `staff-sidebar.jsp`, `admin-sidebar.jsp`, shared controllers |
| Guide Home | Sidebar/detail actions | Guide Assignment List or Guide Assignment Detail | `TourGuideHomeController`, `tour-guide-home.jsp` |
| Guide Assignment List | View | Guide Assignment Detail | `TourGuideScheduleController`, guide JSPs |
| Guide Assignment Detail | Edit passenger status | Passenger Status Edit | `assignment-detail.jsp` |
| Guide Assignment Detail | Add progress log | Progress Log Form | `assignment-detail.jsp` |
| Passenger Status Edit | Submit update | Passenger Status Edit or Assignment Detail | `TourGuideScheduleController.updatePassengerStatus` |
| Progress Log Form | Submit log | Guide Assignment Detail | `TourGuideScheduleController.addProgressLog` |

## Shared Screens

- Profile and Edit Profile are shared by Customer, Staff, TourGuide and Admin through route-specific mappings.
- Blog Management and Voucher Management use shared controllers/views for Staff and Admin routes.
- Home, Tour List, Tour Detail, Accommodation List/Detail, Blog List/Detail and Voucher Promotions are public but can also be used by signed-in Customer users.

## Redirect Decisions

- Action-only endpoints are represented as labeled arrows, not screen boxes: approve, reject, status update, submit approval, voucher save, booking status, close schedule and delete/update actions.
- Invalid login returns to Login because the controller forwards to `login.jsp` with an error.
- Protected-route unauthenticated access redirects to Login from filters.
- Wrong-role access uses `sendError(SC_FORBIDDEN)` and is not drawn as a separate screen because no active access-denied JSP mapping was found.
- Not-found detail routes redirect to their owning list when source does so; guide not-found uses `sendError(SC_NOT_FOUND)`.

## Screens Excluded

| Candidate | Reason |
|---|---|
| `/tour-image/*` | Image-serving endpoint, no user-facing page. |
| `/payment/webhook`, `/payment/qr`, `/payment/status` | API/action endpoints; only cause Payment screen refresh/result handling. |
| `/booking-edit` | Controller only redirects to Booking History with edit disabled; no visible edit page. |
| `/delete-account` | Action endpoint only; form is embedded in Edit Profile. |
| `/vouchers/save` | Action endpoint only; redirects to Voucher Promotions/Login. |
| `src/main/webapp/WEB-INF/views/common/error.jsp` | JSP exists, but no active forward or error-page mapping was found. |
| `WEB-INF/views/staff/tour-list.jsp`, `tour-create.jsp`, `tour-edit.jsp`, `tour-view.jsp` | Legacy/prototype route family `/staff/tours`; no active controller mapping found in current Java source. |
| `WEB-INF/views/staff/resource-allocation-*` | Links reference `/staff/resources`, but no active controller mapping found. |
| `WEB-INF/views/staff/staff-assignment-*` | Links reference `/staff/assignments`, but active controller uses `/staff/assignment`; treated as unconfirmed legacy views. |
| `/staff/payment` | Sidebar/home links exist, but `ManagePaymentController` has no servlet mapping and no view forwarding. |
| `/staff/tour-assignment/list`, `/staff/private-request/list` | Legacy sidebar links with no active controller mapping found. |
| `views/customer/voucher-user.jsp` | JSP exists, but active voucher controllers forward to `voucher-promotions.jsp` and `voucher-list.jsp`; no route reference found. |
| `views/guide/passenger-status.jsp` | JSP exists, but active guide controller forwards to `passenger-status-edit.jsp`. |

## Unconfirmed Items

- Several WEB-INF staff prototype routes appear to be partially implemented as JSP links only; without active servlet mappings they are not confirmed screens.
- No configured application error page was found in `WEB-INF/web.xml`.
- No active `/staff/payment` screen was confirmed despite sidebar links.

## Validation Checklist

- Repository-wide search completed: Yes.
- Active controllers inspected: Yes.
- Active view templates inspected: Yes.
- Form actions inspected: Yes.
- Links and buttons inspected: Yes.
- Redirects and forwards inspected: Yes.
- Login routing inspected: Yes.
- Role filters inspected: Yes.
- Sidebar and dashboard navigation inspected: Yes.
- Every included screen has source evidence: Yes.
- Important arrows have navigation evidence: Yes.
- API-only endpoints are not drawn as screens: Yes.
- Unused legacy pages are excluded: Yes.
- Draw.io XML files generated as real XML: Yes.
- PNG and SVG generated from the same screen-flow layout: Yes.
