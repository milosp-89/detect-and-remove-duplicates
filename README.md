# Structure consist of two phases:

# Detect duplicates:
- Stored procedure to detect duplicated rows/entries across all databases and to store results within duplicates_log table.
  This procedure can be activated on demand or via SQL job automaticaly on a daily basis or weekly (perfect approach if
  there is no columns with implemented indexing or primary key columns). Main purpose of this procedure is to track down
  status of duplicates within all databases and tables - initially created as a workaround to test resend of data from
  other server (web based application)

# Removing duplicates:
- Template script for removing duplicated rows/entries from specified database and table.
  This script should be saved as a SQL template and activate when there is a need to remove
  any duplicates
