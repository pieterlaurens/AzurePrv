CREATE FUNCTION [score].[segmentation_algorithm]
(
	@sdiScoreTable AS [score].[score_table_for_entity] READONLY
)
RETURNS REAL
AS
BEGIN
	--some buffers:
	declare @pos_score	real
		, @neg_score	real
		, @ntrl_score	real
		, @neg_corr		real

	-----------------------------------------------------------------------------
	-- 00. Create an aggregate per score type:
	-----------------------------------------------------------------------------
		declare @score_per_scoreTypes AS [score].[score_table_for_entity]  
			
			insert into @score_per_scoreTypes(custom_mapping_relevancy, mapping_share, custom_mapping_score)
				
				select custom_mapping_relevancy
						, sum(mapping_share) as mapping_share
						, sum(mapping_share * custom_mapping_score) as score
					from 
						@sdiScoreTable
					group by
						custom_mapping_relevancy;

	----------------------------------------------------------------------------
	-- 01. positively contributing categories:
	--		weighted average of scores
	----------------------------------------------------------------------------
		select @pos_score =custom_mapping_score / mapping_share
								from 
									@score_per_scoreTypes
								where
									custom_mapping_relevancy = 1;

	------------------------------------------------------------------------------------------
	-- 02. Deal with the neutral SDI products
	--		if 50-80% subtract -1
	--		if >80% subtract -2
	------------------------------------------------------------------------------------------
		select @ntrl_score = -1 *  case 
										when mapping_share < 0.5 then
											0
										when mapping_share < 0.8 then
											1
										else
											2
										end
								from 
									@score_per_scoreTypes
								where
									custom_mapping_relevancy = 0;

	------------------------------------------------------------------------------------------------------
	-- 03. Deal with the negative SDI products:
	--		correction_factor=1/(weighted average of negative products)
	--		if <5%    -1*correction_factor
	--		if 5-20%  -2*correction_factor
	--		if 20-40% -3*correction_factor
	--		if 40-60% -4*correction_factor
	--		if >60%   -5*correction_factor
	------------------------------------------------------------------------------------------------------
		select @neg_corr = case
							when mapping_share > 0 then
									isnull(mapping_share / custom_mapping_score, 0)
								else
									0
								end
							from
								@score_per_scoreTypes
							where 
								custom_mapping_relevancy = -1

		select @neg_score = -1 * @neg_corr * 
									 case 
										when mapping_share < 0.05 then
											1
										when mapping_share < 0.2 then
											2
										when mapping_share < 0.4 then
											3
										when mapping_share < 0.6 then
											4
										else
											5
										end
								from 
									@score_per_scoreTypes
								where
									custom_mapping_relevancy = -1;

	------------------------------------------------------------------------------------------------------
	-- 04. return total score:
	declare @total real = (isnull(@pos_score,0) + isnull(@neg_score,0) + isnull(@ntrl_score,0))
	
	RETURN (case 
				when @total > 10 then 10
				when @total < 0 then 0
				else @total
				end
			)

END
