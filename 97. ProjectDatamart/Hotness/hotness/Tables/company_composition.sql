CREATE TABLE hotness.[company_composition]
(
	[bvd_id] VARCHAR(25) NOT NULL, 
    [preference_area_id] INT NOT NULL,
	y smallint not null,
    [number_of_families] INT NULL,
	constraint pk_cc primary key (bvd_id,preference_area_id,y)
)
