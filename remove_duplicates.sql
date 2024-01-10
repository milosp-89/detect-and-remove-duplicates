---- template script for removing duplicates ----

declare @db_name varchar(50) = ' xxx' -- db name
declare @tbl_name varchar(50) = 'xxx' -- tbl name

select 'use' + @db_name + ';
go

with cte as (
	select
		id_col,
		row_number() over (
			partition by 
				id_col
			order by 
				id_col
		) as row_num
		from ' + @tbl_name + '
)
delete from cte
where row_num > 1;
go'
