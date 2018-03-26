CREATE PROCEDURE [dbo].[GetTechnologyHotnessTablesForMatlab]
AS
	/* Labels for the graphs */
	select
		technology_id
		, replace(label,'_',' ') as label
	from
		technology

	/* Table for composition over time of technologies */
	select distinct
		tm.technology_id
		, tmf.inpadoc_family_id
		, priority_year
		, tmf.y3_citations
	from
		technology tm JOIN
		technology_family tmf ON tm.technology_id=tmf.technology_id
	--where
	--	in_focus=1

	/* Aggregated tables for trends in technologies
	select
		*
	from
		technology_trend */
RETURN 0
