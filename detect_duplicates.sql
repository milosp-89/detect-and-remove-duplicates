-- stored procedure for detecting duplicates rows/entries

use [xxx];
go

create procedure detect_duplicates
as
begin
	declare @SchemaName nvarchar(100) 
	declare @TableName nvarchar(100)
	declare @DatabaseName nvarchar(100)
	create table duplicates_log 
	  ( 
		 databasename       nvarchar(100), 
		 schemaname         nvarchar(100), 
		 tablename          nvarchar(100), 
		 columnlist         nvarchar(max), 
		 duplicatevalue     nvarchar(max), 
		 totaltablerowcount int, 
		 duplicaterowcnt    int 
	  ) 
	declare cur cursor for
	select 
		table_catalog, 
		table_schema, 
		table_name 
	from information_schema.tables 
	where table_type = 'BASE TABLE'
	open cur 
	fetch next from cur into
		@DatabaseName,
		@SchemaName,
		@TableName 
	while @@FETCH_STATUS = 0 
	  begin 
		  declare @ColumnList nvarchar(max)= NULL 
		  select @ColumnList = coalesce(@ColumnList + '],[', '') + c.name 
		  from sys.columns c 
			   inner join sys.tables t 
			   on c.object_id = t.object_id 
		  where Object_name(c.object_id) = @TableName 
				and Schema_name(schema_id) = @SchemaName 
				and is_identity = 0 
		  set @ColumnList='[' + @ColumnList + ']' 
		  declare @ColumnListConcat nvarchar(max)= NULL 
		  set @ColumnListConcat=replace(replace(replace(replace(@ColumnList, '[', 
		  'ISNULL(Cast(['), ']', 
		  '] AS VARCHAR(MAX)),''NULL'')'), 
		  ',ISNULL', '+ISNULL'), '+', '+'',''+') 
		  declare @DuplicateSQL nvarchar(max)= NULL 
		  set @DuplicateSQL= ';with cte as   (select  ''' 
							 + @DatabaseName + ''' as DbName,' + '''' 
							 + @SchemaName + ''' as SchemaName,' + '''' 
							 + @TableName + ''' as TableName,' + '''' 
							 + @ColumnList + ''' as ColumnList,' 
							 + @ColumnListConcat 
							 + ' as ColumnConcat, (select count(*) from [' + @SchemaName 
							 + '].[' + @TableName 
							 + '] with (nolock)) AS TotalTableRowCount, rn = row_number() over(partition by ' 
							 + @ColumnList + '  order by ' + @ColumnList 
							 + ') from [' + @SchemaName + '].[' 
							 + @TableName + ']  ) select * from cte where rn>1' 
		  insert into duplicates_log 
		  exec(@DuplicateSQL) 
		  fetch next from cur into
			@DatabaseName,
			@SchemaName,
			@TableName 
	end 
	close cur 
	deallocate cur
end;
go
