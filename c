[33mcommit 338e69240804fb0370e36385f6e6d2cdbb749555[m
Author: Nguyen Minh Anh (K17 HL) <anhnmhe171286@fpt.edu.vn>
Date:   Thu Jul 2 09:51:53 2026 +0700

    Update booking and accommodation management flows

 src/main/java/vn/edu/fpt/DAO/BookingDAO.java       |  23 [32m+[m[31m-[m
 src/main/java/vn/edu/fpt/DAO/RoomBookingDAO.java   |   2 [32m+[m[31m-[m
 .../customer/AccommodationBookingController.java   | 205 [31m-----------[m
 .../AccommodationBookingFormController.java        | 155 [31m---------[m
 .../customer/AccommodationController.java          | 241 [32m++++++++++++[m[31m-[m
 .../fpt/controller/customer/BookingController.java |  23 [31m--[m
 .../staff/ManageAccommodationController.java       |   3 [31m-[m
 .../controller/staff/ManageBookingController.java  | 110 [32m+[m[31m-----[m
 .../views/customer/accommodation-booking-form.jsp  |  12 [32m+[m[31m-[m
 .../webapp/views/staff/accommodation-detail.jsp    |  62 [31m----[m
 src/main/webapp/views/staff/staff-booking-edit.jsp | 383 [32m++[m[31m-------------------[m
 11 files changed, 300 insertions(+), 919 deletions(-)
