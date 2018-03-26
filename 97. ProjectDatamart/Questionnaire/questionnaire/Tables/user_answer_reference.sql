CREATE TABLE [questionnaire].[user_answer_reference]
(
	[Id] INT NOT NULL PRIMARY KEY
	, id_user_answer INT NOT NULL
	, id_reference INT NOT NULL
	, [comment] nvarchar(max) -- A specific comment as to how a finding follows from the reference
	, [location_in_reference] nvarchar(50) -- A specification of location, for instance page numbers in an Annual Report, or slide number in an investor presentation.
	, added_by NVARCHAR(100)
	, added_on DATETIME2 (7)   DEFAULT (GETDATE()) NOT NULL
)
