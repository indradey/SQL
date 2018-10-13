/*
DATE: 2018-10-12
AUTHOR: Indranil Dey
PURPOSE: SCRIPT TO Create a sample UPDATE TRIGGER
*/

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'trg_Employee_UPD')
DROP TRIGGER dbo.trg_Employee_UPD
GO
CREATE TRIGGER dbo.trg_Employee_UPD
ON dbo.Employee FOR UPDATE
AS
BEGIN
	
	CREATE TABLE #TempLogTable(logid int identity, ID int, NAME VARCHAR(100), Phone VARCHAR(13), Email VARCHAR(60), 
	ID_UPD int, NAME_UPD VARCHAR(100), Phone_UPD VARCHAR(13), Email_UPD VARCHAR(60))
	
	INSERT INTO #TempLogTable
	SELECT  i.id,
		    i.name,
		    i.Phone,
		    i.email,
		    d.id,
			d.name,
			d.Phone,
			d.email
		   FROM inserted i
		   INNER JOIN 
			deleted d ON i.id = d.id

		DECLARE @Count INT = 1, @TotalCount INT
		SELECT @TotalCount = COUNT(1) FROM #TempLogTable
		WHILE(@Count<=@TotalCount)
		BEGIN
			-- COLUMN NAME and Data type with size same as actual columns of the table
			DECLARE @ID INT,
			@NAME VARCHAR(100),
			@Phone VARCHAR(13),
			@Email VARCHAR(60),
			--COLUMN NAME WITH UPD APPENDED at the back
			@ID_UPD INT,
			@NAME_UPD VARCHAR(100),
			@Phone_UPD VARCHAR(13),
			@Email_UPD VARCHAR(60)

			SELECT @ID = id,
			   @NAME = name,
			   @Phone = Phone,
			   @Email = email,
			   @ID_UPD = ID_UPD,
			   @NAME_UPD = NAME_UPD,
			   @Phone_UPD = Phone_UPD,
			   @Email_UPD = Email_UPD
			   FROM #TempLogTable WHERE Logid = @Count


		   DECLARE @LogXML VARCHAR(MAX)
		   SELECT @LogXML = '<LOG>'
		   
		   IF((@ID <> @ID_UPD) OR (@ID_UPD = NULL AND @ID !=NULL) OR (@ID = NULL AND @ID_UPD != NULL))
		   BEGIN
			SELECT @LogXML = @LogXML + '<ID_BEFORE>' + ISNULL(@ID_UPD, 'NULL') + '</ID_BEFORE>'
			SELECT @LogXML = @LogXML + '<ID_AFTER>' + ISNULL(@ID, 'NULL') + '</ID_AFTER>'
		   END

		   IF((@NAME <> @NAME_UPD) OR (@NAME_UPD = NULL AND @NAME !=NULL) OR (@NAME = NULL AND @NAME_UPD != NULL))
		   BEGIN
			SELECT @LogXML = @LogXML + '<NAME_BEFORE>' + ISNULL(@NAME_UPD, 'NULL') + '</NAME_BEFORE>'
			SELECT @LogXML = @LogXML + '<NAME_AFTER>' + ISNULL(@NAME, 'NULL') + '</NAME_AFTER>'
		   END

		   IF((@Phone <> @Phone_UPD) OR (@Phone_UPD = NULL AND @Phone !=NULL) OR (@Phone = NULL AND @Phone_UPD != NULL))
		   BEGIN
			SELECT @LogXML = @LogXML + '<PHONE_BEFORE>' + ISNULL(@Phone_UPD, 'NULL') + '</PHONE_BEFORE>'
			SELECT @LogXML = @LogXML + '<PHONE_AFTER>' + ISNULL(@Phone, 'NULL') + '</ID_AFTER>'
		   END

		   IF((@Email <> @Email_UPD) OR (@Email_UPD = NULL AND @Email !=NULL) OR (@Email = NULL AND @Email_UPD != NULL))
		   BEGIN
			SELECT @LogXML = @LogXML + '<EMAIL_BEFORE>' + ISNULL(@ID_UPD, 'NULL') + '</EMAIL_BEFORE>'
			SELECT @LogXML = @LogXML + '<EMAIL_AFTER>' + ISNULL(@ID, 'NULL') + '</EMAIL_AFTER>'
		   END

		   SELECT @LogXML = @LogXML + '</LOG>'

		   INSERT INTO dbo.LogTable(LogDateTime, LogXML, LogTable, LogKey) VALUES (GETDATE(), @LogXML, 'Employee', @ID)

		   SELECT @Count = @Count + 1
		END
END
GO