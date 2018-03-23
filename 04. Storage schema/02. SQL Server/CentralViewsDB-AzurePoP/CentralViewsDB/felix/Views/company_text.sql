CREATE VIEW felix.[company_text]
	AS
SELECT
	bvd_id
	, text_type
	, text_content
FROM
	[$(scdr_16_1_server)].[$(scdr_16_1)].dbo.orbis_text
WHERE
	[org_bvd_pk_rnk]=1
