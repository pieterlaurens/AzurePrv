CREATE FUNCTION [bacmap].[getEntityMapping]
(
	@bvd_id varchar(25)
	, @period_id varchar(32)
)
RETURNS @returntable TABLE
(
	line_item_id varchar(32) -- for callbacks
	, line_item_parent_id varchar(32) -- for creating a tree structure
	, segment_level smallint -- for indentation; could follow from parent_id: if NULL then 0, otherwise level(parent)+1
	, segment_label nvarchar(500) -- for display
	, segment_period_revenue  real -- for display
	, is_custom_definition bit -- for display (in italic?)
	, mapping_id nvarchar(32) -- for callbacks
	, mapping_label nvarchar(500) -- for display
	, mapping_comment nvarchar(max) -- for display
	, mapping_comment_product nvarchar(max) -- for display
	, mapping_made_by nvarchar(250) -- for display
	, mapping_share real -- for display
	, is_required_for_mapping bit
	, certainty real
)
AS
BEGIN
	IF @period_id IS NULL
		SET @period_id = (SELECT TOP 1 period_id FROM [bacmap].[period] WHERE period_type='Y' ORDER BY period_year DESC)

	DECLARE @showEmptyLines BIT = 0

	; WITH activeMapping AS (
				select lim.line_item_id
					, lim.custom_mapping_id
					, cm.custom_mapping_label
					, lim.comment
					, lim.comment_product
					, ma.executed_by
					, lim.revenue_fraction
					, lim.certainty
					from 
						[bacmap].line_item_custom_mapping lim
					LEFT OUTER JOIN
						[bacmap].custom_mapping cm ON cm.custom_mapping_id=lim.custom_mapping_id
					LEFT OUTER JOIN
						[report].mapping_action ma ON ma.id = lim.latest_mapping_action_id
					where 
						period_id=@period_id
					and 
						lim.is_active = 1
					and
						cm.is_active = 1	
			)
		, segmentation AS (
				select *
					from
						[bacmap].getEntitySegmentation(@bvd_id, @period_id)
			)
		, yearSegmentation AS (
				select *
					from 
						segmentation
					where
						segment_period_revenue is not NUll
			)
		, childlessMothers AS (
				select t0.line_item_id
					from 
						yearSegmentation t0
					left outer join
						yearSegmentation t1 on t0.line_item_id = t1.line_item_parent_id
				where
					t0.line_item_parent_id is NOT NULL
				and
					t1.line_item_parent_id is NULL
			)
		INSERT @returntable
			SELECT
					s.line_item_id
					, s.line_item_parent_id 
					, s.segment_level
					, s.segment_label
					, s.segment_period_revenue
					, s.is_custom_definition
					, m.custom_mapping_id
					, m.custom_mapping_label
					, m.comment
					, m.comment_product
					, m.executed_by
					, m.revenue_fraction
					, case
						when cm.line_item_id is null then
							0
						else
							1
						end as is_required_for_mapping
					, m.certainty
				FROM
					 segmentation s
				LEFT OUTER JOIN
					childlessMothers cm on s.line_item_id = cm.line_item_id
				LEFT OUTER JOIN
					activeMapping m ON m.line_item_id = s.line_item_id
				WHERE
					 @showEmptyLines = 1
				or
					(@showEmptyLines  = 0 AND s.segment_period_revenue IS NOT NULL)
				ORDER BY
					s.segment_level ASC
	RETURN
END
