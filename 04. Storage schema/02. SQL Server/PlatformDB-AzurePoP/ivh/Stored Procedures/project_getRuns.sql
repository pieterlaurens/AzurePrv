USE [prv_dev_inh]
GO

/****** Object:  StoredProcedure [ivh].[project_getRuns]    Script Date: 15-03-2018 14:52:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [ivh].[project_getRuns]
	@project_name varchar(100)
AS

	declare @vv table(run_id int)

	insert into @vv select distinct run_id from [ivh].[run_paramvalue] where
		parameter='api_sla'
		--and ISJSON([value]) > 0
		and JSON_VALUE([value],'$.ProjectCatalog') = @project_name

	SELECT
		run_id
		, ScoringLabel, ScoringType, TimeAttribute, AttributeName, TimeRange, TopicCorpus, TopicName, IsPredictor
	FROM
		(SELECT
			run_id
			, ScoringParams
		FROM
			(SELECT
				v.run_id
				, JSON_QUERY([value],'$.ComponentParams') as ComponentParams
			FROM
				@vv v JOIN
				[ivh].[run_paramvalue] p ON p.run_id=v.run_id
			where
				parameter='api_config'
				and
				JSON_VALUE([value],'$.Header.NameOfApi')='CreateLonglist') P
			CROSS APPLY OPENJSON(P.ComponentParams) WITH (PackageName varchar(50) '$.PackageName',  
				ScoringParams nvarchar(max) '$.ScoringParams' as JSON )
		WHERE PackageName='CompanyScoring'
		) S
	CROSS APPLY OPENJSON(S.ScoringParams)  
	  WITH (ScoringLabel varchar(50) '$.ScoringLabel',  
			ScoringType varchar(50) '$.ScoringType',  
			TimeAttribute nvarchar(50) '$.TimeAttribute',
			AttributeName nvarchar(100) '$.AttributeName',
			TimeRange nvarchar(50) '$.TimeRange',
			TopicCorpus nvarchar(50) '$.TopicCorpus',
			TopicName nvarchar(50) '$.TopicName',
			IsPredictor nvarchar(5) '$.IsPredictor'
			)
	ORDER BY
		run_id DESC

	SELECT
		v.run_id, p.created_on
		, JSON_VALUE([value],'$.ProjectDataSource') as ProjectDataSource
		, JSON_VALUE([value],'$.ProjectCatalog') as ProjectCatalog
		, JSON_VALUE([value],'$.PlatformDataSource') as PlatformDataSource
		, JSON_VALUE([value],'$.PlatformCatalog') as PlatformCatalog
		, JSON_VALUE([value],'$.DatahandlerDataSource') as DatahandlerDataSource
		, JSON_VALUE([value],'$.DatahandlerCatalog') as DatahandlerCatalog
		, JSON_VALUE([value],'$.DatahandlerVersion') as DatahandlerVersion
		, p.[value] as api_sla
		, JSON_MODIFY(c.api_config,'$.Header.ConfigurationDescription','Website re-run') as api_config
	FROM
		@vv v JOIN
		[ivh].[run_paramvalue] p ON p.run_id=v.run_id JOIN
		(select run_id, [value] as api_config from [ivh].[run_paramvalue] where [parameter]='api_config') c ON c.run_id=v.run_id
	where
		parameter='api_sla'
