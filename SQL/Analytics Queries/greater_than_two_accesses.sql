DECLARE @videos TABLE (id VARCHAR(100)
					  , video_id INT
					  , access_count INT
					  , lab_number INT
					  )

INSERT INTO @videos
SELECT  v.[webassign_id]
, v.video_order
, COUNT(v.video_order) AS [Video Access]
, vo.Lab_number
  FROM [fall_2013_blended].[dbo].[SY_lec_submission_metadata_161students_78videos] v
  JOIN fall_2013_blended.dbo.SY_video_order vo
  ON vo.video_order = v.video_order
  GROUP BY v.webassign_id, v.video_order, vo.Lab_number

  SELECT COUNT(v.video_id)*100.0/161.0 AS [>2]
  , v.video_id
  , v.lab_number
  FROM @videos v
  WHERE v.access_count > 1
  GROUP BY video_id, v.lab_number
  ORDER BY v.video_id
