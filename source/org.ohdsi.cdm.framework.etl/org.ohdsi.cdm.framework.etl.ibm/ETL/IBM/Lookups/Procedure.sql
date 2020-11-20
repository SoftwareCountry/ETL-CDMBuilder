﻿{base},
Standard as (
SELECT distinct REPLACE(SOURCE_CODE, '.', '') AS SOURCE_CODE, TARGET_CONCEPT_ID, TARGET_DOMAIN_ID, cast('1900/1/1' as date) as VALID_START_DATE, cast('2100/1/1' as date) as VALID_END_DATE, SOURCE_VOCABULARY_ID
FROM Source_to_Standard
WHERE lower(SOURCE_VOCABULARY_ID) IN ('icd9proc','hcpcs','cpt4', 'icd10pcs', 'cdt')
AND (TARGET_STANDARD_CONCEPT IS NOT NULL or TARGET_STANDARD_CONCEPT != '')
AND (TARGET_INVALID_REASON IS NULL or TARGET_INVALID_REASON = '')
AND lower(TARGET_CONCEPT_CLASS_ID) NOT IN ('hcpcs modifier','cpt4 modifier','cpt4 hierarchy','icd10pcs hierarchy')
), Source as (
SELECT distinct REPLACE(SOURCE_CODE, '.', '') AS SOURCE_CODE, TARGET_CONCEPT_ID, TARGET_DOMAIN_ID
FROM Source_to_Source
WHERE lower(SOURCE_VOCABULARY_ID) IN ('icd9proc','hcpcs','cpt4','icd10pcs', 'cdt')
AND lower(TARGET_VOCABULARY_ID) IN ('icd9proc','hcpcs','cpt4','icd10pcs', 'cdt')
AND lower(TARGET_CONCEPT_CLASS_ID) NOT IN ('hcpcs modifier','cpt4 modifier','cpt4 hierarchy','icd10pcs hierarchy')
), S_S as
(
select SOURCE_CODE from Standard
union 
select SOURCE_CODE from Source
)

select distinct S_S.SOURCE_CODE, Standard.TARGET_CONCEPT_ID, Standard.TARGET_DOMAIN_ID, Standard.VALID_START_DATE, Standard.VALID_END_DATE, Standard.SOURCE_VOCABULARY_ID, Source.TARGET_CONCEPT_ID as SOURCE_TARGET_CONCEPT_ID, cast('1900/1/1' as date) as SOURCE_validStartDate, cast('2100/1/1' as date) as SOURCE_validEndDate, ingredient_level.ingredient_concept_id
from S_S
left join Standard on Standard.SOURCE_CODE = S_S.SOURCE_CODE
left join Source on Source.SOURCE_CODE = S_S.SOURCE_CODE 
left join ingredient_level on ingredient_level.concept_id = Standard.TARGET_CONCEPT_ID