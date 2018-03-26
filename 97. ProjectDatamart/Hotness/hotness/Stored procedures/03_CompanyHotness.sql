CREATE PROCEDURE [dbo].[03_CompanyHotness]
AS

DECLARE @this_component varchar(100)
set @this_component=OBJECT_NAME(@@PROCID)

declare @py SMALLINT;
SET @py = CAST('$(publishYear)' AS SMALLINT)

/* 1. Load the overall part */
EXEC hotness.[log_addEntry] @component=@this_component, @message='Load overall scores',@action='START', @status='SUCCESS'
;with c as (
	select
		c.bvd_id
		, cim.number_of_families as total_volume
		, cim.number_of_citations as overall_citations
		, cim.citations_per_age_year as average_citations_over_age
		, cim.company_hotness as avg_y3_citations
		/*, count(distinct cf.inpadoc_family_id) as total_volume
		, sum(fm.family_citation) as overall_citations
		, avg( cast(fm.family_citation as real) / cast(year(GETDATE())-fm.priority_year as real) ) as average_citations_over_age
		, AVG( cast(fm.family_y3_citation as real) ) as avg_y3_citations*/
	from
		company c JOIN
		[$(pwc_v2016a_005)].[aggregate].company_ip_metric cim ON cim.bvd_id=c.bvd_id /*LEFT OUTER JOIN
		[$(pwc_v2016a_003)].[aggregate].company_family cf ON cf.bvd_id=c.bvd_id LEFT OUTER JOIN
		[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=cf.inpadoc_family_id
	where
		fm.priority_year >= (year(GETDATE()) - 20)
		and
		fm.priority_year < year(GETDATE())
	group by
		c.bvd_id*/
) UPDATE company
	SET total_volume=c.total_volume
	, competitive_incoming_citations=c.overall_citations
	, hotness_avg_citations_over_age=c.average_citations_over_age
	, hotness_avg_y3_citations=c.avg_y3_citations
FROM
	hotness.company b JOIN
	c ON c.bvd_id=b.bvd_id
EXEC hotness.[log_addEntry] @component=@this_component, @message='Load overall scores',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

/* 2. Load the on-topic part */
EXEC hotness.[log_addEntry] @component=@this_component, @message='Load on-topic scores',@action='START', @status='SUCCESS'
;with c as (
	select
		c.bvd_id
		, count(distinct tf.inpadoc_family_id) as on_topic_volume
		, count(tf.is_top_in_preference) as on_topic_volume_in_top_10pct
	from
		hotness.company c JOIN
		[$(pwc_v2016a_005)].[aggregate].company_family cf ON cf.bvd_id=c.bvd_id LEFT OUTER JOIN
		[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=cf.inpadoc_family_id LEFT OUTER JOIN
		hotness.investor_preference_family tf ON tf.inpadoc_family_id=cf.inpadoc_family_id
	where
		fm.priority_year >= (@py - 20)
		and
		fm.priority_year <= @py
	group by
		c.bvd_id
) UPDATE hotness.company
	SET on_topic_volume=c.on_topic_volume
	, on_topic_volume_in_top_10pct=c.on_topic_volume_in_top_10pct
	, on_topic_fraction = case when b.total_volume>0 then cast(c.on_topic_volume as real) / cast(b.total_volume as real) else null end
	, on_topic_fraction_in_top_10pct = case when c.on_topic_volume>0 then cast(c.on_topic_volume_in_top_10pct as real) / cast(c.on_topic_volume as real) else null end
FROM
	hotness.company b JOIN
	c ON c.bvd_id=b.bvd_id
EXEC hotness.[log_addEntry] @component=@this_component, @message='Load on-topic scores',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

/* 3. Load the frontier part */
EXEC hotness.[log_addEntry] @component=@this_component, @message='Load frontier scores',@action='START', @status='SUCCESS'
;with c as (
	select
		c.bvd_id
		, count(distinct tf.inpadoc_family_id) as on_topic_volume
		, count(tf.is_top_in_technology) as on_topic_volume_in_top_10pct
	from
		hotness.company c JOIN
		[$(pwc_v2016a_005)].[aggregate].company_family cf ON cf.bvd_id=c.bvd_id LEFT OUTER JOIN
		[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=cf.inpadoc_family_id LEFT OUTER JOIN
		hotness.technology_family tf ON tf.inpadoc_family_id=cf.inpadoc_family_id
	where
		fm.priority_year >= (@py - 20)
		and
		fm.priority_year <= @py
	group by
		c.bvd_id
) UPDATE hotness.company
	SET frontier_volume=c.on_topic_volume
	, frontier_volume_in_top_10pct=c.on_topic_volume_in_top_10pct
	, frontier_fraction = case when b.total_volume>0 then cast(c.on_topic_volume as real) / cast(b.total_volume as real) else null end
	, frontier_fraction_in_top_10pct = case when c.on_topic_volume>0 then cast(c.on_topic_volume_in_top_10pct as real) / cast(c.on_topic_volume as real) else null end
FROM
	company b JOIN
	c ON c.bvd_id=b.bvd_id
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Load frontier scores',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

/* 4. Load the outgoing citations */
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Load outgoing citations',@action='START', @status='SUCCESS'
;with c as (
	select
		c.bvd_id
		, count(distinct fc.cited_family_id) as outgoing_citations
	from
		company c JOIN
		[$(pwc_v2016a_005)].[aggregate].company_family cf ON cf.bvd_id=c.bvd_id LEFT OUTER JOIN
		[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=cf.inpadoc_family_id LEFT OUTER JOIN
		[$(pw_v2016a_001)].patstat.family_citation fc ON fc.citing_family_id=cf.inpadoc_family_id
	where
		fm.priority_year >= (@py - 20)
		and
		fm.priority_year < @py
	group by
		c.bvd_id
) UPDATE company
	SET competitive_outgoing_citations=c.outgoing_citations
	, competitive_citation_inout_fraction = case when isnull(c.outgoing_citations,0) > 0 THEN cast(b.competitive_incoming_citations as real) / cast(c.outgoing_citations as real)
		else NULL END
FROM
	company b JOIN
	c ON c.bvd_id=b.bvd_id
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Load outgoing citations',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

declare @n REAL = (select CAST(count(*) AS REAL) from company)
declare @msg nvarchar(500) set @msg = concat('Compute rank scores within ',cast(@n as varchar(10)),' companies')
EXEC [dbo].[log_addEntry] @component=@this_component, @message=@msg,@action='START', @status='SUCCESS'
UPDATE company
	SET total_volume_rank=c2.total_volume_rank
		,on_topic_volume_rank=c2.on_topic_volume_rank
		,on_topic_fraction_rank=c2.on_topic_fraction_rank
		,on_topic_volume_in_top_10pct_rank=c2.on_topic_volume_in_top_10pct_rank
		,on_topic_fraction_in_top_10pct_rank=c2.on_topic_fraction_in_top_10pct_rank
		,frontier_volume_rank=c2.frontier_volume_rank
		,frontier_fraction_rank=c2.frontier_fraction_rank
		,frontier_volume_in_top_10pct_rank=c2.frontier_volume_in_top_10pct_rank
		,frontier_fraction_in_top_10pct_rank=c2.frontier_fraction_in_top_10pct_rank
		,hotness_avg_citations_over_age_rank=c2.hotness_avg_citations_over_age_rank
		,hotness_avg_y3_citations_rank=c2.hotness_avg_y3_citations_rank
		,competitive_incoming_citations_rank=c2.competitive_incoming_citations_rank
		,competitive_outgoing_citations_rank=c2.competitive_outgoing_citations_rank
		,competitive_citation_inout_fraction_rank=c2.competitive_citation_inout_fraction_rank
FROM
	company c JOIN
	(SELECT
		bvd_id
		, CASE WHEN total_volume>0 THEN CAST(RANK() OVER (ORDER BY total_volume ASC) AS REAL) / @n ELSE 0 END AS total_volume_rank
		, CASE WHEN on_topic_volume>0 THEN CAST(RANK() OVER (ORDER BY on_topic_volume ASC) AS REAL) / @n ELSE 0 END AS on_topic_volume_rank
		, CASE WHEN on_topic_fraction>0 THEN CAST(RANK() OVER (ORDER BY on_topic_fraction ASC) AS REAL) / @n ELSE 0 END AS on_topic_fraction_rank
		, CASE WHEN on_topic_volume_in_top_10pct>0 THEN CAST(RANK() OVER (ORDER BY on_topic_volume_in_top_10pct ASC) AS REAL) / @n ELSE 0 END AS on_topic_volume_in_top_10pct_rank
		, CASE WHEN on_topic_fraction_in_top_10pct>0 THEN CAST(RANK() OVER (ORDER BY on_topic_fraction_in_top_10pct ASC) AS REAL) / @n ELSE 0 END AS on_topic_fraction_in_top_10pct_rank
		, CASE WHEN frontier_volume>0 THEN CAST(RANK() OVER (ORDER BY frontier_volume ASC) AS REAL) / @n ELSE 0 END AS frontier_volume_rank
		, CASE WHEN frontier_fraction>0 THEN CAST(RANK() OVER (ORDER BY frontier_fraction ASC) AS REAL) / @n ELSE 0 END AS frontier_fraction_rank
		, CASE WHEN frontier_volume_in_top_10pct>0 THEN CAST(RANK() OVER (ORDER BY frontier_volume_in_top_10pct ASC) AS REAL) / @n ELSE 0 END AS frontier_volume_in_top_10pct_rank
		, CASE WHEN frontier_fraction_in_top_10pct>0 THEN CAST(RANK() OVER (ORDER BY frontier_fraction_in_top_10pct ASC) AS REAL) / @n ELSE 0 END AS frontier_fraction_in_top_10pct_rank
		, CASE WHEN hotness_avg_citations_over_age>0 THEN CAST(RANK() OVER (ORDER BY hotness_avg_citations_over_age ASC) AS REAL) / @n ELSE 0 END AS hotness_avg_citations_over_age_rank
		, CASE WHEN hotness_avg_y3_citations>0 THEN CAST(RANK() OVER (ORDER BY hotness_avg_y3_citations ASC) AS REAL) / @n ELSE 0 END AS hotness_avg_y3_citations_rank
		, CASE WHEN competitive_incoming_citations>0 THEN CAST(RANK() OVER (ORDER BY competitive_incoming_citations ASC) AS REAL) / @n ELSE 0 END AS competitive_incoming_citations_rank
		, CASE WHEN competitive_outgoing_citations>0 THEN CAST(RANK() OVER (ORDER BY competitive_outgoing_citations ASC) AS REAL) / @n ELSE 0 END AS competitive_outgoing_citations_rank
		, CASE WHEN competitive_citation_inout_fraction>0 THEN CAST(RANK() OVER (ORDER BY competitive_citation_inout_fraction ASC) AS REAL) / @n ELSE 0 END AS competitive_citation_inout_fraction_rank
	from
		company) c2 ON c2.bvd_id=c.bvd_id
EXEC [dbo].[log_addEntry] @component=@this_component, @message=@msg,@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Compute sorting scores',@action='START', @status='SUCCESS'
update company
	SET frontier_sorting_score = ( isnull(frontier_fraction_in_top_10pct_rank,0) + isnull(/*frontier_volume_rank*/frontier_fraction_rank,0)) / 2.0
		, on_topic_sorting_score = ( isnull(on_topic_fraction_in_top_10pct_rank,0) + isnull(/*on_topic_volume_rank*/on_topic_fraction_rank,0)) / 2.0
		, hotness_sorting_score = (isnull(hotness_avg_citations_over_age_rank,0) + isnull(hotness_avg_y3_citations_rank,0)) / 2.0
		, competitive_sorting_score = isnull(competitive_citation_inout_fraction_rank,0)
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Compute sorting scores',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT


EXEC [dbo].[log_addEntry] @component=@this_component, @message='Compute full compound score',@action='START', @status='SUCCESS'
UPDATE company SET compound_company_score = (frontier_sorting_score + /*on_topic_sorting_score +*/ hotness_sorting_score + competitive_sorting_score) * (10.0/3.0)
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Compute full compound score',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Compute thematic compound score',@action='START', @status='SUCCESS'
UPDATE company SET thematic_compound_company_score = c1.thematic_rank
FROM
	company c JOIN
	(select
		bvd_id
		, 10.0 * cast( rank() over (partition by [thematic_group]
									order by [frontier_sorting_score]
											--+ [on_topic_sorting_score]
											+ competitive_sorting_score
											+ [hotness_sorting_score] asc) as real)
				/ cast( COUNT(*) over (partition by [thematic_group]) as real) as thematic_rank
	FROM
		company) c1 ON c1.bvd_id=c.bvd_id
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Compute thematic compound score',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT


/* Load the company per-theme weighing
truncate table company_composition;

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Compute company per-theme weighing',@action='START', @status='SUCCESS'
INSERT INTO company_composition(bvd_id,preference_area_id,y,number_of_families)
select
	c.bvd_id
	, ip.preference_area_id
	, fm.priority_year
	, count(distinct cf.inpadoc_family_id)
from
	company c JOIN
	[$(pwc_v2016a_003)].[aggregate].company_family cf ON cf.bvd_id=c.bvd_id JOIN
	[$(pw_v2016a_001)].patstat.family_cpc fc ON fc.inpadoc_family_id=cf.inpadoc_family_id JOIN
	[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=cf.inpadoc_family_id JOIN
	investor_preference ip ON ip.cpc_id=fc.cpc_id
group by
	c.bvd_id
	, ip.preference_area_id
	, fm.priority_year
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Compute company per-theme weighing',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT */

RETURN 0
