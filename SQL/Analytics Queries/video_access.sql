
DECLARE @raw_data TABLE (webassign_id varchar(100)
						, video_order int
						, lab_number int
						, id int IDENTITY(1,1) PRIMARY KEY
						, UNIQUE (id))


DECLARE @all TABLE (unique_access float
					, access float
					, id varchar(100) PRIMARY KEY
					, UNIQUE (id)
					)

DECLARE @lect TABLE (unique_access float
					, access float
					, id varchar(100) PRIMARY KEY
					, UNIQUE (id)
					)

DECLARE @lab TABLE (unique_access float
					, access float
					, id varchar(100) PRIMARY KEY
					, UNIQUE (id)
					)

INSERT INTO @raw_data
SELECT webassign_id
, l.video_order
, m.Lab_number
FROM [dbo].[SY_lec_submission_metadata_161students_78videos] l
JOIN SY_published_lecture_metadata_combined m
ON l.video_order = m.video_order

INSERT INTO @all
SELECT COUNT(DISTINCT video_order) as [Unique Accesses]
, COUNT(video_order) AS [Accesses]
, webassign_id
FROM @raw_data
GROUP BY webassign_id

INSERT INTO @lect
SELECT COUNT(DISTINCT video_order) as [Unique Accesses]
, COUNT(video_order) AS [Accesses]
, webassign_id
FROM @raw_data r
WHERE r.lab_number = -1
GROUP BY webassign_id

INSERT INTO @lab
SELECT COUNT(DISTINCT video_order) as [Unique Accesses]
, COUNT(video_order) AS [Accesses]
, webassign_id
FROM @raw_data r
WHERE r.lab_number > -1
GROUP BY webassign_id

SELECT a.id
, ISNULL(a.access, 0) AS [All]
, ISNULL(a.unique_access, 0) AS [All Unique]
, ISNULL(l.access, 0) AS [Lecture]
, ISNULL(l.unique_access, 0) AS [Lecture Unique]
, ISNULL(lab.access, 0) AS [Lab]
, ISNULL(lab.unique_access, 0) [Lab Unique]
FROM @all a
LEFT JOIN @lect l
ON l.id = a.id
LEFT JOIN @lab lab
ON l.id = lab.id
