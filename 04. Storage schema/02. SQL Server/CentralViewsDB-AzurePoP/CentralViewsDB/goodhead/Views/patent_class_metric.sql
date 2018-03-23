CREATE VIEW [goodhead].[patent_class_metric]
	AS
	SELECT
		[cpc_id] as class_id
		,[cpc_code] as class_code
		,[cpc_num_families] as number_of_families
		,[cpc_num_families_aggregate] as aggregate_number_of_families
		,[cpc_hotness] as class_hotness
		,[cpc_hotness_aggregate] as aggregate_class_hotness
		,[cpc_num_families_period_current] as number_of_families_period_current
		,[cpc_num_families_period_current_aggregate] as number_of_families_period_current_aggregate
		,[cpc_num_families_period_reference] as number_of_families_period_reference
		,[cpc_num_families_period_reference_aggregate] as number_of_families_period_reference_aggregate
	FROM
		[$(pw_v2016a_001)].patstat.cpc_metric
