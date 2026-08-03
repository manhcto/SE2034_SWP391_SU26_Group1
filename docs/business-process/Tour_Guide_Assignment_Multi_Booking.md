# Tour Guide assignment with multiple bookings

## Business rule

- One assignment belongs to one Tour Guide and one `tourScheduleID`.
- A tour schedule has one active Tour Guide.
- Every paid Tour booking for that schedule is linked automatically to its active assignment.
- A later paid booking is linked automatically after payment succeeds.
- Guide confirmation, rejection, progress, and completion apply to the full tour schedule.
- The same customer may create more than one booking for the same schedule.

## Data model

`Tour_Assignments` stores the guide and schedule. `Tour_Assignment_Booking` stores the many linked bookings.

```text
Tour_Assignments (1 guide + 1 schedule) 1 --- * Tour_Assignment_Booking * --- 1 Booking
```

Run `database/migrations/20260803_tour_assignment_bookings.sql` before using this flow. The migration copies legacy `Tour_Assignments.bookingID` values into the link table without deleting historical rows.

## Flow

1. Staff selects a paid tour schedule and one available guide.
2. The system creates one assignment and links every currently paid booking of that schedule.
3. Payment completion calls the assignment sync, which links any new paid booking to the active assignment.
4. The guide confirms or rejects the schedule once. Rejection applies to the whole schedule.
5. Passenger status, progress logs, and completion use the assignment's linked bookings.
