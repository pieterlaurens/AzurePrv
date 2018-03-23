﻿CREATE VIEW [goodhead].deal_structure AS

SELECT
	cast([deal_id] as nvarchar(10)) as [deal_id]
    ,[structure_field_name]
    ,[structure_field_value]
FROM
	[$(sdd_v2016_004)].dbo.deal_structure
