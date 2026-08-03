/* =========================================================
   COMPLETE TOUR CREATION QUERY FLOW
   Source flow:
   - Phase 1: POST /staff/tour/add
   - Phase 2: GET/POST /staff/tour/schedule/add

   These queries are extracted from the current source code.

   Source classes:
   - AddTourController
   - StaffTourFormSupport
   - AddTourScheduleController
   - StaffTourScheduleSupport
   - TourDAO
   - AdministrativeUnitDAO

   Notes:
   - Placeholders (?) are preserved from PreparedStatement SQL.
   - Phase 1 and Phase 2 are separate requests and separate database units.
   - CT-Q05 to CT-Q10 are inside TourDAO.insertTourWithItineraries transaction.
   - Phase 2 schedule insert is not in the same transaction as Phase 1.
   ========================================================= */

/* =========================================================
   PHASE 1 - CREATE TOUR BASE INFORMATION
   Source flow: POST /staff/tour/add
   ========================================================= */

/* CT-Q01: Verify active Tour Category
   Source: TourDAO.existsActiveCategory -> existsByIdAndStatus
   Parameters: 1 = categoryID (INT)
   Result: true when an active category exists. */
SELECT 1
FROM Tour_Category
WHERE tourCategoryID = ?
  AND [status] = N'Active';

/* CT-Q02: Verify active start province
   Source: AdministrativeUnitDAO.isValidProvinceName
   Parameters: 1 = startPlace.trim() (NVARCHAR)
   Result: true when an active province exists. */
SELECT 1
FROM [dbo].[Administrative_Unit]
WHERE isActive = 1
  AND provinceName = ?;

/* CT-Q03: Verify active end province
   Source: AdministrativeUnitDAO.isValidProvinceName
   Parameters: 1 = endPlace.trim() (NVARCHAR)
   Result: true when an active province exists. */
SELECT 1
FROM [dbo].[Administrative_Unit]
WHERE isActive = 1
  AND provinceName = ?;

/* CT-Q04: Verify active Region
   Source: TourDAO.existsActiveRegion -> existsByIdAndStatus
   Parameters: 1 = regionID (INT)
   Result: true when an active region exists. */
SELECT 1
FROM Region
WHERE regionID = ?
  AND [status] = N'Active';

/* CT-Q05: Insert Tour
   Source: TourDAO.insertTourWithItineraries
   Parameters:
     1  = tourCategoryID
     2  = tourName
     3  = tourType
     4  = numberOfDay
     5  = numberOfNights
     6  = startPlace
     7  = endPlace
     8  = image
     9  = adultPrice
     10 = childrenPrice
     11 = infantPrice
     12 = singleRoomSurcharge
     13 = depositPercent
     14 = vatPercent
     15 = tourIntroduce
     16 = tourInclude
     17 = tourNonInclude
     18 = pickupPointName
     19 = pickupAddress
     20 = arriveBeforeMinutes
     21 = pickupNote
     22 = mainTransportType
     23 = childPolicyNote
     24 = status (AddTourController sets Draft)
     25 = isFeatured
     26 = regionID
     27 = createdByUserID
   Result: inserts Tour and returns generated tourID through JDBC generated keys. */
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

/* CT-Q06: Check generated Tour Code
   Source: TourDAO.tourCodeExists
   Parameters:
     1 = generated tourCode candidate
     2 = currentTourID
   Result: true when another tour already uses the generated code. */
SELECT 1
FROM Tour
WHERE tourCode = ?
  AND tourID <> ?;

/* CT-Q07: Update Tour Code
   Source: TourDAO.updateTourCode
   Parameters:
     1 = generated unique tourCode
     2 = generated tourID
   Result: updates tourCode for the newly inserted Tour. */
UPDATE Tour
SET tourCode = ?
WHERE tourID = ?;

/* CT-Q08: Insert Tour Itinerary
   Source: TourDAO.insertItineraries
   Parameters:
     1 = tourID
     2 = dayNumber
     3 = title
     4 = description
     5 = mealPlan
     6 = transportNote
   Result: inserts one itinerary row per prepared itinerary item. */
INSERT INTO Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
VALUES (?, ?, ?, ?, ?, ?, N'Active');

/* CT-Q09: Delete managed Tour Images
   Source: TourDAO.deleteManagedImages
   Parameters: 1 = tourID
   Result: deletes managed intro/itinerary image rows for the Tour. */
DELETE FROM Tour_Image
WHERE tourID = ?
  AND (caption = N'INTRO_IMAGE' OR caption LIKE N'ITINERARY_DAY_%_IMAGE');

/* CT-Q10: Insert managed Tour Image
   Source: TourDAO.insertManagedImage
   Parameters:
     1 = tourID
     2 = imageUrl
     3 = caption
     4 = displayOrder
   Result: inserts one managed image row when imageUrl is not blank. */
INSERT INTO Tour_Image (tourID, imageUrl, caption, displayOrder, [status])
VALUES (?, ?, ?, ?, N'Active');

/* CT-Q10A: Source-supported batch Tour Schedule insert inside insertTourWithItineraries
   Source: TourDAO.insertSchedules
   Important: Current AddTourController calls buildTourFromData(..., false), so the
   schedule list is empty and this query is NOT executed by POST /staff/tour/add.
   It is documented because the source method supports batch schedule insertion.
   Parameters:
     1  = tourID
     2  = startDate
     3  = endDate
     4  = departureTime
     5  = expectedReturnTime
     6  = bookingDeadline
     7  = minParticipants
     8  = maxParticipants
     9  = maxParticipantsPerBooking
     10 = adultPrice
     11 = childPrice
     12 = infantPrice
     13 = singleRoomSurcharge
     14 = depositPercent
     15 = vatPercent
     16 = cancellationPolicy
     17 = scheduleStatus
   Result: can batch insert Tour_Scheduler rows only when the caller supplies schedules. */
INSERT INTO Tour_Scheduler (
    tourID, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
) VALUES (
    ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
);

/* =========================================================
   PHASE 2 - CREATE TOUR SCHEDULE
   Source flow:
   - Redirect from AddTourController:
     /staff/tour/schedule/add?tourID=<generatedTourID>&message=tourCreated
   - GET /staff/tour/schedule/add loads the schedule form.
   - POST /staff/tour/schedule/add saves one schedule.
   ========================================================= */

/* CT-Q11: Find Tour by ID for Schedule Creation
   Source: StaffTourScheduleSupport.getTourForSchedule -> TourDAO.getTourById
   Parameters: 1 = tourID (INT)
   Result: returns one Tour row or null. */
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
          AND ISNULL(b.[status], N'') NOT IN (N'Cancelled', N'Đã hủy')
    ), 0) AS bookingCount
FROM Tour t
JOIN Tour_Category tc ON t.tourCategoryID = tc.tourCategoryID
LEFT JOIN Region r ON t.regionID = r.regionID
LEFT JOIN [User] cu ON t.createdByUserID = cu.userID
LEFT JOIN [User] au ON t.approvedByUserID = au.userID
WHERE t.tourID = ?;

/* CT-Q12: Sync Open schedules when Tour is not Active
   Source: StaffTourScheduleSupport.getTourForSchedule -> TourDAO.syncOpenSchedulesWithTourStatus
   Parameters:
     1 = forcedStatus (Closed when Tour is Inactive, otherwise Planned)
     2 = tourID
   Result: moves Open schedules back to a status consistent with the Tour status.
   Note: For a newly created Draft Tour with no schedules, this usually updates 0 rows. */
UPDATE Tour_Scheduler
SET scheduleStatus = ?, updatedAt = GETDATE()
WHERE tourID = ?
  AND scheduleStatus = N'Open';

/* CT-Q13: Check scheduleTransportType column before loading schedules
   Source: TourDAO.hasScheduleTransportTypeColumn
   Parameters: none
   Result: true when Tour_Scheduler.scheduleTransportType exists. */
SELECT 1
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Tour_Scheduler'
  AND COLUMN_NAME = 'scheduleTransportType';

/* CT-Q14: Load existing schedules for the Tour
   Source: StaffTourScheduleSupport.getTourForSchedule -> TourDAO.getSchedulesByTourId
   Parameters: 1 = tourID
   Result: returns existing schedules used by default date calculation and form context. */
SELECT
    tourScheduleID, tourID, scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
FROM Tour_Scheduler
WHERE tourID = ?
ORDER BY startDate ASC, tourScheduleID ASC;

/* Source fallback for CT-Q14 when scheduleTransportType column is not supported:
SELECT
    tourScheduleID, tourID, CAST(NULL AS NVARCHAR(50)) AS scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
FROM Tour_Scheduler
WHERE tourID = ?
ORDER BY startDate ASC, tourScheduleID ASC;
*/

/* CT-Q15: Check duplicate Schedule start date
   Source: StaffTourScheduleSupport.validateScheduleData -> TourDAO.isDuplicateScheduleStartDate
   Parameters:
     1 = tourID
     2 = currentScheduleID (0 for add mode)
     3 = startDate
   Result: true when another non-cancelled schedule has the same start date. */
SELECT 1
FROM Tour_Scheduler
WHERE tourID = ?
  AND tourScheduleID <> ?
  AND CONVERT(date, startDate) = CONVERT(date, ?)
  AND scheduleStatus <> N'Cancelled';

/* CT-Q16: Check Schedule start date gap
   Source: StaffTourScheduleSupport.validateScheduleData -> TourDAO.isScheduleStartDateTooClose
   Parameters:
     1 = tourID
     2 = currentScheduleID (0 for add mode)
     3 = startDate
     4 = minGapDays
   Result: true when another non-cancelled schedule is closer than the minimum gap. */
SELECT 1
FROM Tour_Scheduler
WHERE tourID = ?
  AND tourScheduleID <> ?
  AND scheduleStatus <> N'Cancelled'
  AND ABS(DATEDIFF(day, CONVERT(date, startDate), CONVERT(date, ?))) < ?;

/* CT-Q17: Check scheduleTransportType column before insert
   Source: TourDAO.insertTourSchedule -> hasScheduleTransportTypeColumn
   Parameters: none
   Result: true when insert should include scheduleTransportType column. */
SELECT 1
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Tour_Scheduler'
  AND COLUMN_NAME = 'scheduleTransportType';

/* CT-Q18: Insert Tour Schedule with scheduleTransportType column
   Source: TourDAO.insertTourSchedule
   Parameters:
     1  = tourID
     2  = scheduleTransportType
     3  = startDate
     4  = endDate
     5  = departureTime
     6  = expectedReturnTime
     7  = bookingDeadline
     8  = minParticipants
     9  = maxParticipants
     10 = maxParticipantsPerBooking
     11 = adultPrice
     12 = childPrice
     13 = infantPrice
     14 = singleRoomSurcharge
     15 = depositPercent
     16 = vatPercent
     17 = cancellationPolicy
     18 = scheduleStatus
   Result: inserts one Tour_Scheduler row. */
INSERT INTO Tour_Scheduler (
    tourID, scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
) VALUES (
    ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
);

/* CT-Q18 fallback: Insert Tour Schedule without scheduleTransportType column
   Source: TourDAO.insertTourSchedule
   Parameters:
     1  = tourID
     2  = startDate
     3  = endDate
     4  = departureTime
     5  = expectedReturnTime
     6  = bookingDeadline
     7  = minParticipants
     8  = maxParticipants
     9  = maxParticipantsPerBooking
     10 = adultPrice
     11 = childPrice
     12 = infantPrice
     13 = singleRoomSurcharge
     14 = depositPercent
     15 = vatPercent
     16 = cancellationPolicy
     17 = scheduleStatus
   Result: inserts one Tour_Scheduler row when scheduleTransportType is not in schema. */
INSERT INTO Tour_Scheduler (
    tourID, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
) VALUES (
    ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), NULL
);

/* =========================================================
   SAFE TEST TEMPLATE
   Review parameters before execution.
   Write operations are rolled back by default.
   ========================================================= */

/* Test-only parameter declarations.
   Do not use these values in production.
   Replace NULL only after reviewing real test data. */
DECLARE @categoryID INT = NULL;
DECLARE @startProvince NVARCHAR(100) = NULL;
DECLARE @endProvince NVARCHAR(100) = NULL;
DECLARE @regionID INT = NULL;
DECLARE @tourID INT = NULL;
DECLARE @tourCode NVARCHAR(50) = NULL;
DECLARE @currentScheduleID INT = 0;
DECLARE @scheduleStartDate DATETIME = NULL;
DECLARE @minGapDays INT = 3;

/* Read-only checks can be adapted here. */
-- SELECT 1 FROM Tour_Category WHERE tourCategoryID = @categoryID AND [status] = N'Active';
-- SELECT 1 FROM [dbo].[Administrative_Unit] WHERE isActive = 1 AND provinceName = @startProvince;
-- SELECT 1 FROM [dbo].[Administrative_Unit] WHERE isActive = 1 AND provinceName = @endProvince;
-- SELECT 1 FROM Region WHERE regionID = @regionID AND [status] = N'Active';
-- SELECT 1 FROM Tour WHERE tourCode = @tourCode AND tourID <> @tourID;
-- SELECT 1 FROM Tour_Scheduler WHERE tourID = @tourID AND tourScheduleID <> @currentScheduleID AND CONVERT(date, startDate) = CONVERT(date, @scheduleStartDate) AND scheduleStatus <> N'Cancelled';

/* Write-query test area. Do not COMMIT from this template. */
BEGIN TRANSACTION;

-- Paste or adapt confirmed INSERT, UPDATE, and DELETE queries here after replacing placeholders safely.
-- Keep all write tests inside this transaction.

ROLLBACK TRANSACTION;
