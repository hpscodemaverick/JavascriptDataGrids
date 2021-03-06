USE [GeetSangeet_LocalTest]
GO
--==================================================
-- Author:	Harish Chand
-- Create Date : 06/03/2020
-- Description : Get Employee Grid Filters values
--==================================================

CREATE PROCEDURE [dbo].[uspGetEmployeeGridFilters]
(
	@WhereCondition varchar(3000)	
)
AS
BEGIN
	
	BEGIN TRY	
		DECLARE @SQL_UNIQUE_VALUES nvarchar(max)
		SET @SQL_UNIQUE_VALUES='
		SELECT DISTINCT 
		GENDER
		,STATE 
		FROM DBO.EMPLOYEE  where ' + @WhereCondition 					
		EXEC sp_executesql @SQL_UNIQUE_VALUES, N'@WhereCondition nvarchar(max)',@WhereCondition=@WhereCondition;		
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