CREATE TABLE hotness.[company]
(
	bvd_id varchar(25) NOT NULL
	, company_name nvarchar(500) NOT NULL
	, size_market_cap bigint NULL
	, size_revenue bigint NULL
	, size_employees bigint NULL
	, size_compound_rank real NULL
	
	, thematic_group varchar(50) NULL
	
	, total_volume int -- 1

	, on_topic_volume int -- 2
	, on_topic_fraction real -- 2
	, on_topic_volume_in_top_10pct int -- 2
	, on_topic_fraction_in_top_10pct real -- 2
	
	, frontier_volume int -- 3
	, frontier_fraction real -- 3
	, frontier_volume_in_top_10pct int -- 3
	, frontier_fraction_in_top_10pct real -- 3

	, hotness_avg_citations_over_age real -- 1
	, hotness_avg_y3_citations real -- 1
	
	, competitive_incoming_citations int -- 1
	, competitive_outgoing_citations int -- 4
	, competitive_citation_inout_fraction real	-- 4
	
	, total_volume_rank real
	, on_topic_volume_rank real
	, on_topic_fraction_rank real
	, on_topic_volume_in_top_10pct_rank REAL
	, on_topic_fraction_in_top_10pct_rank real
	, frontier_volume_rank REAL
	, frontier_fraction_rank real
	, frontier_volume_in_top_10pct_rank REAL
	, frontier_fraction_in_top_10pct_rank real
	, hotness_avg_citations_over_age_rank real
	, hotness_avg_y3_citations_rank real
	, competitive_incoming_citations_rank REAL
	, competitive_outgoing_citations_rank REAL
	, competitive_citation_inout_fraction_rank real	
	
	, frontier_sorting_score real
	, on_topic_sorting_score real
	, hotness_sorting_score real
	, competitive_sorting_score real

	, compound_company_score real
	, thematic_compound_company_score REAL 
    , constraint pk_company primary key (bvd_id)
)
