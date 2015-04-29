
DECLARE @QUIZ TABLE ([Quiz Accesses] INT, [Week Number] INT, [MOOC Semester] INT)

INSERT INTO @QUIZ
SELECT COUNT(item_id) AS [Quiz Submissions]
, DATEPART(iso_week, subdate) AS [Week Number]
, 1 AS [MOOC Semester]
FROM
(
SELECT q.item_id
, CAST(DATEADD(ss, q.submission_time, '1970-01-01') AS DATE) subdate
FROM summer_2013_mooc.dbo.quiz_submission_metadata q
JOIN summer_2013_mooc.dbo.users u
ON u.anon_user_id = q.anon_user_id
WHERE u.access_group_id = 4
AND CAST(DATEADD(ss, q.submission_time, '1970-01-01') AS DATE) BETWEEN '2013-05-20' AND '2013-08-04'
) AS srctab
GROUP BY DATEPART(iso_week, subdate)

UNION

SELECT COUNT(item_id) AS [Quiz Submissions]
, DATEPART(iso_week, subdate) AS [Week Number]
, 2 AS [MOOC Semester]
FROM
(
SELECT q.item_id
, CAST(DATEADD(ss, q.submission_time, '1970-01-01') AS DATE) subdate
FROM phys1004.dbo.quiz_submission_metadata q
JOIN phys1004.dbo.users u
ON u.session_user_id = q.session_user_id
WHERE u.access_group_id = 4
AND CAST(DATEADD(ss, q.submission_time, '1970-01-01') AS DATE) BETWEEN '2014-02-03' AND '2014-04-27'
) AS srctab
GROUP BY DATEPART(iso_week, subdate)

UNION

SELECT COUNT(item_id) AS [Quiz Submissions]
, DATEPART(iso_week, subdate) AS [Week Number]
, 3 AS [MOOC Semester]
FROM
(
SELECT q.item_id
, CAST(DATEADD(ss, q.submission_time, '1970-01-01') AS DATE) subdate
FROM phys1005.dbo.quiz_submission_metadata q
JOIN phys1005.dbo.users u
ON u.session_user_id = q.session_user_id
WHERE u.access_group_id = 4
AND CAST(DATEADD(ss, q.submission_time, '1970-01-01') AS DATE) BETWEEN '2014-09-22' AND '2014-12-13'
) AS srctab
GROUP BY DATEPART(iso_week, subdate)


SELECT q.[Quiz Accesses]
, q.[Week Number] - 20 AS [Week Number]-- (1 -20), (2 -6) (3 -37)
, q.[MOOC Semester]
FROM @QUIZ q
WHERE q.[MOOC Semester] = 1

UNION

SELECT q.[Quiz Accesses]
, q.[Week Number] - 5 -- (1 -20), (2 -6) (3 -37)
, q.[MOOC Semester]
FROM @QUIZ q
WHERE q.[MOOC Semester] = 2

UNION

SELECT q.[Quiz Accesses]
, q.[Week Number] - 37 -- (1 -20), (2 -6) (3 -37)
, q.[MOOC Semester]
FROM @QUIZ q
WHERE q.[MOOC Semester] = 3

ORDER BY [MOOC Semester], [Week Number]
