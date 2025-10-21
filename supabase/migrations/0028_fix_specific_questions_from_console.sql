-- TARGETED FIX for specific questions missing translations
-- Based on console logs showing these exact question IDs need translations

-- Question 3 (ID: 2e40cf4d-cc5b-442b-b4e3-c2be4f6eacd1)
-- Norwegian: "I hvilket år mottok profeten Muhammad sin første å"
UPDATE questions SET
  prompt_en = 'In which year did the Prophet Muhammad receive his first revelation?',
  prompt_tr = 'Peygamber Muhammed ilk vahyini hangi yılda aldı?',
  meta_en = '{"choices":[{"id":"a","text":"610 CE","correct":true},{"id":"b","text":"622 CE"},{"id":"c","text":"632 CE"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"MS 610","correct":true},{"id":"b","text":"MS 622"},{"id":"c","text":"MS 632"}]}'::jsonb
WHERE id = '2e40cf4d-cc5b-442b-b4e3-c2be4f6eacd1';

-- Question 4 (ID: faa4f28a-853d-48d7-a69a-55c9bbdd3f5a)
-- Norwegian: "I ___ utvandret Muhammad fra Mekka til Medina (den"
UPDATE questions SET
  prompt_en = 'In ___ CE, Muhammad migrated from Mecca to Medina (the Hijra).',
  prompt_tr = 'MS ___ yılında Muhammed Mekke''den Medine''ye göç etti (Hicret).',
  meta_en = '{"answer":"622"}'::jsonb,
  meta_tr = '{"answer":"622"}'::jsonb
WHERE id = 'faa4f28a-853d-48d7-a69a-55c9bbdd3f5a';

-- Question 5 (ID: bc3f2c5d-3891-4045-bf7c-130498c59db6)
-- Norwegian: "Ved Muhammads død i 632 hadde han forent store del"
UPDATE questions SET
  prompt_en = 'By Muhammad''s death in 632, he had united large parts of the Arabian Peninsula under Islam.',
  prompt_tr = 'Muhammed''in 632''deki ölümüne kadar, Arap Yarımadası''nın büyük bölümlerini İslam altında birleştirmişti.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE id = 'bc3f2c5d-3891-4045-bf7c-130498c59db6';

-- Question 6 (ID: 55c75029-4a64-4e1f-8aa2-a8695ea88cd0)
-- Norwegian: "Hva er navnet på tilhengerne av Ali som utviklet s"
UPDATE questions SET
  prompt_en = 'What is the name of Ali''s followers who developed into a separate branch of Islam?',
  prompt_tr = 'Ali''nin takipçilerinin, İslam''ın ayrı bir dalı haline gelen adı nedir?',
  meta_en = '{"choices":[{"id":"a","text":"Sunni"},{"id":"b","text":"Shia","correct":true},{"id":"c","text":"Sufi"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"Sünni"},{"id":"b","text":"Şii","correct":true},{"id":"c","text":"Sufi"}]}'::jsonb
WHERE id = '55c75029-4a64-4e1f-8aa2-a8695ea88cd0';

-- Question 7 (ID: 438ecf22-1c38-47b2-9e98-5d2044860aba)
-- Norwegian: "Skillet mellom sunni og sjia oppsto på grunn av ue"
UPDATE questions SET
  prompt_en = 'The split between Sunni and Shia arose due to disagreement about who should lead the Muslim community after Muhammad.',
  prompt_tr = 'Sünni ve Şii arasındaki ayrılık, Muhammed''den sonra Müslüman topluluğu kimin yönetmesi gerektiği konusundaki anlaşmazlıktan kaynaklandı.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE id = '438ecf22-1c38-47b2-9e98-5d2044860aba';

-- Verify the updates
SELECT 
    id,
    order_index,
    LEFT(prompt, 50) as norwegian_prompt,
    LEFT(prompt_en, 50) as english_prompt,
    LEFT(prompt_tr, 50) as turkish_prompt,
    CASE WHEN prompt_en IS NOT NULL THEN 'HAS_EN' ELSE 'MISSING_EN' END as english_status,
    CASE WHEN prompt_tr IS NOT NULL THEN 'HAS_TR' ELSE 'MISSING_TR' END as turkish_status
FROM questions 
WHERE id IN (
    '2e40cf4d-cc5b-442b-b4e3-c2be4f6eacd1',
    'faa4f28a-853d-48d7-a69a-55c9bbdd3f5a',
    'bc3f2c5d-3891-4045-bf7c-130498c59db6',
    '55c75029-4a64-4e1f-8aa2-a8695ea88cd0',
    '438ecf22-1c38-47b2-9e98-5d2044860aba'
)
ORDER BY order_index;
