/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @Quiz_submitters TABLE ( id VARCHAR(100) PRIMARY KEY
							   , [Quiz_Submission_Fraction] FLOAT
							   , [Grade] FLOAT
							   , [Lab_Submission_Fraction] FLOAT
							   , UNIQUE(id))

DECLARE @video_views TABLE ( id INT IDENTITY(1,1) PRIMARY KEY
							 , video_order INT
							 , title VARCHAR(MAX)
							 , video_length FLOAT
							 , lab_index INT
							 , session_user_id VARCHAR(100)
							 , submission_date DATE
							 , UNIQUE(id))

INSERT INTO @video_views
SELECT [Video Order]
      ,[Title]
      ,[Video Length (s)]
      ,[Lab Number]
      ,[session_user_id]
      ,[Submission Date]
FROM summer_2013_mooc.dbo.[Video Views] v

UNION

SELECT [Video Order]
      ,[Title]
      ,[Video Length (s)]
      ,[Lab Number]
      ,[session_user_id]
      ,[Submission Date]
FROM phys1004.dbo.[Video Views] v

UNION

SELECT [Video Order]
      ,[Title]
      ,[Video Length (s)]
      ,[Lab Number]
      ,[session_user_id]
      ,[Submission Date]
FROM phys1005.dbo.[Video Views] v

INSERT INTO @Quiz_submitters

/*** MOOC 1 ***/
SELECT u.anon_user_id
, COUNT(DISTINCT q.item_id)/25.0 AS [quiz submission count]
, g.normal_grade
, COUNT(DISTINCT l.assessment_id) AS [lab submission count]
  FROM summer_2013_mooc.[dbo].[quiz_submission_metadata] q
  JOIN summer_2013_mooc.dbo.users u
  ON u.anon_user_id = q.anon_user_id
  JOIN summer_2013_mooc.dbo.quiz_metadata m
  ON m.id = q.item_id
  JOIN summer_2013_mooc.dbo.course_grades g
  ON u.anon_user_id = g.anon_user_id
  LEFT JOIN summer_2013_mooc.dbo.hg_assessment_submission_metadata l
  ON u.anon_user_id = l.anon_user_id
  WHERE u.access_group_id = 4
  AND q.item_id IN (27, 51, 55, 91, 101, 103, 161, 193, 235, 321, 371, 373, 375, 403, 405, 445, 447, 489, 523, 525, 77, 541, 543, 545, 561)
  GROUP BY u.anon_user_id
  , g.normal_grade

  UNION

/*** MOOC 2 ***/
SELECT u.session_user_id
, COUNT(DISTINCT q.item_id)/25.0 AS [quiz submission count]
, g.normal_grade
, COUNT(DISTINCT l.assessment_id) AS [lab submission count]
  FROM [phys1004].[dbo].[quiz_submission_metadata] q
  JOIN phys1004.dbo.users u
  ON u.session_user_id = q.session_user_id
  JOIN phys1004.dbo.quiz_metadata m
  ON m.id = q.item_id
  JOIN phys1004.dbo.course_grades g
  ON u.session_user_id = g.session_user_id
  LEFT JOIN phys1004.dbo.hg_assessment_submission_metadata l
  ON u.session_user_id = l.author_id
  WHERE u.access_group_id = 4
  AND q.item_id IN (27, 51, 55, 91, 101, 103, 161, 193, 235, 321, 371, 373, 375, 403, 405, 445, 447, 489, 523, 525, 77, 541, 543, 545, 561)
  GROUP BY u.session_user_id
  , g.normal_grade

  UNION

/*** MOOC 3 ***/
SELECT u.session_user_id
, COUNT(DISTINCT q.item_id)/25.0 AS [quiz submission count]
, g.normal_grade
, COUNT(DISTINCT l.assessment_id) AS [lab submission count]
  FROM phys1005.[dbo].[quiz_submission_metadata] q
  JOIN phys1005.dbo.users u
  ON u.session_user_id = q.session_user_id
  JOIN phys1005.dbo.quiz_metadata m
  ON m.id = q.item_id
  JOIN phys1005.dbo.course_grades g
  ON u.session_user_id = g.session_user_id
  LEFT JOIN phys1005.dbo.hg_assessment_submission_metadata l
  ON u.session_user_id = l.author_id
  WHERE u.access_group_id = 4
  AND q.item_id IN (27, 51, 55, 91, 101, 103, 161, 193, 235, 321, 371, 373, 375, 403, 405, 445, 447, 489, 523, 525, 77, 541, 543, 545, 561)
  GROUP BY u.session_user_id
  , g.normal_grade

  DECLARE @quiz_fraction FLOAT
SET @quiz_fraction = 0.8

DECLARE @student_count FLOAT

  /*** Counts per Video ***/
 SET @student_count = ( 
  SELECT COUNT(DISTINCT q.id)
    FROM @Quiz_submitters AS q
  JOIN @video_views AS v
  ON q.id = v.session_user_id
  WHERE q.Lab_Submission_Fraction = 0
  AND q.Quiz_Submission_Fraction > @quiz_fraction
  )

  SELECT COUNT(DISTINCT v.session_user_id)/@student_count AS [video_fraction]
  ,v.video_order AS [video_fract] 
  FROM @Quiz_submitters AS q
  JOIN @video_views AS v
  ON q.id = v.session_user_id
  WHERE q.Lab_Submission_Fraction = 0
  AND q.Quiz_Submission_Fraction > @quiz_fraction
  GROUP BY v.video_order
  /*
  SELECT COUNT(DISTINCT v.video_order)
  , v.video_order
  FROM @Quiz_submitters q
  JOIN @video_views v
  ON q.id = v.session_user_id
  WHERE v.lab_index = -1
  GROUP BY v.video_order
  */
  /*** Counts per student
  DECLARE @lecture TABLE (id VARCHAR(100)
						 , lecture_unique_count FLOAT
						 , lecture_count FLOAT
						 )

  DECLARE @lab TABLE (id VARCHAR(100)
						 , lab_unique_count FLOAT
						 , lab_count FLOAT
						 )

DECLARE @quiz_fraction FLOAT
SET @quiz_fraction = 0.8


INSERT INTO @lecture
  SELECT v1.session_user_id
  , COUNT(DISTINCT v1.video_order) AS [lecture video unique count]
  , COUNT(v1.video_order) AS [lecture video count]
  FROM @Quiz_submitters q
  JOIN @video_views AS v1
  ON q.id = v1.session_user_id
  WHERE q.Quiz_Submission_Fraction > @quiz_fraction
  AND q.Lab_Submission_Fraction < 1
  AND v1.lab_index = -1
  GROUP BY v1.session_user_id

  INSERT INTO @lab
  SELECT v1.session_user_id
  , COUNT(DISTINCT v1.video_order) AS [lecture video unique count]
  , COUNT(v1.video_order) AS [lecture video count]
  FROM @Quiz_submitters q
  JOIN @video_views AS v1
  ON q.id = v1.session_user_id
  WHERE q.Quiz_Submission_Fraction > @quiz_fraction
  AND q.Lab_Submission_Fraction < 1
  AND v1.lab_index > -1
  GROUP BY v1.session_user_id

  SELECT le.id
  , le.lecture_unique_count
  , le.lecture_unique_count/56.0
  , la.lab_unique_count
  , la.lab_unique_count/14.0
  FROM @lecture AS le
  LEFT JOIN @lab AS la
  ON le.id = la.id

  ***/
