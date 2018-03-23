CREATE VIEW xenia.[company_text]
	AS
SELECT
	bvd_id
	, text_type
	, text_content
FROM
	[$(scdr_15_1_server)].[$(scdr_15_1)].dbo.orbis_text
WHERE
	[org_bvd_pk_rnk]=1
