/* =========================================================
   APPROVE TOUR QUERY FLOW
   Source flow: POST /admin/tour/approve
   These queries are extracted from the current source code.

   Source classes:
   - AdminTourApproveController
   - TourDAO

   Notes:
   - Placeholders (?) are preserved from PreparedStatement SQL.
   - AT-Q07 and AT-Q08 are inside TourDAO.approveTour transaction.
   - AT-Q08 executes only when openSchedules is selected.
   ========================================================= */

/* ---------------------------------------------------------
   AT-Q01: Find Tour by ID
   Source:
     Class: TourDAO
     Method: getTourById
   Parameters:
     1 = tourID (INT)
   Result:
     Returns one Tour row or null.
   --------------------------------------------------------- */
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

/* ---------------------------------------------------------
   AT-Q02: Check approval readiness - reload Tour by ID
   Source:
     Class: TourDAO
     Method: getTourReadinessErrors -> getTourById
   Parameters:
     1 = tourID (INT)
   Result:
     Returns one Tour row or null for readiness checks.
   --------------------------------------------------------- */
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

/* ---------------------------------------------------------
   AT-Q03: Count active itineraries
   Source:
     Class: TourDAO
     Method: countActiveItineraries
   Parameters:
     1 = tourID (INT)
   Result:
     Returns active itinerary count.
   --------------------------------------------------------- */
SELECT COUNT(*)
FROM Tour_Itinerary
WHERE tourID = ?
  AND (status IS NULL OR status = N'Active');

/* ---------------------------------------------------------
   AT-Q04: Count valid schedules
   Source:
     Class: TourDAO
     Method: countValidSchedulesForApproval
   Parameters:
     1 = tourID (INT)
   Result:
     Returns count of future schedules valid for approval.
   --------------------------------------------------------- */
SELECT COUNT(*)
FROM Tour_Scheduler
WHERE tourID = ?
  AND scheduleStatus IN (N'Planned', N'Open')
  AND startDate >= CAST(GETDATE() AS DATE)
  AND maxParticipants > 0
  AND quantity < maxParticipants
  AND adultPrice > 100000
  AND childPrice = ROUND(adultPrice * 0.5, 0)
  AND ISNULL(singleRoomSurcharge, 0) >= 0;

/* ---------------------------------------------------------
   AT-Q05: Check duplicate schedule dates
   Source:
     Class: TourDAO
     Method: getDuplicateScheduleStartDateMap
   Parameters:
     1 = tourID (INT)
   Result:
     Returns duplicate start date keys when any exist.
   --------------------------------------------------------- */
SELECT CONVERT(date, startDate) AS dateKey
FROM Tour_Scheduler
WHERE tourID = ?
  AND scheduleStatus <> N'Cancelled'
GROUP BY CONVERT(date, startDate)
HAVING COUNT(*) > 1;

/* ---------------------------------------------------------
   AT-Q06.1: Check scheduleTransportType column for price-warning schedule load
   Source:
     Class: TourDAO
     Method: hasScheduleTransportTypeColumn
   Parameters:
     None
   Result:
     Returns whether Tour_Scheduler.scheduleTransportType exists.
   --------------------------------------------------------- */
SELECT 1
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Tour_Scheduler'
  AND COLUMN_NAME = 'scheduleTransportType';

/* ---------------------------------------------------------
   AT-Q06.2: Load schedules for schedule price warnings
   Source:
     Class: TourDAO
     Method: getSchedulePriceWarningMap -> getSchedulesByTourId
   Parameters:
     1 = tourID (INT)
   Result:
     Returns schedules used by Java code to check adultPrice, childPrice,
     and singleRoomSurcharge warning rules.
   --------------------------------------------------------- */
SELECT
    tourScheduleID, tourID, scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
FROM Tour_Scheduler
WHERE tourID = ?
ORDER BY startDate ASC, tourScheduleID ASC;

/* Source fallback when scheduleTransportType column is not supported:
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

/* ---------------------------------------------------------
   AT-Q07: Update Tour from Pending to Active
   Source:
     Class: TourDAO
     Method: approveTour
   Parameters:
     1 = adminUserID (INT)
     2 = tourID (INT)
   Result:
     Updates one Pending Tour to Active and stores approval metadata.
   --------------------------------------------------------- */
UPDATE Tour
SET [status] = N'Active',
    approvedByUserID = ?,
    approvedAt = GETDATE(),
    rejectionReason = NULL,
    updatedAt = GETDATE()
WHERE tourID = ?
  AND [status] = N'Pending';

/* ---------------------------------------------------------
   AT-Q08: Optionally open valid schedules
   Source:
     Class: TourDAO
     Method: approveTour
   Parameters:
     1 = tourID (INT)
   Result:
     Updates eligible Planned schedules to Open when openSchedules is selected.
   --------------------------------------------------------- */
UPDATE Tour_Scheduler
SET scheduleStatus = N'Open', updatedAt = GETDATE()
WHERE tourID = ?
  AND scheduleStatus = N'Planned'
  AND startDate >= CAST(GETDATE() AS DATE)
  AND quantity < maxParticipants;

/* =========================================================
   SAFE TEST TEMPLATE
   Review parameters before execution.
   Write operations are rolled back by default.
   ========================================================= */

/* Test-only parameter declarations.
   Do not use these values in production.
   Replace NULL only after reviewing real test data. */
DECLARE @tourID INT = NULL;
DECLARE @adminUserID INT = NULL;

/* Read-only checks can be adapted here. */
-- SELECT COUNT(*) FROM Tour_Itinerary WHERE tourID = @tourID AND (status IS NULL OR status = N'Active');
-- SELECT COUNT(*) FROM Tour_Scheduler WHERE tourID = @tourID AND scheduleStatus IN (N'Planned', N'Open');

/* Write-query test area. Do not COMMIT from this template. */
BEGIN TRANSACTION;

-- Paste or adapt confirmed UPDATE queries here after replacing placeholders safely.
-- Keep all UPDATE tests inside this transaction.

ROLLBACK TRANSACTION;
