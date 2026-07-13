USE [WonderVn]
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;

IF EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE [name] = N'CK_Payments_Status_Merged'
      AND parent_object_id = OBJECT_ID(N'dbo.Payments')
)
BEGIN
    ALTER TABLE dbo.Payments DROP CONSTRAINT CK_Payments_Status_Merged;
END;

ALTER TABLE dbo.Payments WITH CHECK
ADD CONSTRAINT CK_Payments_Status_Merged CHECK (
    [status] IN (
        N'Chờ thanh toán', N'Đã thanh toán', N'Thất bại', N'Đã hủy',
        N'Pending', N'Paid', N'Failed', N'Cancelled'
    )
);

UPDATE dbo.Booking
SET [status] = CASE [status]
    WHEN N'Pending' THEN N'Đang xử lý'
    WHEN N'Confirmed' THEN N'Đã duyệt'
    WHEN N'Cancelled' THEN N'Đã hủy'
    WHEN N'Completed' THEN N'Hoàn thành'
    ELSE [status]
END
WHERE [status] IN (N'Pending', N'Confirmed', N'Cancelled', N'Completed');

IF OBJECT_ID(N'dbo.Payments', N'U') IS NOT NULL
BEGIN
    UPDATE dbo.Payments
    SET [status] = CASE [status]
        WHEN N'Pending' THEN N'Chờ thanh toán'
        WHEN N'Paid' THEN N'Đã thanh toán'
        WHEN N'Cancelled' THEN N'Đã hủy'
        WHEN N'Failed' THEN N'Thất bại'
        ELSE [status]
    END
    WHERE [status] IN (N'Pending', N'Paid', N'Cancelled', N'Failed');
END;

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
ADD CONSTRAINT DF_Booking_Status_VI DEFAULT (N'Đang xử lý') FOR [status];

COMMIT TRANSACTION;
GO
