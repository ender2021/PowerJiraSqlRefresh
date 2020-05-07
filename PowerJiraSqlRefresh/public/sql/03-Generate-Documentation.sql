USE [Jira]

DECLARE @LiveTablesSectionName VARCHAR(50) = 'Live Tables'
       ,@LiveTablesSectionOrder INT = 1
	   ,@LiveTablesSectionDescription VARCHAR(200) = 'As the name implies, the live tables are where the extracted Jira data is ultimately stored for use in reporting.'
	   ,@StagingTablesSectionName VARCHAR(50) = 'Staging Tables'
	   ,@StagingTablesSectionOrder INT = 2
	   ,@StagingTablesSectionDescription VARCHAR(200) = 'The staging tables are used to store retrieved data while a refresh is in progress. After all data has been successfully retrieved, the staging tables are synced to the live tables.  As such, their schemas are identical to their live counterparts.'
	   ,@LookupTablesSectionName VARCHAR(50) = 'Lookup Tables'
	   ,@LookupTablesSectionOrder INT = 3
	   ,@LookupTablesSectionDescription VARCHAR(200) = 'The lookup tables store translations of code values used by the logging tables into readable values.'
	   ,@LoggingTablesSectionName VARCHAR(50) = 'Logging Tables'
	   ,@LoggingTableSectionOrder INT = 4
	   ,@LoggingTablesSectionDescription VARCHAR(200) = 'For now, the only logging table is tbl_Jira_Refresh, which stores audit information about executions of the refresh job.'

--create a temp table to store result rows
IF OBJECT_ID('tempdb..#markdown') IS NOT NULL
	DROP TABLE #markdown
CREATE TABLE #markdown
(
	[section_name] VARCHAR(50),
	[section_order] INT,
	[table_name] varchar(200),
	[colid] INT,
	[markdown] VARCHAR(200)
)

--create a temp table for storing table information
IF OBJECT_ID('tempdb..#sectionedTables') IS NOT NULL
	DROP TABLE #sectionedTables
CREATE TABLE #sectionedTables
(
	[section_name] VARCHAR(50),
	[section_order] INT,
	[section_description] VARCHAR(200),
	[table_name] varchar(200)
)

--insert the live table names
INSERT INTO [#sectionedTables]
(
    [section_name],
    [section_order],
	[section_description],
    [table_name]
)
SELECT   @LiveTablesSectionName
		,@LiveTablesSectionOrder
		,@LiveTablesSectionDescription
		,[o].[name]
FROM sysobjects o 
WHERE [o].[name] LIKE 'tbl_Jira_%' AND [o].[name] <> 'tbl_Jira_Refresh'

--insert the staging table names
INSERT INTO [#sectionedTables]
(
    [section_name],
    [section_order],
	[section_description],
    [table_name]
)
SELECT   @StagingTablesSectionName
		,@StagingTablesSectionOrder
		,@StagingTablesSectionDescription
		,[o].[name]
FROM sysobjects o 
WHERE [o].[name] LIKE 'tbl_stg_%'

--insert the lookup table names
INSERT INTO [#sectionedTables]
(
    [section_name],
    [section_order],
	[section_description],
    [table_name]
)
SELECT   @LookupTablesSectionName
		,@LookupTablesSectionOrder
		,@LookupTablesSectionDescription
		,[o].[name]
FROM sysobjects o 
WHERE [o].[name] LIKE 'tbl_lk_%'

--insert the logging table names
INSERT INTO [#sectionedTables]
(
    [section_name],
    [section_order],
	[section_description],
    [table_name]
)
SELECT   @LoggingTablesSectionName
		,@LoggingTableSectionOrder
		,@LoggingTablesSectionDescription
		,[o].[name]
FROM sysobjects o 
WHERE [o].[name] = 'tbl_Jira_Refresh'

--insert Tables header line
	INSERT INTO [#markdown]
	(
		[section_name],
		[section_order],
		[table_name],
		[colid],
		[markdown]
	)
	VALUES
	(   'Tables', -- section - varchar(50)
		0,  -- section_order - int
		'N/A', -- table_name - varchar(200)
		0,  -- colid - int
		'## Tables'  -- markdown - varchar(200)
		)

--now that we have all the table names stored and catorized, loop through each section
DECLARE @currSectionName AS VARCHAR(50)
	   ,@currSectionOrder AS INT
	   ,@currSectionDescription AS VARCHAR(200)
SELECT @currSectionOrder = MIN(section_order) FROM [#sectionedTables]
WHILE @currSectionOrder IS NOT NULL
BEGIN
	SELECT @currSectionName = MIN([section_name]), @currSectionDescription = MIN([section_description]) FROM [#sectionedTables] WHERE [section_order] = @currSectionOrder

	--insert section header line
	INSERT INTO [#markdown]
	(
		[section_name],
		[section_order],
		[table_name],
		[colid],
		[markdown]
	)
	VALUES
	(   @currSectionName, -- section - varchar(50)
		@currSectionOrder,  -- section_order - int
		'N/A', -- table_name - varchar(200)
		0,  -- colid - int
		'### ' + @currSectionName  -- markdown - varchar(200)
		)

	--insert section description line
	INSERT INTO [#markdown]
	(
		[section_name],
		[section_order],
		[table_name],
		[colid],
		[markdown]
	)
	VALUES
	(   @currSectionName, -- section - varchar(50)
		@currSectionOrder,  -- section_order - int
		'N/A', -- table_name - varchar(200)
		1,  -- colid - int
		@currSectionDescription  -- markdown - varchar(200)
		)

	--loop through tables and create rows to store
	DECLARE @table AS VARCHAR(200)
	SELECT @table = MIN([table_name]) FROM [#sectionedTables] WHERE [section_order] = @currSectionOrder
	WHILE @table IS NOT NULL
	BEGIN
		
		WITH Results ([section_name], [section_order], [table_name],[colid],[markdown]) AS (
			SELECT @currSectionName, @currSectionOrder, @table AS tablename, -2 AS colid, '#### ' + @table
			UNION ALL
			select @currSectionName, @currSectionOrder, @table as tablename,-1 as colid, '|Column|Type|Length|Nullable|' as markdown
			UNION ALL
			select @currSectionName, @currSectionOrder, @table as tablename, 0 as colid, '|---|---|---|---|' as markdown
			UNION ALL
			select @currSectionName, @currSectionOrder, o.name as tablename, c.colid, c.name+'|'+ t.name +'|' + convert(varchar(10),c.length) + '|' + CASE c.[isnullable] WHEN 0 THEN 'No' ELSE 'Yes' END + '|' as markdown
			from sysobjects o 
			inner join syscolumns c on c.id = o.id
			inner join systypes t on t.xtype = c.xtype
			where o.name = @table
		)
		INSERT INTO [#markdown]
		(
			[section_name],
			[section_order],
			[table_name],
			[colid],
			[markdown]
		)
		SELECT [Results].[section_name],
               [Results].[section_order],
               [Results].[table_name],
               [Results].[colid],
               [Results].[markdown]
		FROM [Results]

		SELECT @table = MIN([table_name]) FROM [#sectionedTables] WHERE [section_order] = @currSectionOrder AND [table_name] > @table
	END

	SELECT @currSectionOrder = MIN(section_order) FROM [#sectionedTables] WHERE section_order > @currSectionOrder
END

--select the results
SELECT [section_name],
       [section_order],
       [table_name],
       [colid],
       [markdown]
FROM [#markdown]
ORDER BY [section_order], [table_name], [colid]