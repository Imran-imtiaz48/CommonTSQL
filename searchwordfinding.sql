use Newton
go

alter PROC SearchWord
(
	@SearchStr nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF EXISTS (SELECT 1 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME='temp') 
	begin
		drop table temp
	end

	create table temp
	(	
		Tablenm varchar(100),
		FieldNM varchar(100)
		, _rowCount int default 0
	)
	DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110), @SQL nvarchar(4000), @RCTR int
	set @SQL=' '
	SET  @TableName = ''
	SET @SearchStr2 = QUOTENAME(  @SearchStr ,'''')
	SET @RCTR = 0

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
			FROM 	INFORMATION_SCHEMA.TABLES
			WHERE 		TABLE_TYPE = 'BASE TABLE'
				AND	QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
				AND	OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
							 ), 'IsMSShipped'
						       ) = 0
		)
		print 'Table Name' + @tablename
		
		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT MIN(QUOTENAME(COLUMN_NAME))
				FROM 	INFORMATION_SCHEMA.COLUMNS
				WHERE 		TABLE_SCHEMA	= PARSENAME(@TableName, 2)
					AND	TABLE_NAME	= PARSENAME(@TableName, 1)
					AND	DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar'
						, 'text'
						)
					AND	QUOTENAME(COLUMN_NAME) > @ColumnName
			)
	
			IF @ColumnName IS NOT NULL
			BEGIN
				declare @cntr int
				 
				set @sql = N'select @cntr=count(*)  from '+ @TableName 
				+' WHERE ' + @ColumnName + ' like ' + @SearchStr2 

				EXEC sp_executesql @query = @sql,@params = N'@cntr INT OUTPUT', @cntr = @cntr OUTPUT 
				 
				 print @sql
				if convert(int,isnull(@cntr,0))>0
				begin
					insert into temp values(@TableName,@ColumnName, @cntr)
				end
			END
		END	
	END

	select * from temp
	drop table temp
END
---- Exec SearchWord 'ankit'
go
Exec SearchWord '%Customer%'
