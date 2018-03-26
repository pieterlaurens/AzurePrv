CREATE PROCEDURE hotness.[01_FormTechnologies] (@tm_workspace_id int) AS

/* Outside dependencies
   - nlams00822, database NLPdev to contain the topics to be turned into technologies 
   - nlams00822, database TopicModeler_devTest to contain the function sql_containsClauseParser that generates contains() clauses
*/

DECLARE @this_component varchar(100)
set @this_component=OBJECT_NAME(@@PROCID)

/* 1. Retrieve the topics in the project; this generates IDs in the technology table */
EXEC hotness.[log_addEntry] @component=@this_component, @message='Insert frontier technologies',@action='START', @status='SUCCESS'

truncate table hotness.technology;
INSERT INTO hotness.technology (label, topic_id, workspace_id,technology_group)
SELECT DISTINCT
	t.name
	, t.id as topic_id
	, t.workspace_id
	, mt.name
FROM
	[$(FrontierTechnologyServer)].[$(FrontierTechnologyDb)].dbo.topic t JOIN
	[$(FrontierTechnologyServer)].[$(FrontierTechnologyDb)].dbo.topic_metatopic mt ON mt.id=t.metatopic_id
where
	workspace_id=1

EXEC hotness.[log_addEntry] @component=@this_component, @message='Insert frontier technologies',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

/* 2. Retrieve the inpadoc_family_ids the mention any of the words in the technologies */
EXEC hotness.[log_addEntry] @component=@this_component, @message='Insert families belonging to frontier technologies',@action='START', @status='SUCCESS'

truncate table hotness.technology_family;
;with tr as (
	select
		t.technology_id
		, t.topic_id
		, et.id as es_task_id
		, rank() over (partition by t.topic_id order by et.id desc) as task_set_rank
	from
		hotness.technology t JOIN
		[$(FrontierTechnologyServer)].[$(FrontierTechnologyDb)].dbo.es_taskSet et ON et.topic_id=t.topic_id JOIN
		[$(FrontierTechnologyServer)].[$(FrontierTechnologyDb)].dbo.es_source_descriptionSet s ON s.id=et.source_id JOIN 
		[$(FrontierTechnologyServer)].[$(FrontierTechnologyDb)].[dbo].[es_runSet] r ON r.id = et.run_id -- Added by Freddy to not include non-scoring runs.
	where
		r.comment = 'storescores'	 --bug fix 2016/9/2. 
		and
		s.es_index='patstat'
) insert into hotness.technology_family (technology_id,inpadoc_family_id,number_of_citations,y3_citations,priority_year)
select distinct
	tr.technology_id
	, cast(e.[key] as int)
	, fm.family_citation
	, fm.family_y3_citation
	, fm.priority_year
from
	tr JOIN
	[$(FrontierTechnologyServer)].[$(FrontierTechnologyDb)].dbo.es_score_patstatSet e ON e.es_task_id=tr.es_task_id JOIN
	[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=cast(e.[key] as int)
where
	tr.task_set_rank=1
	and
	fm.priority_year >= (year(getdate()) - 20) -- added 19/12/2016; new definition restricts to patents from last 20 years.

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Insert families belonging to frontier technologies',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

/* 3. Retrieve the topics for investor alignment */
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Insert investor alignment themes',@action='START', @status='SUCCESS'

truncate table investor_preference;
INSERT INTO investor_preference (area_label, topic_id, workspace_id, preference_group)
SELECT DISTINCT
	t.name
	, t.id as topic_id
	, t.workspace_id
	, mt.name
FROM
	[$(InvestorThemeServer)].[$(InvestorThemeDb)].dbo.topic t JOIN
	[$(InvestorThemeServer)].[$(InvestorThemeDb)].dbo.topic_metatopic mt ON mt.id=t.metatopic_id
where
	workspace_id=@tm_workspace_id
	and
	t.status_id=6
	and
	t.metatopic_id=11 -- Information technology

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Insert investor alignment themes',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

/* 4. Retrieve the inpadoc_family_ids for investor alignment */
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Insert families belonging to investor themes',@action='START', @status='SUCCESS'

truncate table investor_preference_family;
;with tr as (
	select
		t.preference_id
		, t.topic_id
		, et.id as es_task_id
		, rank() over (partition by t.topic_id order by et.id desc) as task_set_rank
	from
		investor_preference t JOIN
		[$(InvestorThemeServer)].[$(InvestorThemeDb)].dbo.es_taskSet et ON et.topic_id=t.topic_id JOIN
		[$(InvestorThemeServer)].[$(InvestorThemeDb)].dbo.es_source_descriptionSet s ON s.id=et.source_id JOIN 
		[$(InvestorThemeServer)].[$(InvestorThemeDb)].[dbo].[es_runSet] r ON r.id = et.run_id -- Added by Freddy to not include non-scoring runs.
	where
		r.comment = 'storescores'	 --bug fix 2016/9/2. 
		and
		s.es_index='patstat'
) insert into investor_preference_family(preference_id,inpadoc_family_id,number_of_citations,priority_year)
select distinct
	tr.preference_id
	, cast(e.[key] as int)
	, fm.family_citation
	, fm.priority_year
from
	tr JOIN
	[$(InvestorThemeServer)].[$(InvestorThemeDb)].dbo.es_score_patstatSet e ON e.es_task_id=tr.es_task_id JOIN
	[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=cast(e.[key] as int)
where
	tr.task_set_rank=1
	and
	fm.priority_year >= (year(getdate()) - 20) -- added 19/12/2016; new definition restricts to patents from last 20 years.

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Insert families belonging to investor themes',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

RETURN 0
