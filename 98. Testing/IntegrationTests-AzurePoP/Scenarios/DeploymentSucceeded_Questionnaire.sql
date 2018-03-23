USE [prv_prj_deploytest]
GO

TRUNCATE TABLE questionnaire.user_answer_checked
DELETE FROM questionnaire.user_answer
DELETE FROM questionnaire.question
DELETE FROM questionnaire.answer

-- Assume Questionnaire is currently empty.
:setvar DeploymentServer "equip-pop-vm"

SET IDENTITY_INSERT questionnaire.answer OFF
SET IDENTITY_INSERT questionnaire.question ON
INSERT INTO questionnaire.question(id,input_type,data_type,label,score_name,[order],[is_linked]) values(1,'FreeInput','nvarchar','Why is this company suitable?','Q001 Why is it suitable',1,0)
INSERT INTO questionnaire.question(id,input_type,data_type,label,score_name,[order],[is_linked]) values(2,'SingleSelect','nvarchar','In which segment is this company?','Q002 Segment',2,0)
INSERT INTO questionnaire.question(id,input_type,data_type,label,score_name,[order],[is_linked]) values(3,'MultiSelect','nvarchar','In which Industries is this company active?','Q003 Industries',3,0)
INSERT INTO questionnaire.question(id,input_type,data_type,label,score_name,[order],[is_linked]) values(4,'FreeInput','nvarchar','Whats the meaning of life?','Q004 Life meaning',1,0)
SET IDENTITY_INSERT questionnaire.question OFF

SET IDENTITY_INSERT questionnaire.answer ON
INSERT INTO questionnaire.answer(id,question_id,[text],[value],[order]) values(1,2,'Small-cap','Small-cap',1)
INSERT INTO questionnaire.answer(id,question_id,[text],[value],[order]) values(2,2,'Mid-cap','Mid-cap',2)
INSERT INTO questionnaire.answer(id,question_id,[text],[value],[order]) values(3,2,'Large-cap','Large-cap',3)

INSERT INTO questionnaire.answer(id,question_id,[text],[value],[order]) values(4,3,'Sustainable construction','Sustainable construction',1)
INSERT INTO questionnaire.answer(id,question_id,[text],[value],[order]) values(5,3,'Renewable energy','Renewable energy',2)
INSERT INTO questionnaire.answer(id,question_id,[text],[value],[order]) values(6,3,'Food for the poor','Food for the poor',3)
INSERT INTO questionnaire.answer(id,question_id,[text],[value],[order]) values(7,3,'Water engineering','Water engineering',4)

use prv_dev_inh;

DECLARE @deployment_server sysname = '$(DeploymentServer)'
DECLARE @RC int
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_sa nvarchar(100) = CONCAT(@solution, '_Test_AnswerQuestion')--'testPipeline'

:setvar Q "'"

DECLARE @json_sla nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeploySla.json"
	$(Q)
SET @json_sla = REPLACE(@json_sla,'DEPLOYMENT_SERVER',@deployment_server)

DECLARE @json_config_aq nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeployStoreAnswer.json"
	$(Q)

BEGIN
	EXECUTE @RC = [ivh].[run_createNewRun] 
		@projectid = 2
		,@projectkey = @projectkey_sa
		,@solution = @solution
		,@api = 'AnswerQuestion'
		,@json_sla = @json_sla
		,@json_config = @json_config_aq
		,@debug = 1
	SET @RC = (select max(id) from ivh.run)
END
	


print(concat('Questionnaire (run ',@RC,')'))

DECLARE @complete tinyint=0
while @complete = 0
begin
	set @complete = 1;
	SET @complete = (SELECT COUNT(*) FROM [nlh].[log] WHERE source_name='NotificationHandler.dtsx' AND [message] like concat('Run ',@RC,': Completed executable NotificationHandler'))

	-- print(concat('Complete: ',@complete))
	
	IF(@complete=0)
		WAITFOR DELAY '00:00:10';
end

select getdate()

-- Test report for SSIS execution
SELECT
	run_id
	, entry_point
	, e.added_on
	, et.name
	, et.[description]
FROM
	[ivh].[run_exectree] re JOIN
	[nlh].[event] e ON e.source_id=re.id JOIN
	[nlh].[event_type] et ON et.id=e.[type_id]
where
	run_id=@RC
order by
	e.added_on asc

-- Test report for the generated Datamart
SELECT
	*
	, CASE WHEN test_result='FAIL' THEN 'Content test failed' ELSE 'Content test passed' END AS [Specific test output]
FROM
	[prv_prj_deploytest].[report].[test_report]
WHERE
	run_id=@RC