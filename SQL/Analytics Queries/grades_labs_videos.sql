

declare @vidz table (vidviews float
					, id varchar(100) PRIMARY KEY
					, mooc_id int
					, UNIQUE (id))

/****** lookup table for everyone  ******/
declare @everyone table (id varchar(100) PRIMARY KEY
						, mooc_id int
						, UNIQUE (id))

insert into @everyone
SELECT [anon_user_id]
, 1 as mooc_id
  FROM [summer_2013_mooc].[dbo].[users]

  union

  SELECT session_user_id
, 4
  FROM phys1004.[dbo].[users]

  union

  SELECT session_user_id
, 5
  FROM phys1005.[dbo].[users]



/****** video counts ******/
insert into @vidz
select CAST(count(distinct v.[Video Order]) AS FLOAT)/69.0 
, v.session_user_id
, 4
from phys1004.dbo.[Video Views] v
group by session_user_id

union

select cast(count(distinct v.[Video Order]) as float)/69.0
, session_user_id
, 5
from phys1005.dbo.[Video Views] v
group by session_user_id

union

select cast(count(distinct v.[Video Order]) as float)/70.0
, v.session_user_id
, 1
from summer_2013_mooc.dbo.[Video Views] v
group by v.session_user_id




/****** grades ******/

declare @grades table (id varchar(100) PRIMARY KEY
						, grade float
						, UNIQUE(id))

insert into @grades
SELECT [anon_user_id]
      ,[normal_grade]
  FROM [summer_2013_mooc].[dbo].[course_grades]

  union

  SELECT session_user_id
      ,[normal_grade]
  FROM phys1004.[dbo].[course_grades]

  union

  SELECT session_user_id
      ,[normal_grade]
  FROM phys1005.[dbo].[course_grades]
  


/******* LABS *******/

declare @labs table (cnt int
					, id varchar(100) PRIMARY KEY
					, mooc_id int
					, UNIQUE (id))

insert into @labs
select count(author_id) cnt
, author_id
, mooc_id
from
(
SELECT [author_id]
      ,[assessment_id]
      ,[submit_time]
	  , 1 as mooc_id
  FROM [phys1005].[dbo].[hg_assessment_submission_metadata]

  union

  SELECT [author_id]
      ,[assessment_id]
      ,[submit_time]
	  , 4 as mooc_id
  FROM phys1004.[dbo].[hg_assessment_submission_metadata]

  union

  SELECT anon_user_id
      ,[assessment_id]
      ,[submit_time]
	  , 5 as mooc_id
  FROM summer_2013_mooc.[dbo].[hg_assessment_submission_metadata]
  ) as tb
  group by author_id, mooc_id

/****** fraction of quizzes submitted  ******/
declare @quiz table (fraction float
					, id varchar(100) PRIMARY KEY
					, mooc_id int
					, UNIQUE (id))

insert into @quiz
SELECT count(distinct q.item_id)/25.0 frac
    ,[anon_user_id]
	, 1
FROM [summer_2013_mooc].[dbo].[quiz_submission_metadata] q
where q.item_id in (27, 51, 55, 91, 101, 103, 161, 193, 235, 321, 371, 373, 375, 403, 405, 445, 447, 489, 523, 525, 77, 541, 543, 545, 561)
GROUP BY anon_user_id

UNION

SELECT COUNT(distinct q.item_id)/25.0 frac
, session_user_id
, 4
FROM phys1004.[dbo].[quiz_submission_metadata] q
where q.item_id in (27, 51, 55, 91, 101, 103, 161, 193, 235, 321, 371, 373, 375, 403, 405, 445, 447, 489, 523, 525, 77, 541, 543, 545, 561)
GROUP BY session_user_id

UNION

SELECT COUNT(distinct q.item_id)/25.0 frac
, session_user_id
, 5
FROM phys1005.[dbo].[quiz_submission_metadata] q
where q.item_id in (27, 51, 55, 91, 101, 103, 161, 193, 235, 321, 371, 373, 375, 403, 405, 445, 447, 489, 523, 525, 77, 541, 543, 545, 561)
GROUP BY session_user_id

/****** Peer Evaluation Participation  ******/



declare @completed table (cnt int
							, id varchar(100) PRIMARY KEY
							, mooc_id int
							, UNIQUE (id))

declare @ongoing table (cnt int
							, id varchar(100) PRIMARY KEY
							, mooc_id int
							, UNIQUE (id))

declare @peer_eval table (id varchar(100) PRIMARY KEY
							, mooc_id int
							, completed_cnt int
							, ongoing_cnt int
							, UNIQUE (id))

/****** Completed Peer Evaluations ******/
INSERT INTO @completed

SELECT COUNT([anon_user_id]) cnt
	,[anon_user_id]
	, 1
FROM [summer_2013_mooc].[dbo].[hg_assessment_peer_grading_set_metadata]
where status = 'completed'
group by [anon_user_id]

UNION

SELECT COUNT(session_user_id) cnt
	,session_user_id
	, 4
FROM phys1004.[dbo].[hg_assessment_peer_grading_set_metadata]
where status = 'completed'
group by session_user_id

UNION

SELECT COUNT(session_user_id) cnt
	,session_user_id
	, 5
FROM phys1005.[dbo].[hg_assessment_peer_grading_set_metadata]
where status = 'completed'
group by session_user_id

/****** Ongoing Peer Evaluations ******/
INSERT INTO @ongoing

SELECT COUNT([anon_user_id]) cnt
	,[anon_user_id]
	, 1
FROM [summer_2013_mooc].[dbo].[hg_assessment_peer_grading_set_metadata]
where status = 'ongoing'
group by [anon_user_id]

UNION

SELECT COUNT(session_user_id) cnt
	,session_user_id
	, 4
FROM phys1004.[dbo].[hg_assessment_peer_grading_set_metadata]
where status = 'ongoing'
group by session_user_id

UNION

SELECT COUNT(session_user_id) cnt
	,session_user_id
	, 5
FROM phys1005.[dbo].[hg_assessment_peer_grading_set_metadata]
where status = 'ongoing'
group by session_user_id


/****** peer evaluation ******/
INSERT INTO @peer_eval
select c.id
, c.mooc_id
, ISNULL(c.cnt, 0) completed
, ISNULL(o.cnt, 0) ongoing
from @completed c
LEFT JOIN @ongoing o
ON c.id = o.id


/****** data table ******/
declare @data_table table (id varchar(100) PRIMARY KEY
							, [video access] float
							, grade float
							, [lab submission count] int
							, [quiz submission fraction] float
							, [peer evaluation completed] int
							, [peer evaluation ongoing] int
							, UNIQUE (id))

INSERT INTO @data_table
SELECT e.id
, ISNULL(v.vidviews,0) as [video access fraction]
, ISNULL(g.grade, 0) as [grade]
, ISNULL(l.cnt, 0) as [lab submission count]
, ISNULL(q.fraction, 0) as [quiz submission fraction]
, ISNULL(p.completed_cnt, 0) as [peer evaluation completed]
, ISNULL(p.ongoing_cnt, 0) as [peer evaluation ongoing]
FROM @everyone AS e
LEFT JOIN @vidz AS v
ON v.id = e.id
LEFT JOIN @grades as g
ON v.id = g.id
LEFT JOIN @labs as l
ON v.id = l.id
LEFT JOIN @quiz as q
ON v.id = q.id
LEFT JOIN @peer_eval p
ON v.id = p.id
where e.id in (
	select u.anon_user_id
	from summer_2013_mooc.dbo.users u
	where u.access_group_id = 4

	UNION

	select u.session_user_id
	from phys1004.dbo.users u
	where u.access_group_id = 4 

	UNION

	select u.session_user_id
	from phys1005.dbo.users u
	where u.access_group_id = 4 
	)


select *
from @data_table d