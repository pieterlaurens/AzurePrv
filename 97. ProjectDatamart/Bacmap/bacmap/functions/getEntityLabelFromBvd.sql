CREATE FUNCTION [bacmap].[getEntityLabelFromBvd]
(
	@bvd_id NVARCHAR(25)
)
RETURNS NVARCHAR(500)
AS
BEGIN
	DECLARE @entity_label NVARCHAR(500) 
	
	/* Changed by PL,August 29th 2017; reference the data handler instead of IDR linktables directly. */
	SELECT @entity_label = 
				bb_ticker--BB_ticker_exchange 
					from 
						[$(DataHandlerDb)].latest.company_ticker
						--[$(idr_db)].input.[linktable_Orbis_Bloomberg_ticker]
				where company_id=@bvd_id--bvd_id = @bvd_id
	
	RETURN @entity_label
END
