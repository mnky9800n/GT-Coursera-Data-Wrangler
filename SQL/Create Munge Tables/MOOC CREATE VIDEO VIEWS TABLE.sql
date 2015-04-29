/****** Script for Create table for video analytics ******/
USE summer_2013_mooc
GO

/****** Object:  Table [dbo].[Video Views]    Script Date: 2/27/2015 10:21:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/****** Script for Dropping [Video Views] if it exists  ******/
IF OBJECT_ID('[dbo].[Video Views]', 'U') IS NOT NULL
	DROP TABLE [dbo].[Video Views]
GO


CREATE TABLE [dbo].[Video Views](
	row_id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Video Order] int NULL,
	[Title] varchar(max) NULL,
	[Video Length (s)] float NULL,
	[Lab Number] int NULL,
	[session_user_id] varchar(max) NULL,
	[Submission Date] date NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


/****** Script for Create Table Variable for video order ******/
declare @vidorder table (original_item_id int, video_order int)

insert into @vidorder
SELECT distinct original_item_id
, video_order
  FROM [fall_2013_blended].[dbo].[SY_lec_submission_metadata_161students_78videos]

/****** Script for shape Data for Video Views table and INSERT  ******/
INSERT INTO [Video Views]
SELECT vidorder.video_order
, meta.title_mooc
, meta.video_length_SY
,meta.Lab_number
, data.anon_user_id
, cast(dateadd(ss, data.submission_time, '1970-01-01') as date) [submission date]
  FROM [dbo].[lecture_submission_metadata] data
  join [fall_2013_blended].[dbo].[SY_published_lecture_metadata_combined] meta
  on meta.id_blended = data.item_id
  join [dbo].[users] u
  on u.anon_user_id = data.anon_user_id
  join @vidorder vidorder
  on vidorder.original_item_id = meta.id_blended
  where u.access_group_id = 4


GO

/****** Script for checking Video Views Table ******/
SELECT COUNT(DISTINCT [Video Order])
FROM [Video Views]
