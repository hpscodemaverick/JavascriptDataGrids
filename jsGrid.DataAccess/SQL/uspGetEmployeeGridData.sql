USE [GeetSangeet_LocalTest]
GO

--==================================================
-- Author:	Harish Chand
-- Create Date : 06/03/2020
-- Description : Get Employee Details
--==================================================


ALTER PROCEDURE [dbo].[uspGetEmployeeGridData]
(
	@SortColumn varchar(50)=NULL,
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
		SET @SQL_TOTAL_COUNT='SELECT @TotalRecords=COUNT(1) FROM [dbo].[Employee] where ' + @WhereCondition 
		print @SQL_TOTAL_COUNT
		EXEC sp_executesql @SQL_TOTAL_COUNT, N'@WhereCondition nvarchar(max),@TotalRecords int output',@WhereCondition=@WhereCondition,@TotalRecords=@TotalRecords OUTPUT;
		
		DECLARE @SQL nvarchar(max)
		SET @SQL='
		 WITH Paging_CTE AS		
		(		 
			SELECT
			   [Id]
			  ,[GuidId]
			  ,[Salutation]
			  ,[FirstName]
			  ,[LastName]
			  ,[MI]
			  ,[Gender]
			  ,CONVERT(varchar, DateOfBirth, 101) as DateOfBirth
			  ,[Email]
			  ,[Phone]
			  ,[AddressLine]
			  ,[City]
			  ,[State]
			  ,[ZipCode]
			  ,[Salary]
			  ,[SSN]
			FROM [dbo].[Employee]
			where '+ @WhereCondition +'
		)		
		SELECT 
			   [Id]
			  ,[GuidId]
			  ,[Salutation]
			  ,[FirstName]
			  ,[LastName]
			  ,[MI]
			  ,[Gender]
			  ,[DateOfBirth]
			  ,[Email]
			  ,[Phone]
			  ,[AddressLine]
			  ,[City]
			  ,[State]
			  ,[ZipCode]
			  ,[Salary]
			  ,[SSN]
	   FROM Paging_CTE
	  ORDER BY
		   
		   CASE WHEN @SortColumn=''Salutation'' AND @SortOrder=''Desc'' THEN [Salutation] END DESC,
		   CASE WHEN @SortColumn=''Salutation'' AND @SortOrder=''Asc'' THEN [Salutation] END ASC,

		   CASE WHEN @SortColumn=''FirstName'' AND @SortOrder=''Desc'' THEN [FirstName] END DESC,
		   CASE WHEN @SortColumn=''FirstName'' AND @SortOrder=''Asc'' THEN [FirstName] END ASC,
		   CASE WHEN @SortColumn=''LastName'' AND @SortOrder=''Desc'' THEN [LastName] END DESC,
		   CASE WHEN @SortColumn=''LastName'' AND @SortOrder=''Asc'' THEN [LastName] END ASC,
		  
		   CASE WHEN @SortColumn=''Gender'' AND @SortOrder=''Desc'' THEN [Gender] END DESC,
		   CASE WHEN @SortColumn=''Gender'' AND @SortOrder=''Asc'' THEN [Gender] END ASC,

		   CASE WHEN @SortColumn=''DateOfBirth'' AND @SortOrder=''Desc'' THEN [DateOfBirth] END DESC,
		   CASE WHEN @SortColumn=''DateOfBirth'' AND @SortOrder=''Asc'' THEN [DateOfBirth] END ASC,

		   CASE WHEN @SortColumn=''City'' AND @SortOrder=''Desc'' THEN [City] END DESC,
		   CASE WHEN @SortColumn=''City'' AND @SortOrder=''Asc'' THEN [City] END ASC,
		   CASE WHEN @SortColumn=''State'' AND @SortOrder=''Desc'' THEN [State] END DESC,
		   CASE WHEN @SortColumn=''State'' AND @SortOrder=''Asc'' THEN [State] END ASC,

		   CASE WHEN @SortColumn=''Salary'' AND @SortOrder=''Desc'' THEN [Salary] END DESC,
		   CASE WHEN @SortColumn=''Salary'' AND @SortOrder=''Asc'' THEN [Salary] END ASC
		OFFSET  @PageSize *(@CurrentPage-1)  ROWS FETCH NEXT  @PageSize  ROWS ONLY;'
		
		EXEC sp_executesql @SQL, N'@PageSize int, @CurrentPage int,@SortColumn varchar(50)=NULL,@SortOrder varchar(10)=NULL,@WhereCondition varchar(3000)',
		@PageSize=@PageSize,@CurrentPage=@CurrentPage,@SortColumn=@SortColumn,@SortOrder=@SortOrder,@WhereCondition=@WhereCondition;

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