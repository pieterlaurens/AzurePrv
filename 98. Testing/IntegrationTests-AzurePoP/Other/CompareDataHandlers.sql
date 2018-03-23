DECLARE @deployment_server sysname = 'nlagpdatacore'
DECLARE @RC_ll_f int
DECLARE @RC_ll_h int
DECLARE @RC_ls_h int
DECLARE @RC_ls_x int
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ll_f nvarchar(100) = CONCAT(@solution, '_DthTest_LL_Felix')--'testPipeline'
DECLARE @projectkey_ll_h nvarchar(100) = CONCAT(@solution, '_DthTest_LL_Honeyrider')--'testPipeline'
DECLARE @projectkey_ls_h nvarchar(100) = CONCAT(@solution, '_DthTest_LS_Honeyrider')--'testPipeline'
DECLARE @projectkey_ls_x nvarchar(100) = CONCAT(@solution, '_DthTest_LS_Xenia')--'testPipeline'
DECLARE @json_sla_f nvarchar(max)
DECLARE @json_sla_x nvarchar(max)
DECLARE @json_sla_h nvarchar(max)
DECLARE @json_config_ll nvarchar(max)
DECLARE @json_config_ls nvarchar(max)

SET @json_sla_f = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_app_inh"
					, "DatahandlerDataSource": "NLAGPDATACORE"
					, "DatahandlerCatalog": "prv_app_dth"
					, "DatahandlerVersion": "felix"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_dthtest_felixenia"
				}'
SET @json_sla_x = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_app_inh"
					, "DatahandlerDataSource": "NLAGPDATACORE"
					, "DatahandlerCatalog": "prv_app_dth"
					, "DatahandlerVersion": "xenia"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_dthtest_felixenia"
				}'
SET @json_sla_h = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_app_inh"
					, "DatahandlerDataSource": "NLAGPDATACORE"
					, "DatahandlerCatalog": "prv_app_dth"
					, "DatahandlerVersion": "honeyrider"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_dthtest_honeyrider"
				}'

SET @json_config_ll = N'{"ComponentParams" : [ 
	{ }
	, {"RetrievalParams" : [
			 {
			"RetrievalType" : "CompanyList"
			, "RetrievalLabel" : "Tracey marked companies"
			, "CompanyId" : "USD305504941D|DE2010000581|US140689340|US941081436|CHCHE107136256|CHCHE110110814|CN30081PC|CN9360000140|DE2010000581|DE2010000581|DE2270172157|DE2270172157|DE4070280762|DE4290178888|DE5330000056|DE7150000030|DE7230336659|DE7330593711|DE8030366267|DE8030366267|DK32365590|FR41028670200056|FR443645551|FR443645551|FR445074685|FR49956881400051|FR49956881400051|FR49956881400051|GB01106260|GB01106260|GB03903306|GB03903306|GB03903306|IE389190|IL31714NU|IL31714NU|IL31714NU|ITMN0149665|ITMO0379518|JP000020437JPN|JP000030720JPN|JP000030797JPN|JP000090035JPN|JP042747717S|JP042747717S|JP130856896S|JP558828617S|KR1601110122880-2|NL14076998|NL14095340|SE5562889401|SE5565395356|US*1550089520|US060570975|US140689340|US222640650|US222640650|US461684608|US461684608|US942802192"
			},{"RetrievalType" : "CompanyTextBagOfWords"
				, "RetrievalLabel" : "AM in TD"
				, "NumberOfCompanies" : 500
				, "Normalize" : "Portfolio"
				, "BagOfWords" : "additive manuf*|3d print*"
			}
			, { "RetrievalType" : "PatentClassProfile"
				, "RetrievalLabel" : "CPC - 3D Printing"
				, "NumberOfCompanies" : 500
				, "Normalize" : "None"
				, "ClassProfile" : "A61C 13/0013:0.0263158|A61C 13/0019:0.0714286|B29C 67/0051:0.101852|B29C 67/0055:0.118367|B29C 67/0059:0.151961|B29C 67/0062:0.0584795|B29C 67/007:0.0201342|B29C 67/0074:0.0284091|B29C 67/0081:0.0941176|B29C 67/0085:0.105691|B29C 67/0088:0.209632|B29C 67/0092:0.0432432|B29C 67/0096:0.0649351|B33Y 80/00:0.207207|B33Y 70/00:0.163636|B33Y 30/00:0.14|B28B 01/001:0.0958084|G03B 35/14:0.108434|B22F 03/008:0.0514706|C04B /6026:0.02"
			}
			, { "RetrievalType" : "PatentClassProfile"
				, "RetrievalLabel" : "CPC - AM"
				, "NumberOfCompanies" : 500
				, "Normalize" : "None"
				, "ClassProfile" : "A61F /30962:0.0860215|B22F 03/008:0.176471|B22F /1056:0.132184|B22F /1057:0.235849|B22F /1058:0.323529|B22F /1059:0.205882|B22F 05/009:0.125|B22F 05/04:0.127273|B28B 01/001:0.11976|B29C 67/0051:0.12963|B29C 67/0055:0.138776|B29C 67/0077:0.117318|B29C 67/0085:0.184282|B29C 67/0088:0.164306|B33Y 30/00:0.22|B33Y 70/00:0.127273|B33Y 80/00:0.297297|B23K 15/0086:0.149068|F16C /46:0.0869565|F05D /22:0.0972222"
			}
			, { "RetrievalType" : "PatentClassProfile"
				, "RetrievalLabel" : "CPC - SLS"
				, "NumberOfCompanies" : 500
				, "Normalize" : "None"
				, "ClassProfile" : "A61C 13/0018:0.0235294|A61F /30962:0.0215054|B22F 03/004:0.0266667|B22F 03/008:0.0367647|B22F /1056:0.0545977|B22F /1057:0.0566038|B22F /1059:0.0588235|B23K 15/0086:0.0248447|B23K 26/34:0.0202703|B28B 01/001:0.0359281|B29C 67/0051:0.0162037|B29C 67/0077:0.0927374|B29C 67/0096:0.038961|B29C 67/04:0.0248447|B33Y 80/00:0.018018|C04B /6026:0.06|C04B /665:0.0642857|F16C /46:0.0434783|G05B 19/4099:0.017284|G05B /49018:0.24"
			}
			, { "RetrievalType" : "PatentClassProfile"
				, "RetrievalLabel" : "CPC - AM Specific"
				, "NumberOfCompanies" : 500
				, "Normalize" : "None"
				, "ClassProfile" : "B33Y 30/00:0.32|B33Y 70/00:0.254545|B33Y 80/00:0.423423"
			}
		]
		}
	, { "ScoringParams" : [
			{"ScoringType" : "OrbisAttribute"
			, "ScoringLabel" : "Country"
			, "AttributeName" : "country"
			},{
			"ScoringType" : "OrbisAttribute"
			, "ScoringLabel" : "Age"
			, "AttributeName" : "age"
			},{
			"ScoringType" : "OrbisAttribute"
			, "ScoringLabel" : "Number of Patents"
			, "AttributeName" : "number_of_patents"
			},{
			"ScoringType" : "OrbisAttribute"
			, "ScoringLabel" : "GUO"
			, "AttributeName" : "guo_name"
			},{
			"ScoringType" : "OrbisAttribute"
			, "ScoringLabel" : "Segment"
			, "AttributeName" : "company_category"
			},{
			"ScoringType" : "IndustryAttribute"
			, "ScoringLabel" : "Industry"
			},{
			"ScoringType" : "CompanyTextBagOfWords"
			, "ScoringLabel" : "Business - AM"
			, "Normalize" : "Portfolio"
			, "BagOfWords" : "additive manuf*|3d print*"
			},{
			"ScoringType" : "PatentClassProfile"
			, "ScoringLabel" : "IP - 3D Printing"
			, "Normalize" : "Portfolio"
			, "ClassProfile" : "A61C 13/0013:0.0263158|A61C 13/0019:0.0714286|B29C 67/0051:0.101852|B29C 67/0055:0.118367|B29C 67/0059:0.151961|B29C 67/0062:0.0584795|B29C 67/007:0.0201342|B29C 67/0074:0.0284091|B29C 67/0081:0.0941176|B29C 67/0085:0.105691|B29C 67/0088:0.209632|B29C 67/0092:0.0432432|B29C 67/0096:0.0649351|B33Y 80/00:0.207207|B33Y 70/00:0.163636|B33Y 30/00:0.14|B28B 01/001:0.0958084|G03B 35/14:0.108434|B22F 03/008:0.0514706|C04B /6026:0.02"
			},{
			"ScoringType" : "PatentClassProfile"
			, "ScoringLabel" : "IP - AM"
			, "Normalize" : "Portfolio"
			, "ClassProfile" : "A61F /30962:0.0860215|B22F 03/008:0.176471|B22F /1056:0.132184|B22F /1057:0.235849|B22F /1058:0.323529|B22F /1059:0.205882|B22F 05/009:0.125|B22F 05/04:0.127273|B28B 01/001:0.11976|B29C 67/0051:0.12963|B29C 67/0055:0.138776|B29C 67/0077:0.117318|B29C 67/0085:0.184282|B29C 67/0088:0.164306|B33Y 30/00:0.22|B33Y 70/00:0.127273|B33Y 80/00:0.297297|B23K 15/0086:0.149068|F16C /46:0.0869565|F05D /22:0.0972222"
			},{
			"ScoringType" : "PatentClassProfile"
			, "ScoringLabel" : "IP - SLS"
			, "Normalize" : "Portfolio"
			, "ClassProfile" : "A61C 13/0018:0.0235294|A61F /30962:0.0215054|B22F 03/004:0.0266667|B22F 03/008:0.0367647|B22F /1056:0.0545977|B22F /1057:0.0566038|B22F /1059:0.0588235|B23K 15/0086:0.0248447|B23K 26/34:0.0202703|B28B 01/001:0.0359281|B29C 67/0051:0.0162037|B29C 67/0077:0.0927374|B29C 67/0096:0.038961|B29C 67/04:0.0248447|B33Y 80/00:0.018018|C04B /6026:0.06|C04B /665:0.0642857|F16C /46:0.0434783|G05B 19/4099:0.017284|G05B /49018:0.24"
			},{
			"ScoringType" : "PatentClassProfile"
			, "ScoringLabel" : "IP - Specific AM"
			, "Normalize" : "Portfolio"
			, "ClassProfile" : "B33Y 30/00:0.32|B33Y 70/00:0.254545|B33Y 80/00:0.423423"
			}
		]
		}
	, { 	"LongListFilters":"... with >10 patents: [Number of Patents] > 10" }
		]}' 
SET @json_config_ls = N'{"ComponentParams" : [ 
	{ }
	, { "NodeSelectionParams" :[
		{"NodeSelectionType" : "NodeList"
		, "NodeSelectionLabel" : "Original Node List"
		, "NodeList" : "A61C 07/002|A61C 09/0053|A61C 13/0004|A61C 13/0013|A61C 13/0018|A61C 13/0019|A61F /30948|A61F /30952|A61F /30957|A61F /30962|A61F 02/28|A61F 02/2803|A61F 02/30942|A61L 27/56|B22C 07/02|B22C 09/04|B22F /00|B22F /10|B22F /1056|B22F /1057|B22F /1058|B22F /1059|B22F /248|B22F 03/003|B22F 03/004|B22F 03/008|B22F 03/105|B22F 03/1055|B22F 03/15|B22F 03/24|B22F 05/00|B22F 05/009|B22F 05/04|B22F 05/10|B22F 07/02|B22F 07/06|B23K /001|B23K 09/04|B23K 15/0086|B23K 26/127|B23K 26/34|B23K 35/0244|B23P 06/007|B28B 01/001|B29C /0838|B29C /9259|B29C /92704|B29C /92895|B29C 33/3842|B29C 33/3857|B29C 41/12|B29C 41/36|B29C 47/0011|B29C 47/0014|B29C 47/0866|B29C 47/92|B29C 67/00|B29C 67/0051|B29C 67/0055|B29C 67/0059|B29C 67/0062|B29C 67/0066|B29C 67/007|B29C 67/0074|B29C 67/0077|B29C 67/0081|B29C 67/0085|B29C 67/0088|B29C 67/0092|B29C 67/0096|B29C 67/04|B29D 11/00432|B29K /00|B29K /0073|B29K /251|B29L /00|B29L /7532|B33Y 10/00|B33Y 30/00|B33Y 40/00|B33Y 50/00|B33Y 50/02|B33Y 70/00|B33Y 80/00|B41J 03/4073|B82Y 30/00|C01B 33/037|C04B /6026|C04B /665|C04B 35/111|C04B 35/64|C04B 40/0039|C08J 05/00|C08J 07/04|C08K /003|C08K /011|C08K /0806|C08K 03/04|C08K 03/34|C08K 05/14|C08K 05/526|C08K 05/5425|C08K 13/02|C08L /025|C08L /08|C08L 23/08|C08L 23/12|C08L 23/14|C08L 25/12|C08L 33/08|C08L 53/00|C08L 63/00|C08L 67/025|C08L 75/16|C09D 11/101|C21D 01/09|C22B 09/226|C22B 09/228|C22B 34/1295|C22B 34/14|C22B 34/24|C22C 01/0416|C22C 01/045|C22C 14/00|C22C 19/03|C22C 19/056|C22C 19/07|C22C 32/0026|C22F 01/183|C23C 04/08|C23C 04/12|C23C 04/127|C23C 10/30|C23C 10/60|C23C 14/246|C23C 14/30|C23C 14/3414|C23C 16/4418|C23C 16/513|C23C 18/14|C23C 24/08|C23C 24/10|C23C 26/02|C25D 01/00|F01D 05/005|F01D 05/147|F01D 05/187|F05D /22|F05D /30|F05D /31|F16C /46|F16C 33/64|G01N 29/30|G02B 27/2214|G03B 35/14|G03F 07/0037|G03F 07/027|G03F 07/038|G03G 09/0819|G05B /49008|G05B /49018|G05B 15/02|G05B 19/4099|G06F /02|G06F /04806|G06F /06|G06F /34|G06F /42|G06F 03/0481|G06F 03/04812|G06F 03/04815|G06F 03/0482|G06F 03/04842|G06F 03/04845|G06F 03/0488|G06F 03/04883|G06F 09/4443|G06F 17/30241|G06F 17/50|G06F 17/5004|G06F 17/5009|G06F 17/5018|G06F 17/5022|G06F 17/5045|G06F 17/5086|G06F 17/509|G06Q 10/06|G06T /004|G06T /012|G06T /04|G06T /2004|G06T /2008|G06T /2016|G06T /2021|G06T /2024|G06T /24|G06T /61|G06T 11/00|G06T 11/001|G06T 11/203|G06T 11/206|G06T 11/60|G06T 13/00|G06T 13/20|G06T 13/40|G06T 15/005|G06T 15/04|G06T 15/20|G06T 15/50|G06T 15/503|G06T 17/00|G06T 17/005|G06T 17/05|G06T 17/10|G06T 17/20|G06T 17/30|G06T 19/00|G06T 19/003|G06T 19/20|G09B 23/30|G11B /213|G11B /2545|G11B /415|G11B /90|G11B 27/032|G11B 27/034|G11B 27/34|H01J 37/305|H01J 37/3053|H04N 09/75|H04R /77|H04R 25/652|H04R 25/658|H05K 03/426|Y02E 60/122|Y02W 30/54|Y10S 707/99943|Y10S 707/99944|Y10S 707/99945|Y10S 715/964|Y10T 428/24802"
		}
		] }
	, { "ScoreLandscapeNodesParams" :[{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Relevant Companies"
		, "Normalize" : "None"
		, "CompanyId" : "USD305504941D|DE2010000581|US140689340|US941081436"
		},{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Relevant Companies"
		, "Normalize" : "Class"
		, "CompanyId" : "USD305504941D|DE2010000581|US140689340|US941081436"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Additive manufacturing"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "additive manufact*|3d print*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Additive manufacturing"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "additive manufact*|3d print*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Selective Laser Sintering"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "selective~laser~sinter*|sls"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Selective Laser Sintering"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "selective~laser~sinter*|sls"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "UV Photo Curable"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "uv~photo~cur*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "UV Photo Curable"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "uv~photo~cur*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Fused Deposition Modeling"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "fused~deposition~model*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Fused Deposition Modeling"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "fused~deposition~model*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Stereo Lithography"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "stereo~lithograph*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Stereo Lithography"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "stereo~lithograph*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Electron Beam Melting"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "electron~beam~melt*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Electron Beam Melting"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "electron~beam~melt*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Binder Jetting"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "binder~jet*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Binder Jetting"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "binder~jet*"
		}]
		}
	, { "GetNodePropertiesParams" :[
		{"PropertyLabel" : "Label"
		, "PropertyMethod" : "TechnologyClassLabel"
		},{"PropertyLabel" : "Extended Label"
		, "PropertyMethod" : "TechnologyClassExtendedLabel"
		},{"PropertyLabel" : "Technology Class"
		, "PropertyMethod" : "NodeId"
		},{"PropertyLabel" : "Size"
		, "PropertyMethod" : "TechnologyClassSize"
		},{"PropertyLabel" : "Trend"
		, "PropertyMethod" : "TechnologyTrendRelativeToLandscape"
		},{"PropertyLabel" : "High Level Label"
		, "PropertyMethod" : "HighLevelTechnologyLabel"
		, "PropertyParameters" : "H04:Software|G06:Software|B41:Printing|B42:Printing|B43:Printing|B44:Printing|C09:Inks and Dyes|C07:Raw material|C08:Raw material|C2:Raw material|B2:Finished part|B33:Additive manufacturing"
		} ] }
	, { }
	, {
		"NormalizeDistance" : "none"
		, "RandomSeed" : 0
		, "MaxIterations" : 100
		, "Algorithm" : "MatlabMds"
		} 
	, { "LongListFilters":"... with >10 patents: [Number of Patents] > 10"}
	]}' 

/* ================================================
	3. Launch pipeline
   ================================================ */


EXECUTE @RC_ll_f = [ivh].[run_createNewRun] 
   @projectid = 1
  ,@projectkey = @projectkey_ll_f
  ,@solution = @solution
  ,@api = 'CreateLonglist'
  ,@json_sla = @json_sla_f
  ,@json_config = @json_config_ll
  ,@debug = 1

EXECUTE @RC_ll_h = [ivh].[run_createNewRun] 
   @projectid = 1
  ,@projectkey = @projectkey_ll_h
  ,@solution = @solution
  ,@api = 'CreateLonglist'
  ,@json_sla = @json_sla_h
  ,@json_config = @json_config_ll
  ,@debug = 1

WAITFOR DELAY '00:00:30'; -- to avoid the two interfering too much.

EXECUTE @RC_ls_x = [ivh].[run_createNewRun] 
   @projectid = 1
  ,@projectkey = @projectkey_ls_x
  ,@solution = @solution
  ,@api = 'CreateLandscape'
  ,@json_sla = @json_sla_x
  ,@json_config = @json_config_ls
  ,@debug = 1

EXECUTE @RC_ls_h = [ivh].[run_createNewRun] 
   @projectid = 1
  ,@projectkey = @projectkey_ls_h
  ,@solution = @solution
  ,@api = 'CreateLandscape'
  ,@json_sla = @json_sla_h
  ,@json_config = @json_config_ls
  ,@debug = 1