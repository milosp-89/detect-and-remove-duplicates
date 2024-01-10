---- template script for removing duplicates ----

declare @db_name varchar(50) = ' xxx' -- db name
declare @tbl_name varchar(50) = 'xxx' -- tbl name

select 'use' + @db_name + ';
go

WITH cte AS (
	SELECT
		submission_id,
		ROW_NUMBER() OVER (
			PARTITION BY 
				submission_id
			ORDER BY 
				submission_id
		) as row_num
		FROM ' + @tbl_name + '
)
DELETE FROM cte
WHERE row_num > 1;
go'
