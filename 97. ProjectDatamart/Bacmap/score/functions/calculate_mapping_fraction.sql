CREATE FUNCTION [score].[calculate_mapping_fraction]
(
	@bvd_id NVARCHAR(25),
	@period_id VARCHAR(32)
)
RETURNS @sdiScoreTable TABLE (
	[custom_mapping_id] VARCHAR(32)
	, [custom_mapping_label] VARCHAR(100)
	, [mapping_share] REAL
	, [custom_mapping_score] REAL
	, [custom_mapping_relevancy] int NULL
)
AS
BEGIN
	------------------------------------------------------------------------------------------
	--01. Get the segmentation:

	declare @total_period_revenue REAL = (
		Select segment_period_revenue 
			from
				[bacmap].getEntitySegmentation(@bvd_id,@period_id)
			where
				segment_level = 0
		)
	
	if isnull(@total_period_revenue, 0) = 0 GoTo onReturn

	; with neutralCategory AS (

			--Deal with unmapped scores:
			select [custom_mapping_id] as id
				from
					[bacmap].[custom_mapping]
				where
					[custom_mapping_value] = 'Irrelevant for SDI'
		)
	, mapping as (

			--Get the segmentation:
			Select line_item_id
					, line_item_parent_id
					, segment_level
					, segment_period_revenue
					, isnull(mapping_id, (select id from neutralCategory)) as mapping_id
					, isnull(mapping_share, 1) as mapping_share
				from 
					[bacmap].getEntityMapping (@bvd_id, @period_id) t0
				where
					segment_period_revenue IS NOT NULL
		)
	, childrenless_mothers as (

			--Only look at the leaves of the segmentation:
			select distinct t0.line_item_id
				from  
					mapping t0
				left outer join
					mapping t1 on t0.line_item_id = t1.line_item_parent_id
				where
					t0.line_item_parent_id is not NULL
				and
					t1.line_item_parent_id is NULL
		)

	--write the intermediate result:
	insert into @sdiScoreTable ([custom_mapping_id]
									, [custom_mapping_label]
									, [mapping_share]
									, [custom_mapping_score]
									, [custom_mapping_relevancy]
			)
		select t0. mapping_id
				, t2.custom_mapping_label
				, sum(segment_period_revenue * mapping_share) / @total_period_revenue AS mapping_share
				, t2.custom_mapping_score
				, t2.custom_mapping_relevancy
			from 
				mapping t0
			join
				childrenless_mothers t1 on t0.line_item_id = t1.line_item_id
			join 
				[bacmap].[custom_mapping] t2 on t0.mapping_id = t2.custom_mapping_id
			group by
				t0. mapping_id
				, t2.custom_mapping_label
				, t2.custom_mapping_relevancy
				, t2.custom_mapping_score

	onReturn:
		RETURN
END
