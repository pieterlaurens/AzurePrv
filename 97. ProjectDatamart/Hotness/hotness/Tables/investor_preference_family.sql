CREATE TABLE hotness.[investor_preference_family]
(
    [preference_id] smallint not null
	,inpadoc_family_id INT NOT NULL
	, priority_year smallint
	, [is_top_in_preference] BIT NULL
    ,number_of_citations int NULL
    	, constraint pk_ipf primary key (preference_id,inpadoc_family_id)
--	[preference_area] NVARCHAR(50) NULL
)
