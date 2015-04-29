# GT-Coursera-Data-Wrangler
A collection of SQL queries and Python scripts that munge and/or visualize data from MOOCs offered on Coursera from Georgia Tech.


Coursera generally supplies data in two versions:

1. clickstream files (JSON) that contain interaction with the web platform and videos
2. MySQL Dumps of the course database

The first data needs to be prepared for a database (SQL) so that other data (course grades, survey responses, etc.) can be matched to it.

The second data historically has been migrated to a SQL Server 2012 database using SQL Server Migration Assistant. You can learn more about SSMA [here](https://msdn.microsoft.com/en-us/library/hh313129%28v=sql.110%29.aspx).

While these queries and python scripts were useful for the Physics Education Research team at Georgia Tech, they probably will need some altering to be used out of context.
