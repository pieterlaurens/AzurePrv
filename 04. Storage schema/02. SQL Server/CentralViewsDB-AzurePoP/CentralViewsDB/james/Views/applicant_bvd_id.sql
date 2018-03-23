CREATE VIEW [james].[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, lb.ticker as bvd_id
FROM
	[$(pwc_v2016b_002)].idr.person_to_bvd_id p JOIN
	[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb ON lb.bvd_id=p.bvd_id