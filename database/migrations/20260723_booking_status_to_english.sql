USE [WonderVn]
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;

UPDATE dbo.Booking
SET [status] = CASE [status]
    WHEN N'\u0110ang x\u1eed l\u00fd' THEN N'Pending'
    WHEN N'\u0110\u00e3 duy\u1ec7t' THEN N'Confirmed'
    WHEN N'\u0110\u00e3 h\u1ee7y' THEN N'Cancelled'
    WHEN N'Ho\u00e0n th\u00e0nh' THEN N'Completed'
    ELSE [status]
END
WHERE [status] IN (
    N'\u0110ang x\u1eed l\u00fd',
    N'\u0110\u00e3 duy\u1ec7t',
    N'\u0110\u00e3 h\u1ee7y',
    N'Ho\u00e0n th\u00e0nh'
);

DECLARE @bookingDefaultConstraint sysname;
SELECT @bookingDefaultConstraint = dc.[name]
FROM sys.default_constraints dc
JOIN sys.columns c
  ON c.[object_id] = dc.parent_object_id
 AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID(N'dbo.Booking')
  AND c.[name] = N'status';

IF @bookingDefaultConstraint IS NOT NULL
BEGIN
    EXEC(N'ALTER TABLE dbo.Booking DROP CONSTRAINT ' + QUOTENAME(@bookingDefaultConstraint));
END;

ALTER TABLE dbo.Booking
ADD CONSTRAINT DF_Booking_Status_EN DEFAULT (N'Pending') FOR [status];

COMMIT TRANSACTION;
GO
