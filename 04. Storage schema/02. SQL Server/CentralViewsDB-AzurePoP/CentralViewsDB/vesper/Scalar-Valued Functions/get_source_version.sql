CREATE FUNCTION [vesper].[get_source_version]
(
	@source_type varchar(25)
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @source_version varchar(50)

	IF @source_type='Patents'
		SET @source_version = (select cast([value] as varchar(50)) from [$(pw_v2017a_001)].sys.fn_listextendedproperty ('SubVersionNumber',default,default,default,default,default,default))

	RETURN @source_version
END
