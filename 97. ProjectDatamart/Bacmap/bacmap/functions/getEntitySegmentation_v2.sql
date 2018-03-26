CREATE FUNCTION [bacmap].[getEntitySegmentation]
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
	, period_id varchar(32)
	, is_custom_definition bit -- for display (in italic?)
)
AS
BEGIN
	IF @period_id IS NULL
		SET @period_id = (SELECT TOP 1 period_id FROM [bacmap].[period] WHERE period_type='Y' ORDER BY period_year DESC)

	DECLARE @supressCustom BIT = 0

	DECLARE @customLinesAvailable INT 
	
	select @customLinesAvailable = count (*) 
			from 
				[$(bb_db)].custom.getCustomEntitySegmentation(@bvd_id, @period_id, DEFAULT, DEFAULT)
			where 
				segment_period_revenue IS NOT NULL

	if @supressCustom = 0 and @customLinesAvailable > 0
	begin
		insert into @returntable
			select line_item_id
				, line_item_parent_id
				, segment_level
				, segment_label
				, segment_period_revenue
				, period_id
				, is_custom_definition  
			from 
				[$(bb_db)].custom.getCustomEntitySegmentation(@bvd_id, @period_id, DEFAULT, DEFAULT)
	end
	else
	begin
		insert into @returntable
			select  line_item_id
				, line_item_parent_id
				, segment_level
				, segment_label
				, segment_period_revenue
				, period_id
				, is_custom_definition
			from 
				[$(bb_db)].bloomberg.getEntitySegmentation(@bvd_id, @period_id, DEFAULT, DEFAULT)
	end
	RETURN
END
