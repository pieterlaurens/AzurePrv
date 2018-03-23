BEGIN TRY
create table report.test_report(
	api varchar(100)
	, test_result varchar(10)
	, test_name varchar(50)
	, test_comment varchar(1000)
	, executed_on datetime default getdate()
	, run_id int
	, component_id nvarchar(50))
END TRY
BEGIN CATCH
	IF OBJECT_ID('report.test_report','U') is null
		THROW;
END CATCH

GO

BEGIN TRY
	CREATE TABLE [dbo].[company_long_list] (
		[row_i]         INT            IDENTITY (1, 1) NOT NULL,
		[company_id]    NVARCHAR (50)  NULL,
		[match]         REAL           NULL,
		[company_name]  NVARCHAR (255) NULL,
		[retrieval_key] NVARCHAR (50)  NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].company_long_list','U') is null
		THROW;
END CATCH

GO

BEGIN TRY
	CREATE TABLE [dbo].[company_score](
		[score_id]			INT IDENTITY(1,1)	NOT NULL,
    	[score_generic_name] AS             CONCAT('a',RIGHT('00000'+CAST([score_id] AS VARCHAR(5)),5)),  --(concat('companyAttribute',right(concat('0',[score_id]),(len([score_id])+(1))+sign((1)-len([score_id]))))),
		[score_label]		NVARCHAR (100)		NULL,
		[is_numeric]		BIT					NULL,
		[display_in_fe]		BIT					NULL DEFAULT ((1)),
		[column_order]		SMALLINT			NULL,
		[data_type]			NVARCHAR (25)		NULL,
		[flex_width]		SMALLINT			NULL DEFAULT ((4)),
		[default_scale]		INT					NULL DEFAULT ((3)),
		[precision]			INT					NULL DEFAULT ((2)),
		[unit]				NVARCHAR (10)		NULL,
		[uni_polar]			BIT					NULL DEFAULT ((1))
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].company_score','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[company_score_int] (
		[company_id]        NVARCHAR (50) NULL,
		[score_name]		NVARCHAR (50) NULL,
		[score_value]       BIGINT        NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].company_score_int','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[company_score_real] (
		[company_id]        NVARCHAR (50) NULL,
		[score_name]		NVARCHAR (50) NULL,
		[score_value]       REAL          NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].company_score_real','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[company_score_str] (
		[company_id]        NVARCHAR (50)	NULL,
		[score_name]		NVARCHAR (50)	NULL,
		[score_value]             NVARCHAR (MAX)	NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].company_score_str','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[company_time_score_int] (
		[company_id]        NVARCHAR (50) NULL,
		score_name			NVARCHAR (50) NULL,
		score_time			INT NULL,
		score_value         BIGINT        NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].company_time_score_int','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[company_time_score_real] (
		[company_id]        NVARCHAR (50) NULL,
		score_name			NVARCHAR (50) NULL,
		score_time			INT NULL,
		score_value         real        NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].company_time_score_real','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [questionnaire].[user_answer_checked](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[id_answer] [int] NOT NULL,
		[id_user_answer] [int] NOT NULL,
		[reference] [nvarchar](1000) NULL,
		[comment] [nvarchar](max) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	)
END TRY
BEGIN CATCH
	IF OBJECT_ID('[questionnaire].[user_answer_checked]','U') is null
		THROW;
END CATCH
GO
BEGIN TRY
	CREATE TABLE [questionnaire].[user_answer](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[bvd_id] [varchar](25) NOT NULL,
		[id_question] [int] NOT NULL,
		[is_latest] [bit] NOT NULL DEFAULT 1,
		[text_answer] [nvarchar](max) NULL,
		[added_on] [datetime2](7) NOT NULL DEFAULT getdate(),
		[added_by] [nvarchar](100) NULL,
		[status] [nvarchar](10) NULL,
		[reference] [nvarchar](1000) NULL,
		[comment] [nvarchar](max) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	)
END TRY
BEGIN CATCH
	IF OBJECT_ID('[questionnaire].[user_answer]','U') is null
		THROW;
END CATCH
GO
BEGIN TRY
	CREATE TABLE [questionnaire].[tab](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[label] [nvarchar](25) NOT NULL,
		[default_state] [int] NOT NULL DEFAULT 0,
		[editable_on_tab_finish] [nvarchar](50) NULL,
	 CONSTRAINT [PK_tab] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	)
END TRY
BEGIN CATCH
	IF OBJECT_ID('[questionnaire].[tab]','U') is null
		THROW;
END CATCH
GO
BEGIN TRY
	CREATE TABLE [questionnaire].[question_tab](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[question_id] [int] NOT NULL,
		[tab_id] [int] NOT NULL,
		[sequence] [int] NOT NULL DEFAULT 0,
	 CONSTRAINT [PK_question_tab] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	)
END TRY
BEGIN CATCH
	IF OBJECT_ID('[questionnaire].[question_tab]','U') is null
		THROW;
END CATCH
GO
BEGIN TRY
	CREATE TABLE [questionnaire].[question](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[input_type] [varchar](15) NOT NULL,
		[data_type] [varchar](15) NOT NULL,
		[label] [nvarchar](500) NOT NULL,
		[sidenote] [nvarchar](max) NULL,
		[score_name] [nvarchar](50) NOT NULL,
		[default_value] [nvarchar](150) NULL,
		[order] [smallint] NOT NULL,
		[is_linked] [bit] NOT NULL,
		[required] [bit] NOT NULL DEFAULT 1,
		[show_reference] [bit] NOT NULL DEFAULT 0,
		[show_comment] [bit] NOT NULL DEFAULT 0,
		[show_in_longlist] [bit] NOT NULL DEFAULT 0,
	PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[questionnaire].[question]','U') is null
		THROW;
END CATCH
GO
BEGIN TRY
	CREATE TABLE [questionnaire].[faq](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[tab_ids] [varchar](50) NULL,
		[question] [nvarchar](250) NOT NULL,
		[answer_html] [nvarchar](max) NOT NULL,
	 CONSTRAINT [PK_questionnaire_faq] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[questionnaire].[faq]','U') is null
		THROW;
END CATCH
GO
BEGIN TRY
	CREATE TABLE [questionnaire].[company_tab](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[bvd_id] [nvarchar](25) NOT NULL,
		[tab_id] [int] NOT NULL,
		[state] [int] NOT NULL DEFAULT 0,
	 CONSTRAINT [PK_company_tab] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[questionnaire].[company_tab]','U') is null
		THROW;
END CATCH
GO
BEGIN TRY
	CREATE TABLE [questionnaire].[answer](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[question_id] [int] NOT NULL,
		[text] [nvarchar](500) NOT NULL,
		[value] [nvarchar](150) NOT NULL,
		[order] [smallint] NOT NULL,
		[linked_questions] [nvarchar](200) NULL,
		[report_text] [nvarchar](500) NULL,
		[show_reference] [bit] NOT NULL DEFAULT 0,
		[show_comment] [bit] NOT NULL DEFAULT 0,
	PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[questionnaire].[answer]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[focus_list] (
		[focuslist_id] INT   NOT NULL IDENTITY(1,1) PRIMARY KEY
		,[label] nvarchar(255) NOT NULL
		,[created_by] nvarchar(50) not null
		,[created_on] datetime not null
		,[status] nvarchar(15) not null default 'open'
		,[comment] nvarchar(500)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[focus_list]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[focus_list_company]
	(
		[id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
		[focuslist_id] INT NULL, 
		company_id NVARCHAR(50) NULL
	)
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[focus_list_company]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[ls_node] (
		node_key        int not null,
		node_id			NVARCHAR (100) NOT NULL,
		node_retrieval_key NVARCHAR(50) NULL,
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].ls_node','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[ls_node_list_item](
		[node_key] INT NOT NULL -- the identifier of the landscape node
		, item_type nvarchar(50) not null -- the type of items that can be retrieved; 'company', 'patent' but also other things
		, item_rank smallint not null -- in the case of ranked items, this column can be used
		, item_id nvarchar(100) null -- the internal identifier of this item; could be BvD ID for companies or publication number of patents; this may also be used 'in reverse' to look for other CPC classes a patent is assigned to.
		, item_attribute nvarchar(100) not null -- the various columns for the item enumeration: 'Title',  'Filing date' for patents, 'website', 'company name' for companies
		, item_value nvarchar(max) null -- the value for each item per column
		, primary key (node_key, item_type, item_rank,item_attribute)
	)
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[ls_node_list_item]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[ls_node_position] (
		node_key        int not null,
		node_id			NVARCHAR (100) NOT NULL,
		node_x	REAL NOT NULL,
		node_y	REAL NOT NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].ls_node_position','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[ls_node_property_numeric] (
		node_key        int not null,
		node_property_type			NVARCHAR (150) NOT NULL,
		node_property_value numeric(30,10) NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].ls_node_property_numeric','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[ls_node_property_str] (
		node_key        int not null,
		node_property_type			NVARCHAR (150) NOT NULL,
		node_property_value nvarchar(max) NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].ls_node_property_str','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[ls_node_score_numeric]
	(
		node_key INT NOT NULL
		, node_score_group nvarchar(100) not null
		, node_score_series_group nvarchar(100) null
		, node_score_series_key nvarchar(100) not null
		, node_score_view nvarchar(100) null
		, node_score_value numeric(30,10) not null
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].ls_node_score_numeric','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[ls_node_score_str]
	(
		node_key INT NOT NULL
		, node_score_group nvarchar(100) not null
		, node_score_series_group nvarchar(100) null
		, node_score_series_key nvarchar(100) not null
		, node_score_view nvarchar(100) null
		, node_score_value nvarchar(max) not null
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].ls_node_score_str','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[manual_scoring_action]
	(
		[id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY
		, score_label nvarchar(100) NOT NULL
		, scoring_string nvarchar(max)
		, executed_on datetime NOT NULL DEFAULT GETDATE()
		, executed_by nvarchar(100)
		, [status] nvarchar(10)
		, modified_on datetime
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].manual_scoring_action','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[scored_company](
		[company_id]		NVARCHAR (50)	NOT NULL,
		[score_id]			INT				NOT NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].scored_company','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[series_properties] (
		[series_id]         INT            IDENTITY (1, 1) NOT NULL,
		[SeriesToPlot_NAME] NVARCHAR (100) NOT NULL,
		[stroke_color]      NVARCHAR (15)  NULL,
		[fill_color]        NVARCHAR (15)  NULL,
		[fill_override]     TINYINT        NULL,
		PRIMARY KEY CLUSTERED ([series_id] ASC)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[series_properties]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[tile_attribute] (
		[id]                        INT            IDENTITY (1, 1) NOT NULL,
		[tile_id]                   SMALLINT       NOT NULL,
		[tile_name]                 NVARCHAR (50)  NULL,
		[bvd_id]                    VARCHAR (50)   NOT NULL,
		[company_name]              NVARCHAR (150) NULL,
		[attribute_name]            NVARCHAR (500) NOT NULL,
		[attribute_seq]             SMALLINT       NOT NULL,
		[attribute_value]           NVARCHAR (MAX) NULL,
		[attribute_benchmark_value] NVARCHAR (MAX) NULL,
		[attribute_link]            NVARCHAR (500) NULL,
		PRIMARY KEY CLUSTERED ([tile_id] ASC, [bvd_id] ASC, [attribute_seq] ASC)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[tile_attribute]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[tile_event_stream] (
		[id]                  INT            IDENTITY (1, 1) NOT NULL,
		[tile_id]             SMALLINT       NOT NULL,
		[tile_name]           NVARCHAR (50)  NULL,
		[bvd_id]              VARCHAR (50)   NOT NULL,
		[company_name]        NVARCHAR (150) NULL,
		[event_id]            NVARCHAR (100) NOT NULL,
		[event_seq]           SMALLINT       NULL,
		[event_attribute]     NVARCHAR (25)  NOT NULL,
		[event_attribute_seq] SMALLINT       NOT NULL,
		[event_value]         NVARCHAR (MAX) NULL,
		[event_date]          DATE           NULL,
		[event_type]          NVARCHAR (25)  NULL,
		PRIMARY KEY CLUSTERED ([tile_id] ASC, [bvd_id] ASC, [event_id] ASC, [event_attribute_seq] ASC)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[tile_event_stream]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[tile_profile] (
		[id]             INT             IDENTITY (1, 1) NOT NULL,
		[tile_id]        SMALLINT        NOT NULL,
		[tile_name]      NVARCHAR (50)   NULL,
		[bvd_id]         VARCHAR (50)    NOT NULL,
		[company_name]   NVARCHAR (150)  NULL,
		[series_name]    NVARCHAR (100)  NOT NULL,
		[category]       NVARCHAR (100)  NOT NULL,
		[category_short] NVARCHAR (25)   NULL,
		[category_seq]   SMALLINT        NOT NULL,
		[series_value]   NUMERIC (30, 3) NULL,
		PRIMARY KEY CLUSTERED ([tile_id] ASC, [bvd_id] ASC, [series_name] ASC, [category_seq] ASC)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[tile_profile]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[tile_timeseries] (
		[id]           INT             IDENTITY (1, 1) NOT NULL,
		[tile_id]      SMALLINT        NOT NULL,
		[tile_name]    NVARCHAR (50)   NULL,
		[bvd_id]       VARCHAR (50)    NOT NULL,
		[company_name] NVARCHAR (150)  NULL,
		[series_name]  NVARCHAR (100)  NOT NULL,
		[series_x]     NUMERIC (30)    NOT NULL,
		[series_y]     NUMERIC (30, 3) NULL,
		[series_seq]   SMALLINT        NULL,
		PRIMARY KEY CLUSTERED ([tile_id] ASC, [bvd_id] ASC, [series_name] ASC, [series_x] ASC)
	);	
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[tile_timeseries]','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [custom].[ls_node_property_numeric] (
		node_key        int not null,
		node_property_type			NVARCHAR (150) NOT NULL,
		node_property_value numeric(30,10) NULL
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[custom].ls_node_property_numeric','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [custom].[ls_node_score_numeric]
	(
		node_key INT NOT NULL
		, node_score_group nvarchar(100) not null
		, node_score_series_group nvarchar(100) null
		, node_score_series_key nvarchar(100) not null
		, node_score_view nvarchar(100) null
		, node_score_value numeric(30,10) not null
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[custom].ls_node_score_numeric','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[longlist_histograms]
	(
		score_label nvarchar(50) not null
	);
	INSERT INTO [dbo].[longlist_histograms] VALUES('Industry'),('Country')
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].longlist_histograms','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	CREATE TABLE [dbo].[longlist_column_groups] (
	    [score_label]       NVARCHAR (100) NOT NULL,
	    [column_group_name] NVARCHAR (50)  NOT NULL,
	    [default_visible]   TINYINT        DEFAULT ((1)) NOT NULL,
	    PRIMARY KEY CLUSTERED ([score_label] ASC, [column_group_name] ASC)
	);
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].longlist_column_groups','U') is null
		THROW;
END CATCH
GO

BEGIN TRY
	exec(N'CREATE FUNCTION [dbo].[onFocusList]( @company_id nvarchar(25), @focuslist_id int) RETURNS tinyint
	AS
	BEGIN

		declare @n int
		declare @r tinyint
		set @n = (SELECT COUNT(*) FROM [dbo].focus_list_company where company_id=@company_id and focuslist_id=@focuslist_id)
		IF @n>0
			SET @r = 1
		ELSE
			SET @r = 0

		RETURN @r
	END')
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].onFocusList','FN') is null
		THROW;
END CATCH
GO

BEGIN TRY
	IF OBJECT_ID('[dbo].[DEF_COMPANYLONGLIST_FILTERS]','U') is not null
		DROP TABLE [dbo].[DEF_COMPANYLONGLIST_FILTERS]
		
	exec(N'CREATE view [dbo].[DEF_COMPANYLONGLIST_FILTERS] as
		select
			focuslist_id as id
			, label as [title]
			, concat(''[dbo].[onFocusList](companyPrimKey,'',cast(focuslist_id as nvarchar(10)),'')>0'') as [where]
		from
			[dbo].[focus_list]
		where
			[status]=''open''')
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[DEF_COMPANYLONGLIST_FILTERS]','V') is null
		THROW;
END CATCH
GO

BEGIN TRY
	IF OBJECT_ID('[dbo].[DEF_COLUMN_GROUPS]','U') is not null
		DROP TABLE [dbo].[DEF_COLUMN_GROUPS]
		
	exec(N'CREATE VIEW [dbo].[DEF_COLUMN_GROUPS]
			AS
		SELECT
			[score_generic_name]
			, ''Other'' as column_group_name
			, 0 as default_visible
		FROM
			company_score
		where
			score_label not in (select distinct score_label from longlist_column_groups)
			and
			score_label in (select score_label from company_score where display_in_fe=1)
		UNION ALL
		select
			score_generic_name
			, lcg.column_group_name
			, lcg.default_visible
		from
			longlist_column_groups lcg JOIN
			company_score cs ON cs.score_label=lcg.score_label')
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[DEF_COLUMN_GROUPS]','V') is null
		THROW;
END CATCH
GO

BEGIN TRY
	exec(N'CREATE PROCEDURE [dbo].[web_getLonglistStats](@whereClause nvarchar(max)=''1>0'' ) AS
	
	IF(len(@whereClause)=0)
		set @whereClause = ''1>0''

	declare @sql nvarchar(max)
	set @sql = '' SELECT '' +
	''COUNT(*) AS ''''Total # Companies''''''+
	''from '' +
	''DIM_COMPANYLONGLIST_WEB'' +
	'' union all '' +
	'' SELECT '' +
	''COUNT(*) AS ''''Total # Companies''''''+
	''from '' +
		''DIM_COMPANYLONGLIST_WEB '' + 
		''WHERE '' + @whereClause

	exec(@sql)')
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[web_getLonglistStats]','P') is null
		THROW;
END CATCH
GO


BEGIN TRY
	exec(N'CREATE PROCEDURE [dbo].[web_getIpcCompanies](@ipc INT) as
		select
			[Name],[# Families in Class],[Total # Families],item_id as [Company ID]
		from
			(select
				[item_rank]
				, [item_id]
				, [item_attribute]
				, item_value
			from
				[dbo].[ls_node_list_item]
			where
				item_type = ''Company''
				and
				node_key=@ipc
			) p
		pivot(
			max(item_value) for item_attribute in ([Name],[# Families in Class],[Total # Families])
		) pvt
		order by
			[item_rank] asc')
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[web_getIpcCompanies]','P') is null
		THROW;
END CATCH
GO


BEGIN TRY
	exec(N'CREATE PROCEDURE [dbo].[web_getIpcLatestCeDocuments](
		@ipc INT
		, @ww nvarchar(100)	= ''cellulose ester\"OR\"cellulose acetate'' ) AS
		declare @w nvarchar(102);
		set @w = ''\"'' + @ww + ''\"'';

		select
			item_id as [Publication number]
			, [Title]
			, [Filing year]
		from
			(select
				[item_rank]
				, [item_id]
				, [item_attribute]
				, item_value
			from
				[dbo].[ls_node_list_item]
			where
				item_type = ''Patent''
				and
				node_key=@ipc
			) p
		pivot(
			max(item_value) for item_attribute in ([Title],[Filing year])
		) pvt
		order by
			[item_rank] asc')
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[web_getIpcLatestCeDocuments]','P') is null
		THROW;
END CATCH
GO

BEGIN TRY
	exec(N'CREATE PROCEDURE [dbo].[web_getLonglistHistograms](@whereClause nvarchar(max)=''1>0'') AS 
		declare @sql nvarchar(max)
		declare @thisScore nvarchar(50);
		declare @thisGenericName nvarchar(15);
		declare @ss table(score_name nvarchar(50), generic_name nvarchar(15))
		declare @ns smallint
		insert into @ss select lh.score_label, cs.score_generic_name from [dbo].[longlist_histograms] lh JOIN company_score cs ON cs.score_label=lh.score_label
		set @ns = (select count(*) from @ss)

		IF(@ns > 0)
		BEGIN
			set @thisScore = (select top 1 score_name from @ss)
			set @thisGenericName = (select generic_name from @ss where score_name=@thisScore)

			set @sql = N''select
				''''''+@thisScore+'''''' as [histogram]
				, ''+@thisGenericName+'' as [category]
				, count(*) as [value]
				, '' + case when @thisScore = ''Industry'' then ''1'' else ''1'' end +'' as [flex]
				, rank() over (order by count(*) desc) as r
			from
				[dbo].[DIM_COMPANYLONGLIST_WEB]
			where
				''+@whereClause+''
				and
				''+@thisGenericName+'' is not null
			group by
				''+@thisGenericName

			delete from @ss where score_name = @thisScore
			set @ns = (select count(*) from @ss)
		END

		WHILE @ns > 0
		BEGIN
			set @thisScore = (select top 1 score_name from @ss)
			set @thisGenericName = (select generic_name from @ss where score_name=@thisScore)

			set @sql = @sql + N'' union all select
				''''''+@thisScore+'''''' as [histogram]
				, ''+@thisGenericName+'' as [category]
				, count(*) as [value]
				, '' + case when @thisScore = ''Industry'' then ''1'' else ''1'' end +'' as [flex]
				, rank() over (order by count(*) desc) as r
			from
				[dbo].[DIM_COMPANYLONGLIST_WEB]
			where
				''+@whereClause+''
				and
				''+@thisGenericName+'' is not null
			group by
				''+@thisGenericName

			delete from @ss where score_name = @thisScore
			set @ns = (select count(*) from @ss)
		END

		print(@sql)
		exec(''select histogram, category, [value],[flex] from (''+@sql+'')a where r<=15 order by [histogram] asc, [value] desc'')
	')
END TRY
BEGIN CATCH
	IF OBJECT_ID('[dbo].[web_getLonglistHistograms]','P') is null
		THROW;
END CATCH
GO