declare @data table (id varchar(max), title varchar(max))

insert into @data
select webassign_id
, title
from
(
SELECT count(distinct title) cnt
, webassign_id
, title
  FROM [fall_2013_blended].[dbo].[SY_lec_submission_metadata_161students_78videos]
  group by webassign_id, title
  ) as srctab

declare @jtab table (cnt int, id varchar(max))

insert into @jtab
select count(id) cnt
, id
from @data
group by id
order by cnt

select *
from
(
SELECT [webassign_id]
		,video_order
		, j.cnt
  FROM [fall_2013_blended].[dbo].[SY_lec_submission_metadata_161students_78videos] v
  join @jtab j 
  on j.id = v.webassign_id
  group by webassign_id, video_order, j.cnt
  ) as sourcetable
  pivot
  (
  count(video_order)
  FOR video_order in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52],[53],[54],[55],[56],[57],[58],[59],[60],[61],[62],[63],[64],[65],[66],[67],[68],[69],[70],[71],[72],[73],[74],[75],[76],[77],[78])
  ) as pivottable
