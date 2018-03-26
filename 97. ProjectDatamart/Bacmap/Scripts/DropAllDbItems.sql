﻿--------------------------------------------------------------------------------
--WARNING: THIS SCRIPT DROPS ALL ITEMS IN THE CONNECTED DATABASE! 
--DO NOT EXECUTE AT RANDOM!!!
--------------------------------------------------------------------------------

declare @n char(2) = ', '
declare @stmt nvarchar(max)

-- procedures
select @stmt = isnull( @stmt + @n, '' ) +
   'drop procedure [' + schema_name(schema_id) + '].[' + 
   name-- + ']'
from sys.procedures

-- check constraints
select @stmt = isnull( @stmt + @n, '' ) +
'alter table [' + schema_name(schema_id) + '].[' + object_name( parent_object_id ) + ']    drop constraint [' + name + ']'
from sys.check_constraints

-- functions
select @stmt = isnull( @stmt + @n, '' ) +
    'drop function [' + schema_name(schema_id) + '].[' + name + ']'
from sys.objects
where type in ( 'FN', 'IF', 'TF' )

-- views
select @stmt = isnull( @stmt + @n, '' ) +
    'drop view [' + schema_name(schema_id) + '].[' + name + ']'
from sys.views

-- foreign keys
select @stmt = isnull( @stmt + @n, '' ) +
    'alter table [' + schema_name(schema_id) + '].[' + object_name( parent_object_id ) + '] drop constraint [' + name + ']'
from sys.foreign_keys

-- tables
select @stmt = isnull( @stmt + @n, '' ) +
    'drop table [' + schema_name(schema_id) + '].[' + name + ']'
from sys.tables

-- user defined types
select @stmt = isnull( @stmt + @n, '' ) +
    'drop type [' + schema_name(schema_id) + '].[' + name + ']'
from sys.types
where is_user_defined = 1


exec sp_executesql @stmt

------------------------------------------------------------------------
--truncate all tables
------------------------------------------------------------------------

declare @n2 char(2) = '; '
declare @stmt2 nvarchar(max)

select @stmt2 = isnull( @stmt2 + @n2, '' ) +
    'truncate table [' + schema_name(schema_id) + '].[' + name + ']'
from sys.tables

print @stmt2
exec sp_executesql @stmt2