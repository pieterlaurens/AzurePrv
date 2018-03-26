/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

--CREATE THE TABLE WITH ALLOWED USER ACTIONS

truncate table [report].[mapping_action_type]

insert into [report].[mapping_action_type](action_type_id,label,comment)
	values
		(1, 'add', '') ,
		(2, 'modify', '') ,
		(3, 'delete', '') ,
		(4, 'copy','')


truncate table [bacmap].[mapping_status]

insert into [bacmap].[mapping_status](id,label)
	values
		(0, 'NotStarted') ,
		(1, 'Started') ,
		(2, 'Completed') ,
		(3, 'Finished')
