CREATE FUNCTION [bacmap].[getEntityIdFromBvd]
(
	@bvd_id NVARCHAR(25)
)
RETURNS VARCHAR(32)
AS
BEGIN
	DECLARE @entity_label NVARCHAR(500)
	DECLARE @entity_id VARCHAR(32)  
	
	/* Changed by PL,August 29th 2017; reference the data handler instead of IDR linktables directly. */
	SELECT @entity_label = 
				bb_ticker--BB_ticker_exchange 
					from 
						[$(DataHandlerDb)].latest.company_ticker
						--[$(idr_db)].input.[linktable_Orbis_Bloomberg_ticker]
				where company_id=@bvd_id--bvd_id = @bvd_id

	SELECT @entity_id = 
				[entity_id] 
					from 
						[$(bb_db)].[bloomberg].entity
				where bb_ticker = @entity_label

	RETURN @entity_id
END
