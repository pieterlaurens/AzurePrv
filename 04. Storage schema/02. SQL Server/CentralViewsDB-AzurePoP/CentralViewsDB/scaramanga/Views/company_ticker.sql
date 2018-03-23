CREATE VIEW scaramanga.[company_ticker]
	AS
select
	cast(bb_ticker as nvarchar(50)) as company_id, cast(bb_ticker as nvarchar(50)) as bb_ticker
from
	(SELECT
		bvd_id as company_id
		, bb_ticker
		, row_number() over (partition by bvd_id order by score desc) as r
	FROM
		[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5
	where
		[rank]=1
	) a
where
	r=1