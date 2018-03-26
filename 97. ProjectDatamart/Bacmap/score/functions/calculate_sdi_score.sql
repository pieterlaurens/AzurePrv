CREATE FUNCTION [score].[calculate_sdi_score]
(
	@bvd_id NVARCHAR(25),
	@period_id VARCHAR(32)
)
RETURNS @score_overview TABLE (
		segment_score real
		, bonus_score real
		, sdi_score real
		, technology_score real
		, calculated_score real
		, manual_score real
	)
AS
BEGIN
	declare @sdiScoreTable AS [score].[score_table_for_entity]
	declare @st datetime2
	declare @end datetime2
	
	insert into @sdiScoreTable (
				[custom_mapping_id]
				,[mapping_share]
				,[custom_mapping_score]
				,[custom_mapping_relevancy]
			)
		select 	[custom_mapping_id]
					, [mapping_share]
					, [custom_mapping_score]
					, [custom_mapping_relevancy]
				from [score].[calculate_mapping_fraction](@bvd_id, @period_id)REAL

	declare @segmentScore REAL		= isnull([score].segmentation_algorithm(@sdiScoreTable), 0)

	declare @bonusScore REAL		= isnull([score].sdi_bonus_algorithm(@bvd_id), 0)

	declare @technologyScore REAL	= isnull([score].technology_get(@bvd_id), 0)

	declare @sdiScore REAL			= isnull([score].sdi_algorithm(@segmentScore, @bonusScore), 0)

	declare @manualScore REAL		= isnull([score].manual_get(@bvd_id), -1)

	declare @calculatedScore REAL	= isnull([score].calculated_total_algorithm(@manualScore, @technologyScore, @sdiScore), 0)

	



	insert into @score_overview
		select @segmentScore
				, @bonusScore
				, @sdiScore
				, @technologyScore
				, @calculatedScore
				, @manualScore
	onReturn:
		RETURN
END
