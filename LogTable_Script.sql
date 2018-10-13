/*
DATE: 2018-10-12
AUTHOR: Indranil Dey
PURPOSE: Script to Create a table to log the changes made in tables 
*/
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'LogTable')
CREATE TABLE dbo.LogTable (LogID INT, LogDateTime DATETIME, LogXML VARCHAR(MAX), LogTable VARCHAR(100), LogKey VARCHAR(100))