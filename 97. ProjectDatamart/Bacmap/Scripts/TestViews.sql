truncate table [bacmap].custom_mapping
truncate table [bacmap].[line_item_custom_mapping]

insert into [bacmap].custom_mapping([custom_mapping_label]) VALUES('Severe disease'),('Irrelevant')
select * from [bacmap].custom_mapping
insert into [bacmap].[line_item_custom_mapping] (line_item_id,period_id,custom_mapping_id,revenue_fraction,modified_by,added_on) VALUES
	('5EBFD176B7008E3236EB74A23FD189DF','6A9744F679A74509AD55C7491D78A060','CE12AA0531811A62A298E9C35649FE25',1,'PL',getdate())
	,('D86929817B5B8F18C5EF39D210C9DBB2','6A9744F679A74509AD55C7491D78A060','46B380986D995CF716D843908821AECB',1,'PL',getdate())
	,('C97633DAA4507CE0D4AA13FDFF394FE6','6A9744F679A74509AD55C7491D78A060','CE12AA0531811A62A298E9C35649FE25',1,'PL',getdate())