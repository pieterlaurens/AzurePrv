-- Create fake revenue fractions table
if object_id('tempdb.dbo.#company_segmentation') IS NOT NULL DROP TABLE #company_segmentation
CREATE TABLE #company_segmentation (
  mapping_id [varchar](32) NOT NULL,
  fraction REAL NOT NULL,
);

INSERT INTO #company_segmentation 
    (mapping_id, fraction) 
VALUES 

('37A31487C4F5DA0056751B2F57B1D1E6',	0.05693626)
, ('38CEF56E0B4710CE452117A1065D9C0F',	0.9430637)
--('01DE322FF2281DE8A809E443FDABA24F',0.05),
--('08990462B738878498F1A0A99D391424',0.125),
--('1A5E9A6E25E64F85BCF23329F6EF7E8B',0.175),
--('21061A6484CD935DA59029C3D6E26551',0.05),
--('24B125CA7E25925582897FE01E57A88E',0.51),
--('2E124C14E6A42BF4D5A684949FA35744',0.05),
--('38CEF56E0B4710CE452117A1065D9C0F',0.04);

if object_id('tempdb.dbo.#company_segmentation_with_scores') IS NOT NULL DROP TABLE #company_segmentation_with_scores
select a.*, b.custom_mapping_score,b.custom_mapping_relevancy 
into #company_segmentation_with_scores
from #company_segmentation a join
[BloombergRevenue_project].[bacmap].[custom_mapping] b on a.mapping_id=b.custom_mapping_id

select * from  #company_segmentation_with_scores

-- CALCULATE SCORES
declare @sd_score REAL = 0
declare @n_products INT = 0
declare @neutral_fraction REAL = 0
declare @negative_fraction REAL = 0
declare @negative_correction_factor REAL = 0
------------------------------------------------------------------------------------------
-- 1. Deal with the positive SDI products: weighted average of the positive product scores
------------------------------------------------------------------------------------------
---- Check if there are any positive products
SET @n_products = 
(select count(mapping_id)
from #company_segmentation_with_scores
where custom_mapping_relevancy=1)
---- If there are positive products, calculate the weighted average 
if @n_products>0
SET @sd_score = 
(select sum(fraction*custom_mapping_score)/sum(fraction)
from #company_segmentation_with_scores
where custom_mapping_relevancy=1);
select @sd_score as sd_score_of_positive_products

------------------------------------------------------------------------------------------
-- 2. Deal with the neutral SDI products: if 50-80% subtract -1, if >80% subtract -2
------------------------------------------------------------------------------------------
---- Check if there are any neutral products
SET @n_products = 
(SELECT count(mapping_id)
FROM #company_segmentation_with_scores
WHERE custom_mapping_relevancy=0)
---- If there are neutral products, subtract points according to the above rule
if @n_products>0
BEGIN
SET @neutral_fraction = 
(SELECT sum(fraction) 
FROM #company_segmentation_with_scores
WHERE custom_mapping_relevancy=0)

IF @neutral_fraction>0.5 and @neutral_fraction<=0.8
SET @sd_score = @sd_score-1
IF @neutral_fraction>0.8
SET @sd_score = @sd_score-2
END

select @sd_score as sd_score_after_neutral_correction
------------------------------------------------------------------------------------------------------
-- 3. Deal with the negative SDI products: 
--    correction_factor=1/(weighted average of negative products)
--    if <5%    -1*correction_factor
--    if 5-20%  -2*correction_factor
--    if 20-40% -3*correction_factor
--    if 40-60% -4*correction_factor
--    if >60%   -5*correction_factor
------------------------------------------------------------------------------------------------------
---- Check if there are any negative products
SET @n_products = 
(SELECT count(mapping_id)
FROM #company_segmentation_with_scores
WHERE custom_mapping_relevancy=-1)
---- If there are negative products, subtract points according to the above rule
if @n_products>0
BEGIN
SET @negative_fraction = 
(SELECT sum(fraction) 
FROM #company_segmentation_with_scores
WHERE custom_mapping_relevancy=-1)
--Calculate the correction factor
SET @negative_correction_factor = 
(SELECT 1/(sum(fraction*custom_mapping_score)/sum(fraction)) 
FROM #company_segmentation_with_scores
WHERE custom_mapping_relevancy=-1)
select @negative_correction_factor as negative_correction_factor
--Subtract points
IF @negative_fraction<=0.05
SET @sd_score=@sd_score-1*@negative_correction_factor
IF @negative_fraction>0.05 and @negative_fraction<=0.20
SET @sd_score=@sd_score-2*@negative_correction_factor
IF @negative_fraction>0.20 and @negative_fraction<=0.40
SET @sd_score=@sd_score-3*@negative_correction_factor
IF @negative_fraction>0.40 and @negative_fraction<=0.60
SET @sd_score=@sd_score-4*@negative_correction_factor
IF @negative_fraction>0.60
SET @sd_score=@sd_score-5*@negative_correction_factor
END

-- THE FINAL SCORE
select @sd_score as final_score
