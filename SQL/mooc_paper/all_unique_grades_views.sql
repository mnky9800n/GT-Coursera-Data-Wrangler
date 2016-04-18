
DECLARE @video_views TABLE (id varchar(100), [All] float, [Unique] float, Lecture float, [Lecture Unique] float, Lab float, [Lab Unique] float, mooc_id varchar(8))

INSERT INTO @video_views
SELECT v.session_user_id
, COUNT(v.[Video Order]) as [All]
, COUNT(DISTINCT v.[Video Order]) as [Unique]
, COUNT(CASE WHEN v.[Lab Number]=-1 THEN 1 ELSE NULL END) as [Lecture]
, COUNT(DISTINCT CASE WHEN v.[Lab Number]!=-1 THEN v.[Video Order] ELSE NULL END) as [Lecture Unique]
, COUNT(CASE WHEN v.[Lab Number]!=-1 THEN 1 ELSE NULL END) as [Lab]
, COUNT(DISTINCT CASE WHEN v.[Lab Number]!=-1 THEN v.[Video Order] ELSE NULL END) as [Lab Unique]
, 'phys1004' as mooc_id
FROM phys1004.dbo.[Video Views] AS v
GROUP BY v.session_user_id

UNION

SELECT v.session_user_id
, COUNT(v.[Video Order]) as [All]
, COUNT(DISTINCT v.[Video Order]) as [Unique]
, COUNT(CASE WHEN v.[Lab Number]=-1 THEN 1 ELSE NULL END) as [Lecture]
, COUNT(DISTINCT CASE WHEN v.[Lab Number]!=-1 THEN v.[Video Order] ELSE NULL END) as [Lecture Unique]
, COUNT(CASE WHEN v.[Lab Number]!=-1 THEN 1 ELSE NULL END) as [Lab]
, COUNT(DISTINCT CASE WHEN v.[Lab Number]!=-1 THEN v.[Video Order] ELSE NULL END) as [Lab Unique]
, 'phys1005' as mooc_id
FROM phys1005.dbo.[Video Views] AS v
GROUP BY v.session_user_id

UNION

SELECT v.session_user_id
, COUNT(v.[Video Order]) as [All]
, COUNT(DISTINCT v.[Video Order]) as [Unique]
, COUNT(CASE WHEN v.[Lab Number]=-1 THEN 1 ELSE NULL END) as [Lecture]
, COUNT(DISTINCT CASE WHEN v.[Lab Number]!=-1 THEN v.[Video Order] ELSE NULL END) as [Lecture Unique]
, COUNT(CASE WHEN v.[Lab Number]!=-1 THEN 1 ELSE NULL END) as [Lab]
, COUNT(DISTINCT CASE WHEN v.[Lab Number]!=-1 THEN v.[Video Order] ELSE NULL END) as [Lab Unique]
, 'phys1001' as mooc_id
FROM summer_2013_mooc.dbo.[Video Views] AS v
GROUP BY v.session_user_id

/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @quiz TABLE (id varchar(100), quiz_grade float)
INSERT INTO @quiz
SELECT [session_user_id]
      --,[item_id]
      , SUM([raw_score])/404.0
      --,[submission_number]
  FROM [MOOC_MINING].[dbo].[Quiz Submissions] AS q
  WHERE q.item_id IN (SELECT id FROM [MOOC_MINING].[dbo].[Quiz Max Scores])
  AND submission_number = 1
  GROUP BY session_user_id

/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @users TABLE (id varchar(100), mooc_semester int, final_grade float)
INSERT INTO @users
SELECT  u.session_user_id
, u.MOOC_semester
, cg.final_score/121
  FROM [MOOC_MINING].[dbo].[users] AS u
  LEFT JOIN MOOC_MINING.dbo.Course_Grades AS cg
  ON u.session_user_id = cg.session_user_id
  ORDER BY cg.final_score DESC


SELECT *
FROM @users AS u
LEFT JOIN @video_views AS v
ON u.id = v.id
LEFT JOIN @quiz AS q
ON q.id = u.id
