CREATE TABLE [questionnaire].[reference]
(
	[id] INT NOT NULL PRIMARY KEY
	, [reference_type_id] SMALLINT
	, [label] NVARCHAR(500)			-- As stored for reference and in 'reference manager'
	, [comment] NVARCHAR(MAX)		-- Can contain a user summary or other relevant commentary.
	, [short_label] NVARCHAR(50)	-- As presented in the report bibligraphy
	, [url] NVARCHAR(MAX)			-- Where the resource can be found, or was retrieved from.
	, [author] NVARCHAR(500)		-- If from an (objective) third party
	, [appeared_in] nvarchar(500)	-- If referencing an article from a periodical source
	, [pages] nvarchar(50)			-- If applicable
	, retrieved_on DATETIME2 (7)   DEFAULT (GETDATE()) NOT NULL -- Date of retrieval (esp. for websites)
	, coverage_published DATETIME2 (7)   DEFAULT (GETDATE()) NOT NULL -- Date of publication; from this date the answer to the question that reference this item may be included in the judgement
	, coverage_period_start DATE	-- Start and end date of the period to which this publication pertains
	, coverage_period_end DATE
    , [added_on]    DATETIME2 (7)   DEFAULT (GETDATE()) NOT NULL -- Date the reference was added/created
    , [added_by]    NVARCHAR (100)  NULL -- Reference added by whom
)
