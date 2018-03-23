/*
	1. Making a bag of classes for inclusion in a landscape. The CPC classes have no weight associated with them. 
	
	Typical usage: (see proper examples for valid configurations)
	- {"PackageName":"SelectLandscapeNodes",
		"NodeSelectionParams": [
			"NodeSelectionType" : "NodeList"
			, "NodeList":"A31F|B43K 21/3.....

*/
SELECT
	STUFF(
	(	SELECT
			'|'+a.ipc_key
		FROM
			(select distinct
				fk.ipc_key
			from
				patents_work2015b.dbo.full_cpc fc JOIN
				patents_work2015b.[dbo].[full_cpc_full_label] fl ON fl.all_ipc_id=fc.all_ipc_id JOIN
				patents_work2015b.[dbo].[full_cpc_key] fk ON fk.all_ipc_id=fc.all_ipc_id
			where
				fk.ipc_key like 'B33y%'
			) a
		FOR XML PATH('')
	)
	,1,1,''
	)

/*
	2. Making a weighted bag of classes, used for retrieving and scoring companies.

	Typical usage: (see proper examples for valid configurations)
	- {"PackageName":"CompanyRetrieval",
		"RetrievalParams": [
			"RetrievalType" : "PatentClassProfile"
			, "ClassProfile":"A31f:0.3|B43K 21/3:0.2.....
*/
USE pw15b_dev
DECLARE @w nvarchar(10) = ':.02'; -- Set to fixed value for illustrative purposes.
SELECT
	STUFF(
	(	SELECT
			'|'+a.cpc_code+@w
		FROM
			(select distinct
				cpc_code
			from
				patstat.cpc_entry
			where
				cpc_code like 'B3%'
			) a
		FOR XML PATH('')
	)
	,1,1,''
	)

SELECT
	STUFF(
	(	SELECT
			'|'+a.cpc_code+':'+cast(class_weight as nvarchar(15))
		FROM
			(select distinct top 100
				ce.cpc_code
				, 1.0 / cast(cm.[cpc_num_families] as real) as class_weight
				, cm.[cpc_num_families]
			from
				patstat.cpc_entry ce JOIN
				patstat.cpc_metric cm ON cm.cpc_id=ce.cpc_id
			where
				ce.cpc_code like 'A23%'
				and
				cm.[cpc_num_families] > 0
			order by
				cm.[cpc_num_families] desc
			) a
		FOR XML PATH('')
	)
	,1,1,''
	)