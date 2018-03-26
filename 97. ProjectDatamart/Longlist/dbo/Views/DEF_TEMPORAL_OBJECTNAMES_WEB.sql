create view dbo.[DEF_TEMPORAL_OBJECTNAMES_WEB] as
select
 score_id as [objNamePrimKey]
 ,'a' + right([score_generic_name],5) as [objectGenericName]
 ,'column' as [objectType]
 , 'DIM_COMPANYLONGLIST' as [hostTableName]
 ,score_label as [objectLabel]
 ,is_numeric as [isNumeric]
 ,display_in_fe as [displayInFE]
 ,column_order as [columnOrder]
 ,flex_width as [flexWidth]
 ,case when data_type='int'
  then 1
  else case when data_type='real'
   then 2
   else 3 end end as [dataType]
 ,default_scale as [defaultScale]
 ,precision as [precision]
 ,unit as [unit]
 ,uni_polar as [uniPolar]
from
 dbo.company_score where is_temporal=1