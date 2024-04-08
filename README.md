# Detect duplicates:
- Stored procedure to detect duplicated rows/entries across all databases and to store results within duplicates_log table.
  This procedure can be activated on demand or via SQL job automaticaly on a daily basis or weekly (perfect approach if
  there is no columns with implemented indexing and primary columns)

# Removing duplicates:
- Template script for removing duplicated rows/entries from specified database and table.
  This script should be saved as a SQL template and activate when there is a need
