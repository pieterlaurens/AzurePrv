CREATE PROCEDURE [dbo].[GetCompanyScore]
	@bvd_id varchar(25)
AS
	declare @gr varchar(100)
	set @gr = (select thematic_group from company where bvd_id=@bvd_id)

	select
		company_name
		, competitive_sorting_score
		, hotness_sorting_score
		, frontier_sorting_score
		, compound_company_score
		, thematic_compound_company_score
	from
		hotness.company
	where
		bvd_id=@bvd_id
	union
	select distinct
		CONCAT(@gr,' 50%')
		, PERCENTILE_CONT(0.5) within group (order by competitive_sorting_score asc) over ()
		, PERCENTILE_CONT(0.5) within group (order by hotness_sorting_score asc) over ()
		, PERCENTILE_CONT(0.5) within group (order by frontier_sorting_score asc) over ()
		, PERCENTILE_CONT(0.5) within group (order by compound_company_score asc) over ()
		, PERCENTILE_CONT(0.5) within group (order by thematic_compound_company_score asc) over ()
	from
		company
	WHERE
		thematic_group = @gr
	union
	select distinct
		CONCAT(@gr,' 75%')
		, PERCENTILE_CONT(0.75) within group (order by competitive_sorting_score asc) over ()
		, PERCENTILE_CONT(0.75) within group (order by hotness_sorting_score asc) over ()
		, PERCENTILE_CONT(0.75) within group (order by frontier_sorting_score asc) over ()
		, PERCENTILE_CONT(0.75) within group (order by compound_company_score asc) over ()
		, PERCENTILE_CONT(0.75) within group (order by thematic_compound_company_score asc) over ()
	from
		hotness.company
	WHERE
		thematic_group = @gr

RETURN 0
