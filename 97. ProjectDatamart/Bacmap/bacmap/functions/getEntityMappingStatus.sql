CREATE FUNCTION [bacmap].[getEntityMappingStatus]
(
	@bvd_id varchar(25)
)
RETURNS @returntable TABLE
(
	period_id varchar(32) -- for callbacks
	, period_year SMALLINT -- for display
	, mapping_status int --for display
)
AS
BEGIN
	--get the list of periods:

	declare @entity_id VARCHAR(32)
		select @entity_id = bacmap.getEntityIdFromBvd(@bvd_id)

	declare @allPeriods Table (
						period_id varchar(32)
						, period_year int
						, period_label nvarchar(250)
			)
	Insert into @allPeriods 
				select distinct period_id
						, period_year
						, period_label
					from 
						[bacmap].[period]
					where 
						[period_type] = 'Y'

	DECLARE	@period_id varchar(32)
			, @period_year int
			, @period_label nvarchar(250)

	DECLARE yearCursor CURSOR FAST_FORWARD
			FOR
				SELECT * FROM @allPeriods
					order by period_year

	OPEN yearCursor

	FETCH NEXT FROM yearCursor
		INTO 
			@period_id,  @period_year, @period_label

	WHILE @@FETCH_STATUS = 0
	BEGIN

		if exists (SELECT *
					FROM
						[bacmap].custom_mapping_entity_status
					where 
						[entity_id] = @entity_id
					and 
						is_active = 1
					and
						is_finished = 1
					and 
						period_id = @period_id)
		begin
			INSERT into @returntable
				select @period_id
						, @period_year
						, 3 as period_status
		end
		else
		begin
			; with fullMapping AS (
					select t0.line_item_id
							, t0.line_item_parent_id
							, t0.period_id
							, t1.id as mapping_id
							, t1.is_active
							, t1.revenue_fraction
						from 
							[bacmap].getEntitySegmentation(@bvd_id, @period_id) t0
						left outer join
							[bacmap].[line_item_custom_mapping] t1 on t0.line_item_id = t1.line_item_id
																	and
																		t0.period_id = t1.period_id
						where 
							t0.segment_period_revenue is not null
						--and
						--	t1.is_active = 1
					)
				, motherlessChildren AS (
						select t0.*
							from 
								fullMapping t0
							left outer join
								fullMapping t1 on t0.line_item_id = t1.line_item_parent_id
							where 
								t0.line_item_parent_id is not NULL
							and 
								t1.line_item_parent_id is NULL
					)
				, counts as (
						select distinct
									isnull(count(distinct line_item_id), 0) as total_line_items
									, isnull(sum( case 
													when is_active = 1 and revenue_fraction > 0 and mapping_id is not null then
														1
													else
														0
													end
												) , 0) as mapped_line_items
							from
								motherlessChildren
					)
			INSERT into @returntable
				select @period_id
						, @period_year
						, case 
							when total_line_items = 0 then
								-1
							when mapped_line_items >= total_line_items  then
								2 --completed, not finished
							when mapped_line_items > 0 then
								1 --started
							else 
								0  
						end as period_status
				from 
					counts
		end
	
		FETCH NEXT FROM yearCursor
			INTO 
				@period_id,  @period_year, @period_label
	END

	onReturn:
	RETURN
END


/*	--OLD CODE:
	; with fullMapping AS (
			select t0.line_item_id
					, t0.line_item_parent_id
					, t0.period_id
					, t1.id as mapping_id
					, t1.is_active
					, t1.revenue_fraction
				from 
					[bacmap].getEntitySegmentation(@bvd_id, '-1') t0
				left outer join
					[bacmap].[line_item_custom_mapping] t1 on t0.line_item_id = t1.line_item_id
															and
																t0.period_id = t1.period_id
				where 
					t0.segment_period_revenue is not null
			)
		, motherlessChildren AS (
				select t0.*
					from 
						fullMapping t0
					left outer join
						fullMapping t1 on t0.line_item_id = t1.line_item_parent_id
										and t0.period_id = t1.period_id
					where 
						t0.line_item_parent_id is not NULL
					and 
						t1.line_item_parent_id is NULL
			)
		, allPeriods AS (
				select distinct period_id
						, period_year
						, period_label
					from 
						[$(bb_db)].[bloomberg].[period]
					where 
						[period_type] = 'Y'
			)
		, finished as (
				SELECT
						li.period_id
						, li.is_finished
					FROM
						[bacmap].custom_mapping_entity_status li
					where 
						li.[entity_id] = bacmap.getEntityIdFromBvd(@bvd_id)
					and 
						li.is_active = 1
			)
		, counts as (
				select distinct
						t0.period_id
						, t0.period_year
							, isnull(count(t1.line_item_id) over(partition by t0.period_id),0) as total_line_items
							, isnull(sum( case 
											when t1.is_active = 1 and t1.revenue_fraction > 0 and t1.mapping_id is not null then
												1
											else
												0
											end
										) over(partition by t0.period_id), 0) as mapped_line_items
						--,*
					from
						allPeriods t0
					left outer join
						motherlessChildren t1 on t0.period_id = t1.period_id
			)
	INSERT into @returntable
		select t0.period_id
				, t0.period_year
				, case 
					when t0.total_line_items = 0 then
						-1
					when t1.is_finished = 1 then
						3 --finished
					when t0.total_line_items =  t0.mapped_line_items then
						2 --completed, not finished
					when t0.mapped_line_items > 0 then
						1 --started
					else 
						0  
				end as period_status
		from 
			counts t0
		left outer join 
			finished t1 on t0.period_id = t1.period_id
*/	
	
/*	
	with fullSegmentation as(
				SELECT
						li.line_item_id
						, li.parent_id
						, r.period_id
						, r.metric_value
						, cm.custom_mapping_id
						, cm.is_active
					FROM
						[$(bb_db)].[bloomberg].line_item li
					JOIN
						[$(bb_db)].[bloomberg].[line_item_period_metric] r ON r.line_item_id = li.line_item_id
					left outer join
						[bacmap].[line_item_custom_mapping] cm on r.line_item_id = cm.[line_item_id]
																	and r.period_id = cm.[period_id]
					where 
						li.[entity_id] = @entity_id
					and
						r.metric_value is not null
			)
	, childlessMothers AS (
				select line_item_id
					from
						fullSegmentation

				except

				select parent_id
					from
						fullSegmentation

		)
	, segmentation AS (
				select t0.* 
					from 
						fullSegmentation t0
					join
						childlessMothers t1 on t0.line_item_id = t1.line_item_id
		)
	, itemsPerYear as (
				select period_id
						, count(distinct line_item_id) as totalLines 
					from  
						segmentation
					group by 
						period_id
		)
	, openItems AS (
				select period_id
						, count(distinct line_item_id) as openlines
					from 
						segmentation
					where 
						is_active is null or is_active = 0
					group by 
						period_id
	)
	, finished as (
				SELECT
						li.period_id
						, li.is_finished
					FROM
						[bacmap].custom_mapping_entity_status li
					where 
						li.[entity_id] = @entity_id
					and 
						li.is_active = 1
	)
	INSERT into @returntable
		select t00.period_id
				, t00.period_year
				, case 
					when t2.is_finished = 1 then
						3 --finished
					when t0.totalLines - t1.openLines = t0.totalLines then
						2 --completed, not finished
					when t0.totalLines - t1.openLines < t0.totalLines 
							and t0.totalLines - t1.openLines > 0 then
						1 --started
					else 0 
				end as mapping_status
			from 
				[$(bb_db)].[bloomberg].[period] t00
			left outer join
				itemsPerYear t0 on t00.period_id = t0.period_id
			left outer join 
				openItems t1 on t1.period_id = t0.period_id
			left outer join 
				finished  t2 on t0.period_id = t2.period_id
			WHERE 
				t00.period_type = 'Y'
			ORDER BY t00.period_year
*/
