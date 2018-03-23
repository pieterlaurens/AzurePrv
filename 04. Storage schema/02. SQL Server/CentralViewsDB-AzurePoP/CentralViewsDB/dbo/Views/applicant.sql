CREATE VIEW [dbo].[applicant] AS
SELECT
	doc_std_name_id as applicant_id
	, doc_std_name as [name]
	, person_address as [address]
	, person_ctry_code as [country]
	, first_filing
	, last_filing
	, n_invt as occurrences_as_inventor
	, n_applt as occurrences_as_applicant
	, ipc_subclass as class_group_level1
FROM
	[$(PatentsWork15bcpc_server)].[$(pw15b_cpc)].dbo.doc_std_names_ext2