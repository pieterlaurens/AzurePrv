CREATE PROCEDURE [dbo].GetTechnologyTopicsQuality AS

declare @lev int = 7;    -- CPC level at which to judge technology overlap
declare @nclass int = 25;-- Number of classes to use for comparing technologies

declare @ncompany int = 250; -- Number of companies to take into the bag in order to assess overlap (i.e. how many out of @ncompany are shared between technologies?)
declare @minportfolio int = 10; -- Minimal portfolio size of companies to consider for overlap; to offset a bias towards highly specialized/small companies
declare @selection nvarchar(10) = 'fraction'; -- {'fraction','portfolio'}

select
	t.technology_id
	, replace(label,'_',' ') as label
	, count(distinct inpadoc_family_id) as technology_size
from
	technology t JOIN
	technology_family tf ON tf.technology_id=t.technology_id
group by
	t.technology_id, label
order by
	t.technology_id

-- overlap of families in the various technologies
select
	at1.label
	, at2.label
	, at1.technology_id
	, at2.technology_id
	, count(distinct atf2.inpadoc_family_id) as n_overlap
from
	technology at1 JOIN
	technology_family atf1 ON atf1.technology_id=at1.technology_id JOIN
	technology_family atf2 ON atf1.inpadoc_family_id=atf2.inpadoc_family_id JOIN
	technology at2 ON at2.technology_id=atf2.technology_id
where
	at1.technology_id<=at2.technology_id
	--and
	--atf1.in_focus=1 and atf2.in_focus=1
group by
	at1.label, at2.label
	, at1.technology_id
	, at2.technology_id
order by
	at1.technology_id, at2.technology_id

-- overlap of the top 25 level 7 CPC classes per technology
;with tf AS (
	select
		technology_id
		, label
		, cpc_id
	from
		(select --top 10
			t.technology_id
			, label
			, fc.cpc_id
			, count(distinct fc.inpadoc_family_id) as n_families
			, cm.cpc_num_families_aggregate
			, cast(count(distinct fc.inpadoc_family_id) as real) / cast(cm.cpc_num_families_aggregate as real) as fraction_in_class
			, row_number() over (partition by label order by cast(count(distinct fc.inpadoc_family_id) as real) / cast(cm.cpc_num_families_aggregate as real) desc) as tech_rank
		from
			technology t JOIN
			technology_family atf ON atf.technology_id=t.technology_id JOIN
			[$(pw_v2016a_001)].patstat.family_cpc fc ON fc.inpadoc_family_id=atf.inpadoc_family_id JOIN
			[$(pw_v2016a_001)].patstat.cpc_lineage cl ON cl.cpc_child_id=fc.cpc_id JOIN
			[$(pw_v2016a_001)].patstat.cpc_metric cm ON cm.cpc_id=cl.cpc_ancestor_id
		where
			cl.cpc_ancestor_level=@lev
			--and
			--atf.in_focus=1
		group by
			t.technology_id
			, label
			, fc.cpc_id
			, cm.cpc_num_families_aggregate
		) a
	where
		tech_rank <= @nclass
	)
select
	tf1.label
	, tf2.label
	, tf1.technology_id as id1
	, tf2.technology_id as id2
	, count(distinct tf2.cpc_id) as n_shared_classes
from
	tf tf1 JOIN
	tf tf2 ON tf1.cpc_id=tf2.cpc_id
where
	tf1.technology_id<=tf2.technology_id
group by
	tf1.technology_id, tf2.technology_id, tf1.label
	, tf2.label
order by
	tf1.technology_id, tf2.technology_id

-- overlap in companies
;with tf AS (
	select
		technology_id
		, label
		, bvd_id
	from
		(select
			t.technology_id
			, label
			, fc.bvd_id
			, count(distinct fc.inpadoc_family_id) as families_in_portfolio
			, cm.number_of_families
			, cast(count(distinct fc.inpadoc_family_id) as real) / cast(cm.number_of_families as real) as fraction_in_portfolio
			, case when @selection='fraction'
				then row_number() over (partition by label order by cast(count(distinct fc.inpadoc_family_id) as real) / cast(cm.number_of_families as real) desc) 
				else case when @selection = 'portfolio'
					then row_number() over (partition by label order by count(distinct fc.inpadoc_family_id) desc)
				end end as tech_rank
		from
			technology t JOIN
			technology_family atf ON atf.technology_id=t.technology_id JOIN
			[$(pw_v2016a_001)].company.company_family fc ON fc.inpadoc_family_id=atf.inpadoc_family_id JOIN
			[$(pw_v2016a_001)].company.company_ip_metric cm ON cm.bvd_id=fc.bvd_id
		where
			cm.number_of_families >= @minportfolio
			--and
			--atf.in_focus=1
		group by
			t.technology_id
			, label
			, fc.bvd_id
			, cm.number_of_families
		) a
	where
		tech_rank <= @ncompany
	)
select
	tf1.label
	, tf2.label
	, tf1.technology_id
	, tf2.technology_id
	, count(distinct tf2.bvd_id) as n_shared_companies
from
	tf tf1 JOIN
	tf tf2 ON tf1.bvd_id=tf2.bvd_id
where
	tf1.technology_id <= tf2.technology_id
group by
	tf1.technology_id, tf2.technology_id, tf1.label, tf2.label