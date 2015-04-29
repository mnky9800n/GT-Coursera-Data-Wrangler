use peer_evaluation
go

declare @responses_id table (id int identity(1,1), row int, labnumber int, wid varchar(max), wquestion varchar(max), url varchar(max), itemindex int,
response varchar(max),note varchar(max),gradersownvideo varchar(max),selfeval int)

insert into @responses_id
SELECT [row]
      ,[labNumber]
      ,[wID]
      ,[wQuestion]
      ,[URL]
      ,[itemIndex]
      ,[response]
      ,[note]
      ,[grader's own video]
      ,[self evaluation?]
  FROM [peer_evaluation].[dbo].[responses_MOOC fall 2013]


declare @evens table (id int, row int, labnumber int, wid varchar(max), wquestion varchar(max), url varchar(max), itemindex int,
response varchar(max),note varchar(max),gradersownvideo varchar(max),selfeval int)

declare @odds table (id int, row int, labnumber int, wid varchar(max), wquestion varchar(max), url varchar(max), itemindex int,
response varchar(max),note varchar(max),gradersownvideo varchar(max),selfeval int)

insert into @evens
select *
from @responses_id
where (id % 2) = 0

insert into @odds
select *
from @responses_id
where (id % 2) = 1

select *
from @evens e 
, @odds o 
where o.id=e.id-1
and e.wid=o.wid
and o.labnumber=e.labnumber
and o.itemindex=e.itemindex-1
