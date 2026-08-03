# Tour Database Query Analysis

This document analyzes confirmed database queries used by two flows:

- Create Tour, starting at `POST /staff/tour/add`.
- Approve Tour, starting at `POST /admin/tour/approve`.

No source code, SQL script, migration, or database data was changed for this analysis.

## A. Database Scope

### Create Tour

- Trigger: Staff submits `POST /staff/tour/add`.
- Start point: `AddTourController.doPost`.
- End point: `TourDAO.insertTourWithItineraries(tour)` returns a generated `tourID`, or validation/save fails and the form is returned with errors.
- Main DAO methods:
  - `TourDAO.existsActiveCategory(int categoryID)`
  - `TourDAO.existsActiveRegion(int regionID)`
  - `AdministrativeUnitDAO.isValidProvinceName(String provinceName)`
  - `TourDAO.insertTourWithItineraries(Tour tour)`
  - Private DAO helpers executed inside the create transaction: `updateTourCode`, `tourCodeExists`, `insertItineraries`, `replaceManagedImages`, `deleteManagedImages`, `insertManagedImage`
- Main tables: `Tour_Category`, `Region`, `Administrative_Unit`, `Tour`, `Tour_Itinerary`, `Tour_Image`.
- Transaction scope: The main create transaction starts inside `insertTourWithItineraries` after reference validation. It covers insert `Tour`, update `tourCode`, insert itinerary rows, delete/insert managed image rows, and would cover schedule insert if `tour.scheduleList` were non-empty. In the current Add Tour flow, `includeInitialSchedule=false`, so no schedule insert query is executed.
- Success database state: New `Tour` exists with status `Draft`, generated `tourID`, generated `tourCode`, `createdByUserID`, `createdAt=GETDATE()`, itinerary rows, and managed image rows if images were submitted.
- Failure database state: If validation fails, no create transaction starts. If any query inside `insertTourWithItineraries` fails, `rollbackQuietly(conn)` rolls back the whole transaction and the method returns `0`.

### Approve Tour

- Trigger: Admin submits `POST /admin/tour/approve`.
- Start point: `AdminTourApproveController.doPost`.
- End point: `TourDAO.approveTour(tourID, adminUserID, openSchedules)` commits, or approval is rejected before update, or update fails.
- Main DAO methods:
  - `TourDAO.getTourById(int tourID)`
  - `TourDAO.getTourReadinessErrors(int tourID)`
  - `TourDAO.countActiveItineraries(int tourID)`
  - `TourDAO.countValidSchedulesForApproval(int tourID)`
  - `TourDAO.getDuplicateScheduleStartDateMap(int tourID)`
  - `TourDAO.getSchedulePriceWarningMap(int tourID)`
  - `TourDAO.getSchedulesByTourId(int tourID)`
  - `TourDAO.approveTour(int tourID, int adminUserID, boolean openValidSchedules)`
- Main tables: `Tour`, `Tour_Category`, `Region`, `[User]`, `Tour_Scheduler`, `Booking_Detail`, `Booking`, `Tour_Itinerary`, `INFORMATION_SCHEMA.COLUMNS`.
- Transaction scope: The approval transaction starts inside `approveTour`. It covers the `Tour` status update and optional `Tour_Scheduler` status update.
- Required current state: `Tour.status = N'Pending'`.
- Success database state: `Tour.status` changes to `Active`; `approvedByUserID`, `approvedAt`, `updatedAt`, and `rejectionReason` are updated. If `openSchedules=true`, eligible `Planned` schedules are updated to `Open`.
- Failure database state: If Tour is missing, not `Pending`, or not ready, no approval transaction starts. If update affects zero rows or an exception occurs inside the approval transaction, the DAO rolls back and returns `false`.

## B. Database Schema Evidence

Schema evidence was confirmed from `D:/Downloads/5.0.sql` and migration `database/migrations/20260716_admin_tour_approval_support.sql`.

| Table | Primary key | Important foreign keys | Status columns | Important constraints |
| --- | --- | --- | --- | --- |
| `Tour` | `tourID` | `tourCategoryID -> Tour_Category`, `regionID -> Region`, `createdByUserID -> User`, `approvedByUserID -> User` | `status` | Unique nonclustered index on `tourCode`; `CK_Tour_NumberOfDay`; `CK_Tour_Percent`; `CK_Tour_Price`; `CK_Tour_Rate`; migration changes default status to `Draft` |
| `Tour_Category` | `tourCategoryID` | None confirmed for this flow | `status` | Unique nonclustered index on `categoryName`; default status `Active` |
| `Region` | `regionID` | None confirmed for this flow | `status` | Unique index on region name confirmed in dump; default status `Active` |
| `Administrative_Unit` | `administrativeUnitID` | None confirmed for this flow | `isActive` | Indexes on province/province+ward confirmed in dump; default `isActive=1` |
| `Tour_Itinerary` | `itineraryID` | `tourID -> Tour` with `ON DELETE CASCADE` | `status` | `CK_Tour_Itinerary_Day`; default status `Active` |
| `Tour_Image` | `imageID` | `tourID -> Tour` with `ON DELETE CASCADE` | `status` | Default `displayOrder=1`; default status `Active` |
| `Tour_Scheduler` | `tourScheduleID` | `tourID -> Tour` | `scheduleStatus` | `IX_Tour_Scheduler_Tour_Date`; `CK_TourScheduler_BookedSeats`; `CK_TourScheduler_Date`; `CK_TourScheduler_Quantity`; migration changes default schedule status to `Planned` |
| `Booking_Detail` | `bookingDetailID` | `tourScheduleID -> Tour_Scheduler` | None for this flow | Used by `TOUR_SELECT` booking count |
| `Booking` | `bookingID` | User/payment relationships outside this flow | `status` | Used by `TOUR_SELECT` booking count |

Schema note: the base SQL dump shows `DF_Tour_Status DEFAULT (N'Active')` and `DF_TourScheduler_Status DEFAULT (N'Open')`, but migration `20260716_admin_tour_approval_support.sql` replaces them with `Draft` and `Planned`. The Java create flow explicitly inserts status `Draft`, so it does not rely on the base default.

## C. Create Tour Query Execution Order

### Successful submit path

| Order | Query ID | DAO method | Operation | Main table | Business purpose | Transaction |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | CT-Q01 | `existsActiveCategory` -> `existsByIdAndStatus` | `SELECT` | `Tour_Category` | Verify selected category exists and is active | No |
| 2 | CT-Q02 | `AdministrativeUnitDAO.isValidProvinceName` | `SELECT` | `Administrative_Unit` | Verify start province is active | No |
| 3 | CT-Q03 | `AdministrativeUnitDAO.isValidProvinceName` | `SELECT` | `Administrative_Unit` | Verify end province is active | No |
| 4 | CT-Q04 | `existsActiveRegion` -> `existsByIdAndStatus` | `SELECT` | `Region` | Verify selected region exists and is active | No |
| 5 | CT-Q05 | `insertTourWithItineraries` | `INSERT` | `Tour` | Create the Tour row with status `Draft` | Create Tour transaction |
| 6 | CT-Q06 | `tourCodeExists` | `SELECT` | `Tour` | Ensure generated `tourCode` is unique | Create Tour transaction |
| 7 | CT-Q07 | `updateTourCode` | `UPDATE` | `Tour` | Save generated `tourCode` after generated `tourID` is known | Create Tour transaction |
| 8 | CT-Q08 | `insertItineraries` | Batch `INSERT` | `Tour_Itinerary` | Save daily itinerary rows | Create Tour transaction |
| 9 | CT-Q09 | `deleteManagedImages` | `DELETE` | `Tour_Image` | Clear existing managed image rows for intro/itinerary captions | Create Tour transaction |
| 10 | CT-Q10 | `insertManagedImage` | `INSERT` | `Tour_Image` | Save intro and itinerary image rows when image URLs exist | Create Tour transaction |

### Conditional error re-render path

If validation fails or save fails, `forwardTourForm` reloads form support data. These queries are not part of successful persistence, but they are executed in the POST error response path.

| Order | Query ID | DAO method | Operation | Main table | Business purpose | Transaction |
| --- | --- | --- | --- | --- | --- | --- |
| E1 | CT-F01 | `getActiveCategories` | `SELECT` | `Tour_Category` | Reload category dropdown after errors | No |
| E2 | CT-F02 | `getActiveRegions` | `SELECT` | `Region` | Reload region dropdown after errors | No |
| E3 | CT-F03 | `AdministrativeUnitDAO.getActiveProvinces` | `SELECT` | `Administrative_Unit` | Reload province dropdown after errors | No |
| E4 | CT-F04 | `getNextTourCodePreview` | `SELECT` | `Tour` | Show next tour code preview after errors | No |

### CT-Q01 / CT-Q04

Business purpose: Verify the selected category and region are active before inserting a Tour.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Methods: `existsActiveCategory`, `existsActiveRegion`, `existsByIdAndStatus`
- Lines confirmed by `rg`: 395, 399, 814

SQL type: `SELECT`

SQL statement:

```sql
SELECT 1 FROM <tableName> WHERE <idColumn> = ? AND [status] = N'Active'
```

Actual calls:

- `existsActiveCategory` uses table `Tour_Category`, ID column `tourCategoryID`.
- `existsActiveRegion` uses table `Region`, ID column `regionID`.

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `categoryID` or `regionID` | `tourCategoryID` or `regionID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Category` | Read | Validate active category |
| `Region` | Read | Validate active region |

Expected result: `true` if one active row exists; otherwise `false`.

Business effect: Prevents a tour from being created with inactive/missing category or region before DB FK enforcement.

Failure effect: Exceptions are caught and printed; method returns `false`, causing validation error and preventing insert.

Transaction scope: Not inside the Create Tour transaction.

Safety review: Uses `PreparedStatement` for the ID value. Table and column names are string-built, but in this flow they are constants from DAO methods, not request input.

### CT-Q02 / CT-Q03

Business purpose: Verify that start and end provinces are active values in `Administrative_Unit`.

Source location:

- `src/main/java/vn/edu/fpt/DAO/AdministrativeUnitDAO.java`
- Class: `AdministrativeUnitDAO`
- Method: `isValidProvinceName`
- Lines confirmed by `rg`: 115, 121-124

SQL type: `SELECT`

SQL statement:

```sql
SELECT 1
FROM [dbo].[Administrative_Unit]
WHERE isActive = 1
  AND provinceName = ?
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `provinceName.trim()` | `provinceName` | `NVARCHAR(100)` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Administrative_Unit` | Read | Validate active province name |

Expected result: `true` if at least one active administrative unit has the province name.

Business effect: Prevents free-text start/end place values not recognized by the administrative data.

Failure effect: Exception returns `false`; validation fails and Tour is not inserted.

Transaction scope: Not inside the Create Tour transaction.

Safety review: Uses `PreparedStatement`; no SQL injection risk observed for the province parameter.

### CT-Q05

Business purpose: Create the main `Tour` row.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Method: `insertTourWithItineraries`
- Lines confirmed by `rg`: 420, 422

SQL type: `INSERT`

SQL statement:

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
)
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `tour.getTourCategoryID()` | `tourCategoryID` | `INT` | Yes |
| 2 | `tour.getTourName()` | `tourName` | `NVARCHAR(255)` | Yes |
| 3 | `tour.getTourType()` | `tourType` | `NVARCHAR(30)` | No |
| 4 | `tour.getNumberOfDay()` | `numberOfDay` | `INT` | Yes |
| 5 | `tour.getNumberOfNights()` | `numberOfNights` | `INT` | No |
| 6 | `tour.getStartPlace()` | `startPlace` | `NVARCHAR(255)` | Yes |
| 7 | `tour.getEndPlace()` | `endPlace` | `NVARCHAR(255)` | Yes |
| 8 | `tour.getImage()` | `image` | `NVARCHAR(500)` | No |
| 9 | `tour.getAdultPrice()` | `adultPrice` | `DECIMAL(18,2)` | Yes |
| 10 | `tour.getChildrenPrice()` | `childrenPrice` | `DECIMAL(18,2)` | Yes |
| 11 | `tour.getInfantPrice()` | `infantPrice` | `DECIMAL(18,2)` | Yes |
| 12 | `tour.getSingleRoomSurcharge()` | `singleRoomSurcharge` | `DECIMAL(18,2)` | Yes |
| 13 | `tour.getDepositPercent()` | `depositPercent` | `INT` | Yes |
| 14 | `tour.getVatPercent()` | `vatPercent` | `INT` | Yes |
| 15 | `tour.getTourIntroduce()` | `tourIntroduce` | `NVARCHAR(MAX)` | No |
| 16 | `tour.getTourInclude()` | `tourInclude` | `NVARCHAR(MAX)` | No |
| 17 | `tour.getTourNonInclude()` | `tourNonInclude` | `NVARCHAR(MAX)` | No |
| 18 | `tour.getPickupPointName()` | `pickupPointName` | `NVARCHAR(255)` | No |
| 19 | `tour.getPickupAddress()` | `pickupAddress` | `NVARCHAR(500)` | No |
| 20 | `tour.getArriveBeforeMinutes()` | `arriveBeforeMinutes` | `INT` | No |
| 21 | `tour.getPickupNote()` | `pickupNote` | `NVARCHAR(500)` | No |
| 22 | `tour.getMainTransportType()` | `mainTransportType` | `NVARCHAR(50)` | No |
| 23 | `tour.getChildPolicyNote()` | `childPolicyNote` | `NVARCHAR(MAX)` | No |
| 24 | `tour.getStatus()` | `status` | `NVARCHAR(50)` | Yes |
| 25 | `tour.isFeatured()` | `isFeatured` | `BIT` | Yes |
| 26 | `tour.getRegionID()` | `regionID` | `INT` | No |
| 27 | `tour.getCreatedByUserID()` | `createdByUserID` | `INT` | No, but FK applies if non-null |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour` | Insert | Create package tour |

Expected result: One inserted row and JDBC generated key for `tourID`.

Business effect: Creates a new Tour. `AddTourController` sets `data.status = "Draft"` before build/save, so the inserted status is `Draft`. `createdAt` is assigned by `GETDATE()`.

Failure effect: Constraint/FK/unique/connection errors are caught by `insertTourWithItineraries`; transaction rolls back and returns `0`.

Transaction scope: Inside Create Tour transaction.

Safety review: Uses `PreparedStatement` and generated keys. `tourCode` is initially inserted as `NULL`, then updated in CT-Q07.

### CT-Q06

Business purpose: Check whether a generated tour code candidate already exists.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Method: `tourCodeExists`
- Line confirmed by `rg`: 799

SQL type: `SELECT`

SQL statement:

```sql
SELECT 1 FROM Tour WHERE tourCode = ? AND tourID <> ?
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | Generated `tourCode` candidate | `tourCode` | `NVARCHAR(50)` | Yes |
| 2 | Current generated `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour` | Read | Verify unique generated tour code |

Expected result: `true` if another Tour already has the candidate code; otherwise `false`.

Business effect: Supports unique tour code generation before CT-Q07 updates the created Tour.

Failure effect: Exception aborts create transaction and rolls back.

Transaction scope: Inside Create Tour transaction.

Safety review: Uses `PreparedStatement`. Unique index on `Tour.tourCode` is also present in schema.

### CT-Q07

Business purpose: Save the generated `tourCode` after the identity `tourID` is known.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Method: `updateTourCode`
- Line confirmed by `rg`: 763

SQL type: `UPDATE`

SQL statement:

```sql
UPDATE Tour SET tourCode = ? WHERE tourID = ?
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `buildUniqueTourCode(conn, tourID)` | `tourCode` | `NVARCHAR(50)` | Yes |
| 2 | Generated `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour` | Update | Set generated tour code |

Expected result: One row updated.

Business effect: Completes the human-readable/business tour code after DB identity generation.

Failure effect: Exception aborts transaction and rolls back the inserted Tour.

Transaction scope: Inside Create Tour transaction.

Safety review: Uses `PreparedStatement`. The method does not explicitly check affected rows; if the generated `tourID` unexpectedly does not update, the transaction would still continue unless the DB throws.

### CT-Q08

Business purpose: Save itinerary rows belonging to the newly created Tour.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Method: `insertItineraries`
- Line confirmed by `rg`: 626

SQL type: Batch `INSERT`

SQL statement:

```sql
INSERT INTO Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
VALUES (?, ?, ?, ?, ?, ?, N'Active')
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | Created `tourID` | `tourID` | `INT` | Yes |
| 2 | `itinerary.getDayNumber()` | `dayNumber` | `INT` | Yes |
| 3 | `itinerary.getTitle()` | `title` | `NVARCHAR(255)` | Yes |
| 4 | `itinerary.getDescription()` | `description` | `NVARCHAR(MAX)` | No |
| 5 | `itinerary.getMealPlan()` | `mealPlan` | `NVARCHAR(255)` | No |
| 6 | `itinerary.getTransportNote()` | `transportNote` | `NVARCHAR(255)` | No |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Itinerary` | Insert | Save day-by-day itinerary |

Expected result: Batch insert succeeds for all itinerary rows.

Business effect: Links itinerary records to the new Tour through `tourID`.

Failure effect: Batch/constraint/FK failure aborts transaction and rolls back Tour plus previous operations.

Transaction scope: Inside Create Tour transaction.

Safety review: Uses `PreparedStatement` batch. FK `FK_Tour_Itinerary_Tour` and check `CK_Tour_Itinerary_Day` protect integrity.

### CT-Q09

Business purpose: Remove previously managed intro/itinerary image rows before inserting current managed images.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Method: `deleteManagedImages`
- Line confirmed by `rg`: 728

SQL type: `DELETE`

SQL statement:

```sql
DELETE FROM Tour_Image
WHERE tourID = ?
  AND (caption = N'INTRO_IMAGE' OR caption LIKE N'ITINERARY_DAY_%_IMAGE')
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | Created `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Image` | Delete | Clear managed image rows for this Tour |

Expected result: Zero or more rows deleted. For a new Tour, usually zero rows.

Business effect: Ensures managed image rows reflect submitted intro/itinerary images.

Failure effect: Exception aborts transaction and rolls back.

Transaction scope: Inside Create Tour transaction.

Safety review: Uses `PreparedStatement`; `WHERE tourID = ?` prevents deleting images for other tours.

### CT-Q10

Business purpose: Save managed intro and itinerary images.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Method: `insertManagedImage`
- Line confirmed by `rg`: 745

SQL type: `INSERT`

SQL statement:

```sql
INSERT INTO Tour_Image (tourID, imageUrl, caption, displayOrder, [status])
VALUES (?, ?, ?, ?, N'Active')
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | Created `tourID` | `tourID` | `INT` | Yes |
| 2 | Submitted/stored image URL | `imageUrl` | `NVARCHAR(500)` | Yes |
| 3 | `INTRO_IMAGE` or `ITINERARY_DAY_n_IMAGE` | `caption` | `NVARCHAR(255)` | No |
| 4 | Display order | `displayOrder` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Image` | Insert | Persist managed image metadata |

Expected result: One inserted row for each non-blank managed image.

Business effect: Links uploaded/managed image paths to the Tour.

Failure effect: FK/constraint/connection failure aborts transaction and rolls back Tour and itinerary rows.

Transaction scope: Inside Create Tour transaction.

Safety review: Uses `PreparedStatement`. Actual file storage happens before DB transaction; DB rollback does not delete already stored files from disk.

### CT-F01

Business purpose: Reload active categories for the form when POST returns errors.

Source location: `TourDAO.getActiveCategories`

SQL type: `SELECT`

SQL statement:

```sql
SELECT tourCategoryID, categoryName, [description], [status]
FROM Tour_Category
WHERE [status] = N'Active'
ORDER BY categoryName ASC
```

Parameters: None.

Expected result: List of active tour categories.

Business effect: Form can be re-rendered with valid category choices.

Transaction scope: No transaction.

### CT-F02

Business purpose: Reload active regions for the form when POST returns errors.

Source location: `TourDAO.getActiveRegions`

SQL type: `SELECT`

SQL statement:

```sql
SELECT regionID, regionName, [description], [status]
FROM Region
WHERE [status] = N'Active'
ORDER BY regionID ASC
```

Parameters: None.

Expected result: List of active regions.

Transaction scope: No transaction.

### CT-F03

Business purpose: Reload unique active province choices for the form when POST returns errors.

Source location: `AdministrativeUnitDAO.getActiveProvinces`

SQL type: `SELECT`

SQL statement:

```sql
SELECT
    MIN(administrativeUnitID) AS administrativeUnitID,
    MIN(provinceCode) AS provinceCode,
    provinceName
FROM [dbo].[Administrative_Unit]
WHERE isActive = 1
  AND provinceName IS NOT NULL
  AND LTRIM(RTRIM(provinceName)) <> N''
GROUP BY provinceName
ORDER BY
    CASE
        WHEN MIN(TRY_CONVERT(INT, provinceCode)) IS NULL THEN 999
        ELSE MIN(TRY_CONVERT(INT, provinceCode))
    END,
    provinceName
```

Parameters: None.

Expected result: Deduplicated active province list.

Transaction scope: No transaction.

### CT-F04

Business purpose: Show the next tour code preview when the form is re-rendered.

Source location: `TourDAO.getNextTourCodePreview`

SQL type: `SELECT`

SQL statement:

```sql
SELECT ISNULL(MAX(tourID), 0) + 1 AS nextTourID FROM Tour
```

Parameters: None.

Expected result: Numeric next ID estimate used to build preview code.

Business effect: UI preview only; not authoritative for final `tourCode`.

Transaction scope: No transaction.

## D. Approve Tour Query Execution Order

| Order | Query ID | DAO method | Operation | Main table | Business purpose | Transaction |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | AT-Q01 | `getTourById` | `SELECT` | `Tour` | Load selected Tour and metadata for controller checks | No |
| 2 | AT-Q02 | `getTourReadinessErrors` -> `getTourById` | `SELECT` | `Tour` | Reload Tour for readiness checks | No |
| 3 | AT-Q03 | `countActiveItineraries` | `SELECT COUNT` | `Tour_Itinerary` | Check itinerary completeness | No |
| 4 | AT-Q04 | `countValidSchedulesForApproval` | `SELECT COUNT` | `Tour_Scheduler` | Check at least one valid future schedule | No |
| 5 | AT-Q05 | `getDuplicateScheduleStartDateMap` | `SELECT` | `Tour_Scheduler` | Detect duplicate departure dates | No |
| 6 | AT-Q06 | `hasScheduleTransportTypeColumn` | `SELECT` | `INFORMATION_SCHEMA.COLUMNS` | Determine schedule query column compatibility | No |
| 7 | AT-Q07 | `getSchedulesByTourId` | `SELECT` | `Tour_Scheduler` | Load schedules for price warning validation | No |
| 8 | AT-Q08 | `approveTour` | `UPDATE` | `Tour` | Change Tour from `Pending` to `Active` | Approve Tour transaction |
| 9 | AT-Q09 | `approveTour` | `UPDATE` | `Tour_Scheduler` | Optionally open eligible schedules | Approve Tour transaction, only if `openSchedules=true` |

### AT-Q01 / AT-Q02

Business purpose: Load Tour by ID. The controller uses AT-Q01 to confirm the Tour exists and is `Pending`. `getTourReadinessErrors` calls the same method again as AT-Q02 for readiness checks.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Method: `getTourById`
- Line confirmed by `rg`: 138

SQL type: `SELECT`

SQL statement:

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
          AND ISNULL(b.[status], N'') NOT IN (N'Cancelled', N'Đã hủy')
    ), 0) AS bookingCount
FROM Tour t
JOIN Tour_Category tc ON t.tourCategoryID = tc.tourCategoryID
LEFT JOIN Region r ON t.regionID = r.regionID
LEFT JOIN [User] cu ON t.createdByUserID = cu.userID
LEFT JOIN [User] au ON t.approvedByUserID = au.userID
WHERE t.tourID = ?
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `tourID` | `t.tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour` | Read | Load Tour and status |
| `Tour_Category` | Read | Load category name; inner join means missing category prevents Tour result |
| `Region` | Read | Load region name |
| `[User]` | Read | Load creator/approver names |
| `Tour_Scheduler` | Read | Correlated schedule count and booking count |
| `Booking_Detail` | Read | Booking count |
| `Booking` | Read | Exclude cancelled bookings in count |

Expected result: One `Tour` or `null`.

Business effect: Supports existence and status checks before approval.

Failure effect: If no row is returned, controller redirects `notFound`; readiness adds "Tour does not exist".

Transaction scope: No transaction.

Safety review: Uses `PreparedStatement`; no SQL injection risk for `tourID`. The query does not filter out inactive tours; status validation is done by controller after retrieval.

### AT-Q03

Business purpose: Confirm enough active itinerary rows exist for the Tour day count.

Source location: `TourDAO.countActiveItineraries`, line confirmed by `rg`: 1633.

SQL type: `SELECT COUNT`

SQL statement:

```sql
SELECT COUNT(*)
FROM Tour_Itinerary
WHERE tourID = ?
  AND (status IS NULL OR status = N'Active')
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Itinerary` | Read | Count active itinerary rows |

Expected result: Integer count.

Business effect: Readiness fails if count is less than `Tour.numberOfDay`.

Failure effect: Exception returns `0`, causing readiness failure.

Transaction scope: No transaction.

### AT-Q04

Business purpose: Confirm the Tour has at least one schedule that can be sold after approval.

Source location: `TourDAO.countValidSchedulesForApproval`, line confirmed by `rg`: 1654.

SQL type: `SELECT COUNT`

SQL statement:

```sql
SELECT COUNT(*)
FROM Tour_Scheduler
WHERE tourID = ?
  AND scheduleStatus IN (N'Planned', N'Open')
  AND startDate >= CAST(GETDATE() AS DATE)
  AND maxParticipants > 0
  AND quantity < maxParticipants
  AND adultPrice > 100000
  AND childPrice = ROUND(adultPrice * 0.5, 0)
  AND ISNULL(singleRoomSurcharge, 0) >= 0
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Scheduler` | Read | Count valid future schedules |

Expected result: Integer count.

Business effect: Readiness fails if no valid schedule exists.

Failure effect: Exception returns `0`, causing readiness failure.

Transaction scope: No transaction.

Safety review: Uses `PreparedStatement`. `IX_Tour_Scheduler_Tour_Date` supports the `tourID/startDate` access pattern.

### AT-Q05

Business purpose: Detect duplicate start dates for schedules of the same Tour, excluding cancelled schedules.

Source location: `TourDAO.getDuplicateScheduleStartDateMap`, line confirmed by `rg`: 1139.

SQL type: `SELECT`

SQL statement:

```sql
SELECT CONVERT(date, startDate) AS dateKey
FROM Tour_Scheduler
WHERE tourID = ?
  AND scheduleStatus <> N'Cancelled'
GROUP BY CONVERT(date, startDate)
HAVING COUNT(*) > 1
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Scheduler` | Read | Detect duplicate departure dates |

Expected result: Zero or more duplicate date keys.

Business effect: Readiness fails if duplicate departure dates exist.

Failure effect: Exception returns an empty map; in that failure mode, duplicate-date readiness warning may be missed.

Transaction scope: No transaction.

### AT-Q06

Business purpose: Check whether the runtime schema contains optional column `scheduleTransportType` before selecting schedules.

Source location: `TourDAO.hasScheduleTransportTypeColumn`, line confirmed by `rg`: 844.

SQL type: `SELECT`

SQL statement:

```sql
SELECT 1
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Tour_Scheduler'
  AND COLUMN_NAME = 'scheduleTransportType'
```

Parameters: None.

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `INFORMATION_SCHEMA.COLUMNS` | Read | Detect optional schema column |

Expected result: `true` if column exists; otherwise `false`.

Business effect: Supports compatibility of AT-Q07 across schema versions.

Failure effect: Exception returns `false`, and AT-Q07 uses `CAST(NULL AS NVARCHAR(50)) AS scheduleTransportType`.

Transaction scope: No transaction.

### AT-Q07

Business purpose: Load schedules to check price warnings in Java.

Source location: `TourDAO.getSchedulesByTourId`, line confirmed by `rg`: 232.

SQL type: `SELECT`

SQL statement:

```sql
SELECT
    tourScheduleID, tourID, %s startDate, endDate, departureTime, expectedReturnTime,
    bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
    maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
    singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
    scheduleStatus, createdAt, updatedAt
FROM Tour_Scheduler
WHERE tourID = ?
ORDER BY startDate ASC, tourScheduleID ASC
```

`%s` is either:

```sql
scheduleTransportType,
```

or:

```sql
CAST(NULL AS NVARCHAR(50)) AS scheduleTransportType,
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Scheduler` | Read | Load schedule rows for price warning rules |

Expected result: List of `TourSchedule`.

Business effect: Java code checks each schedule for adult price > 100000, child price = 50% adult price, and non-negative single room surcharge.

Failure effect: Exception returns empty list; price-warning readiness errors may be missed.

Transaction scope: No transaction.

### AT-Q08

Business purpose: Approve a pending Tour.

Source location:

- `src/main/java/vn/edu/fpt/DAO/TourDAO.java`
- Class: `TourDAO`
- Method: `approveTour`
- Line confirmed by `rg`: 1698

SQL type: `UPDATE`

SQL statement:

```sql
UPDATE Tour
SET [status] = N'Active',
    approvedByUserID = ?,
    approvedAt = GETDATE(),
    rejectionReason = NULL,
    updatedAt = GETDATE()
WHERE tourID = ?
  AND [status] = N'Pending'
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `adminUserID` | `approvedByUserID` | `INT` | Yes |
| 2 | `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour` | Update | Change approval state and metadata |

Expected result: Affected row count > 0.

Business effect: Changes Tour status from `Pending` to `Active`, stores approver and approval time, clears rejection reason.

Failure effect: If affected rows <= 0, DAO rolls back and returns `false`. This protects against approving a Tour that is no longer `Pending`.

Transaction scope: Inside Approve Tour transaction.

Concurrency review: The `WHERE tourID = ? AND [status] = N'Pending'` condition plus affected-row check prevents a second Admin update from succeeding after the first approval changes status.

### AT-Q09

Business purpose: Optionally open eligible planned schedules when approving a Tour.

Source location: `TourDAO.approveTour`, line confirmed by `rg`: 1728.

SQL type: `UPDATE`

SQL statement:

```sql
UPDATE Tour_Scheduler
SET scheduleStatus = N'Open', updatedAt = GETDATE()
WHERE tourID = ?
  AND scheduleStatus = N'Planned'
  AND startDate >= CAST(GETDATE() AS DATE)
  AND quantity < maxParticipants
```

Parameters:

| Position/Name | Java value | Database column | Expected type | Required |
| --- | --- | --- | --- | --- |
| 1 | `tourID` | `tourID` | `INT` | Yes |

Tables involved:

| Table | Operation | Purpose |
| --- | --- | --- |
| `Tour_Scheduler` | Update | Open eligible schedules for sale |

Expected result: Zero or more rows updated.

Business effect: Changes eligible schedules from `Planned` to `Open` for the approved Tour.

Failure effect: If this update throws an exception, the catch block rolls back the Tour approval too. If it updates zero rows, the DAO still commits the Tour approval.

Transaction scope: Inside Approve Tour transaction, only when `openSchedules=true`.

Safety review: The query includes `WHERE tourID = ?`, `scheduleStatus = Planned`, future date, and available capacity. It does not update schedules from other tours.

## E. Sequence Diagram to Query Mapping

| Use case | Sequence message | Query IDs | Source method | Match status |
| --- | --- | --- | --- | --- |
| Create Tour | Verify active tour category and region | CT-Q01, CT-Q04 | `existsActiveCategory`, `existsActiveRegion` | Confirmed |
| Create Tour | Verify start and end provinces | CT-Q02, CT-Q03 | `AdministrativeUnitDAO.isValidProvinceName` | Confirmed |
| Create Tour | Validate tour information | CT-Q01 to CT-Q04 plus Java validation | `validateTourData` | Confirmed |
| Create Tour | Save Tour and related data | CT-Q05 to CT-Q10 | `insertTourWithItineraries` | Confirmed |
| Create Tour | Redirect to schedule creation | No DB query | `AddTourController.doPost` | Confirmed |
| Approve Tour | Find Tour by ID | AT-Q01 | `getTourById` | Confirmed |
| Approve Tour | Check approval eligibility | AT-Q02 to AT-Q07 | `getTourReadinessErrors` | Confirmed |
| Approve Tour | Approve Tour | AT-Q08 | `approveTour` | Confirmed |
| Approve Tour | Open eligible schedules | AT-Q09 | `approveTour` | Confirmed |

## F. Transaction Analysis

### Create Tour transaction

- Begins: `conn.setAutoCommit(false)` in `insertTourWithItineraries`.
- Queries in transaction: CT-Q05, CT-Q06, CT-Q07, CT-Q08, CT-Q09, CT-Q10. `insertSchedules` would also be in this transaction if `tour.scheduleList` were non-empty, but current `AddTourController` builds the tour with `includeInitialSchedule=false`.
- Commit: after all insert/update/delete operations complete.
- Rollback: any exception in the transaction block calls `rollbackQuietly(conn)` and returns `0`.
- Partial data risk: DB rows for Tour/itinerary/images are protected by transaction. File uploads are saved before DB insert, so file-system artifacts can remain if DB transaction later rolls back.

### Approve Tour transaction

- Begins: `conn.setAutoCommit(false)` in `approveTour`.
- Queries in transaction: AT-Q08 and optionally AT-Q09.
- Commit: after Tour update and optional schedule update complete.
- Rollback:
  - If AT-Q08 affects zero rows, DAO explicitly rolls back and returns `false`.
  - If AT-Q08 or AT-Q09 throws an exception, catch block rolls back and returns `false`.
- Concurrency protection: AT-Q08 requires `[status] = N'Pending'` and checks affected rows, so a second Admin cannot approve a Tour already changed to `Active` by another request.
- Optional schedule behavior: If `openSchedules=false`, AT-Q09 is skipped entirely. If `openSchedules=true` and no schedules match, Tour approval still commits.

## G. Data Integrity Review

| Finding ID | Use case | Query ID | Severity | Finding | Evidence | Impact |
| --- | --- | --- | --- | --- | --- | --- |
| DIR-01 | Create Tour | CT-Q05 to CT-Q10 | No issue | Main Tour, itinerary, and image DB writes are in one transaction | `insertTourWithItineraries` uses `setAutoCommit(false)`, `commit`, `rollbackQuietly` | Avoids partial DB save |
| DIR-02 | Create Tour | CT-Q10 | Low | Uploaded files are outside DB transaction | File saving occurs while reading form data before `insertTourWithItineraries` | DB rollback can leave unused files on disk |
| DIR-03 | Create Tour | CT-Q07 | Low | `updateTourCode` does not check affected rows | SQL is `UPDATE Tour SET tourCode = ? WHERE tourID = ?` and no affected-row check is used | Very low risk because `tourID` comes from generated key, but failure without exception could leave `tourCode` null |
| DIR-04 | Create Tour | CT-Q05 | No issue | Tour code uniqueness has both application check and DB unique index | CT-Q06 plus schema unique index on `Tour.tourCode` | Helps prevent duplicate tour code |
| DIR-05 | Create Tour | CT-Q01 / CT-Q04 | Low | Dynamic table/column SQL is used, but only with DAO constants in this flow | `existsByIdAndStatus("Tour_Category", ...)` and `existsByIdAndStatus("Region", ...)` | No request-driven injection observed for this flow |
| DIR-06 | Approve Tour | AT-Q08 | No issue | Approval update is guarded by `status = Pending` and affected-row check | SQL `WHERE tourID = ? AND [status] = N'Pending'`; rollback when `updated <= 0` | Prevents stale/concurrent approval |
| DIR-07 | Approve Tour | AT-Q09 | No issue | Schedule update scope is limited to selected Tour and eligible Planned schedules | `WHERE tourID = ? AND scheduleStatus = N'Planned' ...` | Avoids opening schedules from other tours |
| DIR-08 | Approve Tour | AT-Q05 / AT-Q07 | Low | Readiness checks are outside the final approval transaction | Readiness queries run before `approveTour` starts transaction | Schedule data could change between readiness check and approval update |
| DIR-09 | Approve Tour | AT-Q07 | Low | If schedule loading fails, price-warning map becomes empty | `getSchedulesByTourId` catches exception and returns empty list | A DB read error could hide price warnings and allow approval if other checks pass |
| DIR-10 | Schema | CT-Q05 / AT-Q08 | Medium | Base SQL dump default statuses differ from migration/application flow | Dump default `Tour=Active`, migration default `Tour=Draft`; Java inserts `Draft` explicitly | DB setup missing migration may behave differently for inserts outside Java |

## H. Sequence Diagram Mismatches

No material mismatch was found between the Sequence Diagrams and the confirmed database queries.

Notes:

- The Create Tour diagram says "Persist Tour, generated tour code, itinerary data, and managed images"; CT-Q05 to CT-Q10 confirm this.
- The Create Tour diagram redirects to schedule creation after success; no schedule insert query is confirmed in `POST /staff/tour/add` because `includeInitialSchedule=false`.
- The Approve Tour diagram says "Check approval eligibility"; AT-Q02 to AT-Q07 confirm the underlying readiness queries.
- The Approve Tour diagram says optional schedules move `Planned` to `Open`; AT-Q09 confirms this.

## I. Recommendations

### Required fixes

No required query fix was confirmed that directly causes wrong-scope updates, SQL injection, or partial DB transaction in the two analyzed flows.

### Optional improvements

- Consider checking affected rows in `updateTourCode` to fail fast if the generated `tourID` is not updated.
- Consider cleaning up uploaded files when Create Tour DB transaction rolls back, because file storage is outside DB transaction.
- Consider moving final readiness-sensitive checks closer to or inside the approval transaction if concurrent schedule edits become a real risk.
- Consider logging readiness query failures more explicitly; returning empty maps/lists can hide duplicate-date or price-warning checks.
- Ensure database setup always applies `20260716_admin_tour_approval_support.sql`; otherwise schema defaults remain `Tour=Active` and `Schedule=Open` in the base dump.

## J. Final Verification

- Confirmed actual source queries for Create Tour and Approve Tour.
- Confirmed active runtime package for these flows uses `vn.edu.fpt.DAO`.
- Confirmed schema tables and columns from `D:/Downloads/5.0.sql`.
- Confirmed approval support migration changes default `Tour.status` to `Draft` and `Tour_Scheduler.scheduleStatus` to `Planned`.
- Confirmed Create Tour status inserted by Java is `Draft`.
- Confirmed Approve Tour state transition is `Pending -> Active`.
- Confirmed optional Schedule state transition is `Planned -> Open`.
- Confirmed Create Tour DB writes are inside one transaction.
- Confirmed Approve Tour status update and optional schedule update are inside one transaction.
- Confirmed parameter binding with `PreparedStatement` for request-derived values in these flows.
- Confirmed affected-row check exists for approval `Tour` update.
- Confirmed Schedule update includes `tourID` and does not update all schedules.
- No new query was invented.
- No source code was modified.
- No SQL script was modified.
- No database command was executed.
- Algorithm details, Java loops, field mapping, and SQL rewrites were intentionally omitted except where needed to identify actual query execution.
