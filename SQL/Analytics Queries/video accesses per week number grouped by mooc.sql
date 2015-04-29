
DECLARE @DATA TABLE ([Video Accesses] INT
					, [Week Number] INT
					, [MOOC Semester] INT
					)
 
 INSERT INTO @DATA
SELECT COUNT(DATEPART(iso_week, v.[Submission Date])) AS [Video Accesses]
, DATEPART(iso_week, v.[Submission Date]) AS [Week Number]
, 1 AS [MOOC Semester]
FROM summer_2013_mooc.dbo.[Video Views] AS v
WHERE v.[Submission Date] BETWEEN '2013-05-20' AND '2013-08-04'
GROUP BY [Submission Date]



UNION

SELECT SUM(CNT)
, [Week Number]
, [MOOC Semester]
FROM 
(
SELECT COUNT(DATEPART(iso_week, v.[Submission Date])) AS CNT
, DATEPART(iso_week, v.[Submission Date]) AS [Week Number]
, 2 AS [MOOC Semester]
FROM phys1004.dbo.[Video Views] AS v
WHERE v.[Submission Date] BETWEEN '2014-02-03' AND '2014-04-27'
GROUP BY [Submission Date]
) AS srctab
GROUP BY [Week Number], [MOOC Semester]

UNION

SELECT SUM(CNT)
, [Week Number]
, [MOOC Semester]
FROM 
(
SELECT COUNT(DATEPART(iso_week, v.[Submission Date])) AS CNT
, DATEPART(iso_week, v.[Submission Date]) AS [Week Number]
, 3 AS [MOOC Semester]
FROM phys1005.dbo.[Video Views] AS v
WHERE v.[Submission Date] BETWEEN '2014-09-21' AND '2014-12-13'
GROUP BY [Submission Date]
) AS srctab
GROUP BY [Week Number], [MOOC Semester]

SELECT SUM([Video Accesses]) AS [Video Accesses]
, d.[Week Number] - 20 AS [week number]
, d.[MOOC Semester]
FROM @DATA d
WHERE d.[MOOC Semester] = 1
GROUP BY d.[Week Number], d.[MOOC Semester]

UNION

SELECT SUM([Video Accesses]) AS [Video Accesses]
, d.[Week Number] - 5 AS [week number]
, d.[MOOC Semester]
FROM @DATA d
WHERE d.[MOOC Semester] = 2
GROUP BY d.[Week Number], d.[MOOC Semester]

UNION

SELECT SUM([Video Accesses]) AS [Video Accesses]
, d.[Week Number] - 37 AS [week number]
, d.[MOOC Semester]
FROM @DATA d
WHERE d.[MOOC Semester] = 3
GROUP BY d.[Week Number], d.[MOOC Semester]

ORDER BY [MOOC Semester], [week number]