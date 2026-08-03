# Complete Tour Creation Query Flow

This document follows the current source code end to end for creating a complete tour. The flow has two separate HTTP requests:

- Phase 1: `POST /staff/tour/add` creates the base Tour, itinerary, and managed images.
- Phase 2: `GET/POST /staff/tour/schedule/add` creates the first Tour schedule after `AddTourController` redirects Staff to the schedule creation screen.

The queries below are copied from the current DAO code. No stored procedure or inferred query is added.

## Source Files Checked

- `src/main/java/vn/edu/fpt/controller/staff/AddTourController.java`
- `src/main/java/vn/edu/fpt/controller/staff/StaffTourFormSupport.java`
- `src/main/java/vn/edu/fpt/controller/staff/AddTourScheduleController.java`
- `src/main/java/vn/edu/fpt/controller/staff/StaffTourScheduleSupport.java`
- `src/main/java/vn/edu/fpt/controller/staff/SubmitTourForApprovalController.java`
- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- `src/main/java/vn/edu/fpt/DAO/AdministrativeUnitDAO.java`
- `src/main/webapp/views/staff/tour-schedule-form.jsp`

## Phase 1 - Create Tour Base Information

### Query CT-01 - Verify Active Tour Category

`StaffTourFormSupport.validateTourData(...)` calls `TourDAO.existsActiveCategory(categoryID)`. The actual SQL is built by `existsByIdAndStatus(...)`; table and column names are fixed by DAO code.

```sql
SELECT 1
FROM Tour_Category
WHERE tourCategoryID = ?
  AND [status] = N'Active';
```

### Query CT-02 - Verify Active Start Province

`StaffTourFormSupport.validateTourData(...)` calls `AdministrativeUnitDAO.isValidProvinceName(data.startPlace)`.

```sql
SELECT 1
FROM [dbo].[Administrative_Unit]
WHERE isActive = 1
  AND provinceName = ?;
```

### Query CT-03 - Verify Active End Province

`StaffTourFormSupport.validateTourData(...)` calls `AdministrativeUnitDAO.isValidProvinceName(data.endPlace)`.

```sql
SELECT 1
FROM [dbo].[Administrative_Unit]
WHERE isActive = 1
  AND provinceName = ?;
```

### Query CT-04 - Verify Active Region

`StaffTourFormSupport.validateTourData(...)` calls `TourDAO.existsActiveRegion(regionID)`. The actual SQL is built by `existsByIdAndStatus(...)`; table and column names are fixed by DAO code.

```sql
SELECT 1
FROM Region
WHERE regionID = ?
  AND [status] = N'Active';
```

### Query CT-05 - Insert Tour

`AddTourController.doPost(...)` sets `data.status = "Draft"`, builds the `Tour` with `buildTourFromData(data, getCurrentUserID(request), false)`, then calls `TourDAO.insertTourWithItineraries(tour)`. This query is executed inside a JDBC transaction with `conn.setAutoCommit(false)`.

```sql
INSERT INTO Tour (
    tourCategoryID, tourName, tourCode, tourType, numberOfDay, numberOfNights,
    startPlace, endPlace, [image], adultPrice, childrenPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, tourIntroduce, tourInclude,
    tourNonInclude, pickupPointName, pickupAddress, arriveBeforeMinutes,
    pickupNote, mainTransportType, childPolicyNote, rate, [status], isFeatured,
    regionID, createdByUserID, approvedByUserID, approvedAt, rejectionReason,
    createdAt, updatedAt
) VALUES (
    ?, ?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NULL,
    ?, ?, ?, ?, NULL, NULL, NULL, GETDATE(), NULL
);
```

Confirmed state after this insert:

- `tourCode` is inserted as `NULL` first.
- `status` is inserted from the controller-built model, currently `Draft`.
- Generated `tourID` is read through JDBC generated keys.

### Query CT-06 - Verify Generated Tour Code Candidate

After Tour insert returns the generated `tourID`, `TourDAO.updateTourCode(...)` calls `buildUniqueTourCode(...)`, which checks whether the generated code already exists.

```sql
SELECT 1
FROM Tour
WHERE tourCode = ?
  AND tourID <> ?;
```

The current code format is:

```java
String.format("WV%02d-PKG-%03d", java.time.Year.now().getValue() % 100, tourID)
```

### Query CT-07 - Update Tour Code

The generated unique code is written back to the new Tour row.

```sql
UPDATE Tour
SET tourCode = ?
WHERE tourID = ?;
```

### Query CT-08 - Insert Tour Itinerary

`TourDAO.insertItineraries(...)` inserts one row per itinerary item. This runs in the same transaction as CT-05.

```sql
INSERT INTO Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
VALUES (?, ?, ?, ?, ?, ?, N'Active');
```

### Query CT-09 - Delete Managed Tour Images

`TourDAO.replaceManagedImages(...)` first deletes only managed intro/day image rows. For a newly inserted Tour, this normally affects zero rows, but the query still belongs to the transaction.

```sql
DELETE FROM Tour_Image
WHERE tourID = ?
  AND (caption = N'INTRO_IMAGE' OR caption LIKE N'ITINERARY_DAY_%_IMAGE');
```

### Query CT-10 - Insert Managed Tour Images

`TourDAO.insertManagedImage(...)` inserts the intro image and itinerary-day images when `imageUrl` is not blank.

```sql
INSERT INTO Tour_Image (tourID, imageUrl, caption, displayOrder, [status])
VALUES (?, ?, ?, ?, N'Active');
```

### Query CT-10A - Source-Supported Batch Schedule Insert Not Used By AddTour

`TourDAO.insertTourWithItineraries(...)` contains a private `insertSchedules(...)` method that can batch insert schedules in the same transaction. However, the current `AddTourController` calls `buildTourFromData(..., false)`, so the new Tour has no initial schedule list in this request. Therefore this query exists in source code but is not executed by the current `POST /staff/tour/add` flow.

```sql
INSERT INTO Tour_Scheduler (
    tourID, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
) VALUES (
    ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
);
```

## Redirect Between Phase 1 And Phase 2

After CT-05 to CT-10 commit successfully, `AddTourController` redirects Staff to:

```text
/staff/tour/schedule/add?tourID=<generatedTourID>&message=tourCreated
```

This redirect is important because schedule creation is not part of the first submit. If phase 1 succeeds and phase 2 fails later, the Tour row remains in database.

## Phase 2 - Create Tour Schedule

### Query CT-11 - Find Tour By ID For Schedule Creation

`AddTourScheduleController.doGet(...)` and `doPost(...)` call `getTourForSchedule(tourID)`, which first calls `TourDAO.getTourById(tourID)`. If no Tour is found, the controller redirects to `/staff/tour?message=notFound`.

```sql
SELECT
    t.tourID,
    t.tourCategoryID,
    t.tourName,
    t.tourCode,
    t.tourType,
    t.numberOfDay,
    t.numberOfNights,
    t.startPlace,
    t.endPlace,
    t.[image],
    t.adultPrice,
    t.childrenPrice,
    t.infantPrice,
    t.singleRoomSurcharge,
    t.depositPercent,
    t.vatPercent,
    t.tourIntroduce,
    t.tourInclude,
    t.tourNonInclude,
    t.pickupPointName,
    t.pickupAddress,
    t.arriveBeforeMinutes,
    t.pickupNote,
    t.mainTransportType,
    t.childPolicyNote,
    t.rate,
    t.[status],
    t.isFeatured,
    t.regionID,
    t.createdByUserID,
    t.approvedByUserID,
    t.approvedAt,
    t.rejectionReason,
    t.createdAt,
    t.updatedAt,
    tc.categoryName,
    r.regionName,
    LTRIM(RTRIM(ISNULL(cu.firstName, N'') + N' ' + ISNULL(cu.lastName, N''))) AS createdByName,
    LTRIM(RTRIM(ISNULL(au.firstName, N'') + N' ' + ISNULL(au.lastName, N''))) AS approvedByName,
    ISNULL((SELECT COUNT(*) FROM Tour_Scheduler ts WHERE ts.tourID = t.tourID), 0) AS scheduleCount,
    ISNULL((
        SELECT COUNT(DISTINCT bd.bookingID)
        FROM Tour_Scheduler ts
        JOIN Booking_Detail bd ON bd.tourScheduleID = ts.tourScheduleID
        JOIN Booking b ON b.bookingID = bd.bookingID
        WHERE ts.tourID = t.tourID
          AND ISNULL(b.[status], N'') NOT IN (N'Cancelled', N'Da huy')
    ), 0) AS bookingCount
FROM Tour t
JOIN Tour_Category tc ON t.tourCategoryID = tc.tourCategoryID
LEFT JOIN Region r ON t.regionID = r.regionID
LEFT JOIN [User] cu ON t.createdByUserID = cu.userID
LEFT JOIN [User] au ON t.approvedByUserID = au.userID
WHERE t.tourID = ?;
```

Note: the real source string uses the Vietnamese value for cancelled bookings. This documentation keeps the query ASCII-safe; the source of truth remains `TourDAO.TOUR_SELECT`.

### Query CT-12 - Sync Open Schedules With Tour Status

`StaffTourScheduleSupport.getTourForSchedule(...)` calls `TourDAO.syncOpenSchedulesWithTourStatus(tour)`. For a newly created Draft Tour, there are usually no schedules yet, so this updates zero rows. It still confirms that non-Active Tours cannot keep schedules as `Open`.

```sql
UPDATE Tour_Scheduler
SET scheduleStatus = ?, updatedAt = GETDATE()
WHERE tourID = ?
  AND scheduleStatus = N'Open';
```

The Java value for `forcedStatus` is:

- `Closed` when Tour status is `Inactive`
- `Planned` for other non-Active statuses, including `Draft`
- No query runs when Tour status is `Active`

### Query CT-13 - Check `scheduleTransportType` Column Before Loading Schedules

`TourDAO.getSchedulesByTourId(...)` checks whether the current schema has `Tour_Scheduler.scheduleTransportType`.

```sql
SELECT 1
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Tour_Scheduler'
  AND COLUMN_NAME = 'scheduleTransportType';
```

### Query CT-14 - Load Existing Schedules For The Tour

The existing schedule list is loaded for form context, duplicate/gap awareness, and default next-date calculation.

```sql
SELECT
    tourScheduleID, tourID, scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
FROM Tour_Scheduler
WHERE tourID = ?
ORDER BY startDate ASC, tourScheduleID ASC;
```

Fallback when `scheduleTransportType` is not supported:

```sql
SELECT
    tourScheduleID, tourID, CAST(NULL AS NVARCHAR(50)) AS scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
FROM Tour_Scheduler
WHERE tourID = ?
ORDER BY startDate ASC, tourScheduleID ASC;
```

### Query CT-15 - Check Duplicate Schedule Start Date

`StaffTourScheduleSupport.validateScheduleData(...)` calls `TourDAO.isDuplicateScheduleStartDate(...)` when date fields are valid and not locked.

```sql
SELECT 1
FROM Tour_Scheduler
WHERE tourID = ?
  AND tourScheduleID <> ?
  AND CONVERT(date, startDate) = CONVERT(date, ?)
  AND scheduleStatus <> N'Cancelled';
```

### Query CT-16 - Check Schedule Start Date Gap

The same validation method checks whether another non-cancelled schedule is too close. In current code, add mode passes `currentScheduleID = 0` and `minGapDays = 3`.

```sql
SELECT 1
FROM Tour_Scheduler
WHERE tourID = ?
  AND tourScheduleID <> ?
  AND scheduleStatus <> N'Cancelled'
  AND ABS(DATEDIFF(day, CONVERT(date, startDate), CONVERT(date, ?))) < ?;
```

### Query CT-17 - Check `scheduleTransportType` Column Before Insert

`TourDAO.insertTourSchedule(...)` checks the schema again before choosing the insert statement.

```sql
SELECT 1
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Tour_Scheduler'
  AND COLUMN_NAME = 'scheduleTransportType';
```

### Query CT-18 - Insert Tour Schedule With `scheduleTransportType`

This is the insert used when the current database has the `scheduleTransportType` column.

```sql
INSERT INTO Tour_Scheduler (
    tourID, scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
) VALUES (
    ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
);
```

For a Tour that was just created in Phase 1, `scheduleStatus` resolves to `Planned` because the Tour is still `Draft`.

### Query CT-18F - Insert Tour Schedule Without `scheduleTransportType`

This fallback is used only when the schema does not have the `scheduleTransportType` column.

```sql
INSERT INTO Tour_Scheduler (
    tourID, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
) VALUES (
    ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
);
```

## Java Validation Without SQL

The following checks are real business validation in source code, but they are handled in Java and do not have separate SQL queries:

- `canManageScheduleForTour(tour)`: Tour must exist and Tour status must not be `Inactive`.
- Start date is required and must not be before today.
- End date is required, must not be before today, must not be before start date, and must match `tour.numberOfDay`.
- Booking deadline, when present, must be before start date and not in the past when changed.
- Seat capacity must match the allowed seat options for selected transport.
- `maxParticipantsPerBooking` must be positive, must not exceed max participants, and should not exceed 20.
- Adult price must be greater than `100000`.
- Child price must equal `ROUND(adultPrice * 0.50, 0)`.
- Infant price is currently validated as `0` in source.
- Single room surcharge must be greater than or equal to `0`.
- Schedule status is system-resolved; the form does not choose it directly.

## Transaction Analysis

Transaction 1: create Tour, itinerary, and managed images.

- Starts in `TourDAO.insertTourWithItineraries(...)` with `conn.setAutoCommit(false)`.
- Includes CT-05, CT-06, CT-07, CT-08, CT-09, and CT-10.
- Commits only after Tour, tourCode, itinerary, images, and the unused schedule-list branch complete successfully.
- Rolls back if any query in this transaction throws an exception.

Transaction 2: create one Tour schedule.

- Starts from a separate `POST /staff/tour/schedule/add` request.
- `TourDAO.insertTourSchedule(...)` opens its own connection and does not call `setAutoCommit(false)`.
- Therefore the insert uses JDBC/database autocommit behavior.
- There is no rollback of the already-created Tour when schedule insert fails.

Confirmed failure behavior:

- If Phase 1 succeeds but Phase 2 fails, the Tour remains in database.
- The Tour remains `Draft`.
- Staff can return to schedule creation/list screens and add a schedule later.
- This creates a valid intermediate state: `Tour = Draft` and no schedule yet.

## Status Confirmation

Tour status on first insert:

- `AddTourController` sets `data.status = "Draft"`.
- `StaffTourFormSupport.buildTourFromData(...)` writes that status into the Tour model.
- CT-05 persists the status directly.

Schedule status on first insert:

- `AddTourScheduleController.buildDefaultSchedule(...)` sets `Open` only when `canOpenScheduleForTour(tour)` is true.
- `canOpenScheduleForTour(tour)` returns true only when Tour status is `Active`.
- A newly created Tour is `Draft`, so the first schedule is inserted with `scheduleStatus = "Planned"`.

No automatic Tour status update after schedule creation:

- `POST /staff/tour/schedule/add` only calls `tourDAO.insertTourSchedule(schedule)`.
- No query changes Tour status to `Pending` or `Active` after CT-18.
- Moving Tour to `Pending` is a separate manual Staff action through `/staff/tour/submit`, not part of schedule creation.

Separate approval-submit query, outside this creation flow:

```sql
UPDATE Tour
SET [status] = N'Pending', rejectionReason = NULL, updatedAt = GETDATE()
WHERE tourID = ?
  AND [status] IN (N'Draft', N'Rejected');
```

## End-To-End Result

After the complete creation flow succeeds:

- One `Tour` row exists.
- `Tour.tourCode` is generated and updated.
- One or more `Tour_Itinerary` rows exist for the Tour.
- Managed `Tour_Image` rows may exist when images were uploaded/resolved.
- At least one `Tour_Scheduler` row exists if Staff completes Phase 2 successfully.
- For a newly created Tour, the Tour remains `Draft`.
- For a newly created Draft Tour, the first schedule is `Planned`.
- The Tour is not sent to Admin automatically; Staff must submit it through the separate approval action after readiness checks pass.
