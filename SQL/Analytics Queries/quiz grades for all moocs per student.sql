/****** Script for SelectTopNRows command from SSMS  ******/

SELECT q.session_user_id
, m.title
, q.raw_score
, qmax.max_score
, q.raw_score*100.0/qmax.max_score [percentage score]
  FROM phys1004.[dbo].[quiz_submission_metadata] q
  JOIN phys1004.dbo.quiz_metadata m
  ON m.id = q.item_id
  JOIN phys1004.dbo.users u
  ON u.session_user_id = q.session_user_id
  JOIN summer_2013_mooc.dbo.quiz_max_score qmax
  ON qmax.quiz_id = q.item_id
  WHERE u.access_group_id = 4
  AND m.quiz_type = 'quiz'
  AND q.grading_error = 0
  AND qmax.max_score NOT IN (0,1)
  

  UNION

  SELECT q.anon_user_id
, m.title
, q.raw_score
, qmax.max_score
, q.raw_score*100.0/qmax.max_score [percentage score]
  FROM summer_2013_mooc.[dbo].[quiz_submission_metadata] q
  JOIN summer_2013_mooc.dbo.quiz_metadata m
  ON m.id = q.item_id
  JOIN summer_2013_mooc.dbo.users u
  ON u.anon_user_id = q.anon_user_id
  JOIN summer_2013_mooc.dbo.quiz_max_score qmax
  ON qmax.quiz_id = q.item_id
  WHERE u.access_group_id = 4
  AND m.quiz_type = 'quiz'
  AND q.grading_error = 0
  AND qmax.max_score NOT IN (0,1)

  UNION

  SELECT q.session_user_id
, m.title
, q.raw_score
, qmax.max_score
, q.raw_score*100.0/qmax.max_score [percentage score]
  FROM phys1005.[dbo].[quiz_submission_metadata] q
  JOIN phys1005.dbo.quiz_metadata m
  ON m.id = q.item_id
  JOIN phys1005.dbo.users u
  ON u.session_user_id = q.session_user_id
  JOIN summer_2013_mooc.dbo.quiz_max_score qmax
  ON qmax.quiz_id = q.item_id
  WHERE u.access_group_id = 4
  AND m.quiz_type = 'quiz'
  AND q.grading_error = 0
  AND qmax.max_score NOT IN (0,1)
