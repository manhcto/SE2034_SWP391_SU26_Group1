USE [WonderVn]
GO

SET NOCOUNT ON;
GO

/* Allow customer posts to move through the staff moderation workflow. */
IF OBJECT_ID(N'dbo.CK_Blog_Status_Merged', N'C') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Blog] DROP CONSTRAINT [CK_Blog_Status_Merged];
END
GO

UPDATE [dbo].[Blog]
SET [status] = N'Draft'
WHERE [status] NOT IN (N'Draft', N'Pending', N'Published', N'Rejected');
GO

ALTER TABLE [dbo].[Blog] WITH CHECK ADD CONSTRAINT [CK_Blog_Status_Merged]
    CHECK ([status] IN (N'Draft', N'Pending', N'Published', N'Rejected'));
GO
