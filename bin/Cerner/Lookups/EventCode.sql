﻿{Source_to_Standard}
SELECT distinct SOURCE_CODE, TARGET_CONCEPT_ID, TARGET_DOMAIN_ID
FROM CTE_VOCAB_MAP
WHERE lower(SOURCE_VOCABULARY_ID) IN ('jnj_cerner_event_cod')
