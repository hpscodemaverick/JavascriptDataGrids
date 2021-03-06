--==================================================
-- Author:	Harish Chand
-- Create Date : 06/03/2020
-- Description : Get Track Details
--==================================================


CREATE PROCEDURE [dbo].[uspGetAllTracksWithCTE_NEW]
(
	@SortCol varchar(50)=NULL,
	@SortOrder varchar(10)=NULL,
	@PageSize int,
	@CurrentPage int,
	@WhereCondition varchar(3000),
	@TotalRecords int output
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY	
		DECLARE @SQL_TOTAL_COUNT nvarchar(max)
		SET @SQL_TOTAL_COUNT='SELECT @TotalRecords=COUNT(1) FROM [dbo].[Track] where ' + @WhereCondition 
		print @SQL_TOTAL_COUNT
		EXEC sp_executesql @SQL_TOTAL_COUNT, N'@WhereCondition nvarchar(max),@TotalRecords int output',@WhereCondition=@WhereCondition,@TotalRecords=@TotalRecords OUTPUT;
		
		DECLARE @SQL nvarchar(max)
		SET @SQL='
		 WITH Paging_CTE AS		
		(		 
			SELECT 
			   [Id]
			  ,[TrackName]
			  ,[AlbumId]
			  ,[Composer]
			  ,[Performer]
			  ,[Featuring]
			  ,[Duration]
			  ,[DateCreated]
			  ,[CreatedBy]
			  ,[DateModified]
			  ,[ModifiedBy]
			  ,[IsDeleted]
			FROM [dbo].[Track]
			where '+ @WhereCondition +'
		)		
		SELECT 
			   [Id]
			  ,[TrackName]
			  ,[AlbumId]
			  ,[Composer]
			  ,[Performer]
			  ,[Featuring]
			  ,[Duration]
			  ,[DateCreated]
			  ,[CreatedBy]
			  ,[DateModified]
			  ,[ModifiedBy]
			  ,[IsDeleted]
	   FROM Paging_CTE
	  ORDER BY
		   CASE WHEN @SortCol=''id'' AND @SortOrder=''Desc'' THEN [id] END DESC,
		   CASE WHEN @SortCol=''TrackName'' AND @SortOrder=''Desc'' THEN [TrackName] END DESC,
		   CASE WHEN @SortCol=''AlbumId'' AND @SortOrder=''Desc'' THEN [AlbumId] END DESC,
		   CASE WHEN @SortCol=''Composer'' AND @SortOrder=''Desc'' THEN [Composer] END DESC,
		   CASE WHEN @SortCol=''Performer'' AND @SortOrder=''Desc'' THEN [Performer] END DESC,
		   CASE WHEN @SortCol=''Featuring'' AND @SortOrder=''Desc'' THEN [Featuring] END DESC,
		   CASE WHEN @SortCol=''Duration'' AND @SortOrder=''Desc'' THEN [Duration] END DESC,
		   CASE WHEN @SortCol=''DateCreated'' AND @SortOrder=''Desc'' THEN [DateCreated] END DESC,
		   CASE WHEN @SortCol=''id'' AND @SortOrder=''ASC'' THEN id END ASC,	 
		   CASE WHEN @SortCol=''TrackName'' AND @SortOrder=''ASC'' THEN [TrackName] END ASC,
		   CASE WHEN @SortCol=''AlbumId'' AND @SortOrder=''ASC'' THEN [AlbumId] END ASC,
		   CASE WHEN @SortCol=''Composer'' AND @SortOrder=''ASC'' THEN [Composer] END ASC,
		   CASE WHEN @SortCol=''Performer'' AND @SortOrder=''ASC'' THEN [Performer] END ASC,
		   CASE WHEN @SortCol=''Featuring'' AND @SortOrder=''ASC'' THEN [Featuring] END ASC,
		   CASE WHEN @SortCol=''Duration'' AND @SortOrder=''ASC'' THEN [Duration] END ASC,
		   CASE WHEN @SortCol=''DateCreated'' AND @SortOrder=''ASC'' THEN [DateCreated] END ASC
		OFFSET  @PageSize *(@CurrentPage-1)  ROWS FETCH NEXT  @PageSize  ROWS ONLY;'
		
		EXEC sp_executesql @SQL, N'@PageSize int, @CurrentPage int,@SortCol varchar(50)=NULL,@SortOrder varchar(10)=NULL,@WhereCondition varchar(3000)',
		@PageSize=@PageSize,@CurrentPage=@CurrentPage,@SortCol=@SortCol,@SortOrder=@SortOrder,@WhereCondition=@WhereCondition;

	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;

		SELECT
			@ErrorMessage=ERROR_MESSAGE(),
			@ErrorSeverity=ERROR_SEVERITY(),
			@ErrorState=ERROR_STATE();

		RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);

	END CATCH

END