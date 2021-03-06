/****** Script for SelectTopNRows command from SSMS  ******/

CREATE TABLE [Video Classification] ( id int IDENTITY(1,1) PRIMARY KEY
									, video_order int
									, title varchar(100)
									, video_length float
									, lab_number int
									, number_of_clicker_Qs int
									, fraction_100_percent float
									, n_accesses int
									, seconds_watched int
									, cross_correlation float
									, UNIQUE (id))
SELECT TOP 1000 [video_order]
      ,[id_blended]
      ,[id_mooc]
      ,[title_mooc]
      ,[video_length_SY]
      ,[Lab_number]
      ,[number_of_clicker_Qs]
      ,[quiz_id_blended]
      ,[quiz_id_mooc]
      ,[final]
      ,[deleted]
  FROM [fall_2013_blended].[dbo].[SY_published_lecture_metadata_combined]