CREATE PROCEDURE [dbo].[02_TechnologyHotness]

AS

DECLARE @this_component varchar(100)
set @this_component=OBJECT_NAME(@@PROCID)

declare @blanking smallint = 2; -- the most recent years that are omitted for lack of data
declare @recent_period smallint = 5; -- the period considered recent is now() - blanking - recent_period until now() - blanking. In 2016: 2016-2-5=2009, until 2016-2=2014.
declare @trend_block smallint = 10; -- When looking at trends, this is approximated by comparing to consecutive blocks of time. If the second block exceeds the first block that is considered an upward trend and vice versa for a downward trend.

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Update technology top 10% citation level',@action='START', @status='SUCCESS'
;with a as (SELECT DISTINCT
		tf.[technology_id]
		, percentile_cont(0.9) within group (order by fm.family_citation asc) over (partition by tf.technology_id) as citation_top10pct
	FROM
		technology_family tf JOIN
		[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=tf.inpadoc_family_id
	WHERE
		fm.priority_year >= (year(getdate()) - 20)
) UPDATE technology SET
	citations_top10pct = a.citation_top10pct
FROM
	technology t JOIN
	a ON t.technology_id=a.technology_id
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Update technology top 10% citation level',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Mark top 10% technology families',@action='START', @status='SUCCESS'
UPDATE technology_family SET
	is_top_in_technology = 1
FROM
	technology_family tf JOIN
	technology t ON t.technology_id=tf.technology_id
WHERE
	tf.number_of_citations >= t.citations_top10pct
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Mark top 10% technology families',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Update investor preference top 10% citation level',@action='START', @status='SUCCESS'
;with a as (SELECT DISTINCT
		tf.preference_id
		, percentile_cont(0.9) within group (order by fm.family_citation asc) over (partition by tf.preference_id) as citation_top10pct
	FROM
		investor_preference_family tf JOIN
		[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=tf.inpadoc_family_id
	WHERE
		fm.priority_year >= (year(getdate()) - 20)
) UPDATE investor_preference SET
	citations_top10pct = a.citation_top10pct
FROM
	investor_preference t JOIN
	a ON t.preference_id=a.preference_id
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Update investor preference top 10% citation level',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

EXEC [dbo].[log_addEntry] @component=@this_component, @message='Mark top 10% investor preference families',@action='START', @status='SUCCESS'
UPDATE investor_preference_family SET
	is_top_in_preference = 1
FROM
	investor_preference_family tf JOIN
	investor_preference t ON t.preference_id=tf.preference_id
WHERE
	tf.number_of_citations >= t.citations_top10pct
EXEC [dbo].[log_addEntry] @component=@this_component, @message='Mark top 10% investor preference families',@action='END', @status='SUCCESS', @rowcount=@@ROWCOUNT

RETURN 0