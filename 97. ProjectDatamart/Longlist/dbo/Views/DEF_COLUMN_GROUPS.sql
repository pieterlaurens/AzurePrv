


CREATE VIEW [dbo].[DEF_COLUMN_GROUPS]
	AS

SELECT
	[score_generic_name]
	, 'Other' as column_group_name
	, 0 as default_visible
FROM
	company_score
where
	score_label not in (select distinct score_label from longlist_column_groups)
	and
	score_label in (select score_label from company_score where display_in_fe=1)
UNION ALL
select
	score_generic_name
	, lcg.column_group_name
	, lcg.default_visible
from
	longlist_column_groups lcg JOIN
	company_score cs ON cs.score_label=lcg.score_label