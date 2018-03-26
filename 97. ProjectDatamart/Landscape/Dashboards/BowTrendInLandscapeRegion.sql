--select * from ls_node

--use prv_prj_deploytest

--select distinct node_property_value from ls_node_property_str where node_property_type='High Level Label'

--select * from pw_v2016a_001.[company].[year_block]

declare @c table(cpc_id int primary key)
--insert into @c select node_key from ls_node_property_str where node_property_type='High Level Label' and node_property_value='Cement Fillers'
insert into @c select node_key from nlagpdatacore.prv_prj_deploytest.dbo.ls_node where node_id like 'c04b%'
--insert into @c select node_key from ls_node where node_id like 'E%'
--insert into @c select node_key from ls_node where left(node_id,7) in ('c04b 14','c04b 16','c04b 18','c04b 20')--,'c04b 22','c04b 24'

/*
select
	*
from
	pw_v2016a_001.patstat.family_cpc fc JOIN
	(select * from pw_v2016a_001.patstat.family_application_text where contains(([application_title],[application_abstract]),'near(("carbon*","mineral*"),3)')) fat ON fat.inpadoc_family_id=fc.inpadoc_family_id
where
	cpc_id in (select cpc_id from @c)
order by
	fc.cpc_first_date asc

*/
select
	y.y
	, count(distinct fc.inpadoc_family_id) /6 as in_area_filings
	, count(distinct fat.inpadoc_family_id) /6  as [Absolute # on topic]--on_topic_in_area_filings
	, y.number_of_filed_families_us
	, y.number_of_filed_families_band_us
	, ( cast(count(distinct fat.inpadoc_family_id) as real) / cast(count(distinct fc.inpadoc_family_id) as real) ) / avg( cast(count(distinct fat.inpadoc_family_id) as real) / cast(count(distinct fc.inpadoc_family_id) as real) ) over ( ) as on_topic_as_fraction_of_area
	, ( cast(count(distinct fc.inpadoc_family_id) as real) / cast(y.number_of_filed_families_band_us as real)  ) / avg( cast(count(distinct fc.inpadoc_family_id) as real) / cast(y.number_of_filed_families_band_us as real)  )  over ( )as [Technology area share]
	, ( cast(count(distinct fat.inpadoc_family_id) as real) / cast(y.number_of_filed_families_band_us as real)  ) / avg(cast(count(distinct fat.inpadoc_family_id) as real) / cast(y.number_of_filed_families_band_us as real)) over ( )as [On topic share]--on_topic_as_fraction_of_ww
from
	pw_v2016a_001.patstat.family_cpc fc LEFT OUTER JOIN
--	(select inpadoc_family_id from pw_v2016a_001.patstat.family_application_text where contains(([application_title],[application_abstract]),'"carbon*"')) fat ON fat.inpadoc_family_id=fc.inpadoc_family_id LEFT OUTER JOIN
--	(select inpadoc_family_id from pw_v2016a_001.patstat.family_application_text where contains(([application_title],[application_abstract]),'"fly ash" or "coal ash" or "fuel ash"')) fat ON fat.inpadoc_family_id=fc.inpadoc_family_id LEFT OUTER JOIN
	(select inpadoc_family_id from pw_v2016a_001.patstat.family_application_text where contains(([application_title],[application_abstract]),'near(("carbon*","mineral*"),6)')) fat ON fat.inpadoc_family_id=fc.inpadoc_family_id LEFT OUTER JOIN
	pw_v2016a_001.[company].[year_block] y ON year(fc.cpc_first_date) between y.[y_lower_band] and y.[y_upper_band]
where
	cpc_id in (select cpc_id from @c)
	and
	y.y is not null
--	y.y in (2014, 2012, 2010, 2008, 2006, 2004, 2002, 2000, 1998, 1996, 1994)
--	y.y in (2013, 2011, 2009, 2007, 2005, 2003, 2001, 1999, 1997, 1995, 1993)
group by
	y.y
	, y.number_of_filed_families_us
	, y.number_of_filed_families_band_us
order by
	y.y

/*
select
	y.y
	, count(distinct fc.inpadoc_family_id) as in_area_filings
	, count(distinct fat.inpadoc_family_id) as [Absolute # on topic]--on_topic_in_area_filings
from
	pw_v2016a_001.patstat.family_cpc fc LEFT OUTER JOIN
--	(select inpadoc_family_id from pw_v2016a_001.patstat.family_application_text where contains(([application_title],[application_abstract]),'"carbon*"')) fat ON fat.inpadoc_family_id=fc.inpadoc_family_id LEFT OUTER JOIN
--	(select inpadoc_family_id from pw_v2016a_001.patstat.family_application_text where contains(([application_title],[application_abstract]),'"fly ash" or "coal ash" or "fuel ash"')) fat ON fat.inpadoc_family_id=fc.inpadoc_family_id LEFT OUTER JOIN
	(select * from pw_v2016a_001.patstat.family_application_text where contains(([application_title],[application_abstract]),'near(("carbon*","mineral*"),6)')) fat ON fat.inpadoc_family_id=fc.inpadoc_family_id LEFT OUTER JOIN
	pw_v2016a_001.[company].[year_block] y ON year(fc.cpc_first_date) = y.y--y.[y_lower_band] and y.[y_upper_band]
where
	cpc_id in (select node_key from ls_node where node_id like 'c04b%')
group by
	y.y
	, y.number_of_filed_families_text
	, y.number_of_filed_families_band_text
order by
	y.y
*/

/*
select distinct top 100
	fat.inpadoc_family_id, fat.application_title, fat.application_abstract, frt.representative_publication , fm.*
from
	pw_v2016a_001.patstat.family_application_text fat JOIN
	pw_v2016a_001.patstat.family_metric fm ON fm.inpadoc_family_id=fat.inpadoc_family_id JOIN
	pw_v2016a_001.patstat.family_cpc fc ON fc.inpadoc_family_id=fat.inpadoc_family_id JOIN
	pw_v2016a_001.patstat.family_representative_text frt ON frt.inpadoc_family_id=fat.inpadoc_family_id
where
	contains(([application_title],[application_abstract]),'"fly ash"')
	and
	fc.cpc_id in (select cpc_id from pw_v2016a_001.patstat.cpc_entry where cpc_code like 'c04b%')
	and
	fm.family_citation>5
order by
	fm.priority_year asc
	, fm.family_citation desc
*/