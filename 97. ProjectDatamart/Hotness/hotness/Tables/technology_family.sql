CREATE TABLE hotness.[technology_family]
(
	technology_id smallint NOT NULL
	, inpadoc_family_id INT NOT NULL
	/* family metrics; looked up in pw */
	, number_of_citations SMALLINT
	, y3_citations SMALLint
	, priority_year smallint
	/* specific flags; calculated in 02_technology_hotness */
    , [is_top_in_technology] BIT NULL
    , CONSTRAINT pk_technology_family primary key (technology_id, inpadoc_family_id)
)