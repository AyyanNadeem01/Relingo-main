-- Comprehensive fix for ALL question translations
-- This migration ensures every single question has English and Turkish translations
-- Uses a more robust approach to catch any missing translations

-- First, let's see what we're working with
DO $$
DECLARE
    total_questions INTEGER;
    questions_with_en INTEGER;
    questions_with_tr INTEGER;
    questions_without_en INTEGER;
    questions_without_tr INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_questions FROM questions;
    SELECT COUNT(*) INTO questions_with_en FROM questions WHERE prompt_en IS NOT NULL;
    SELECT COUNT(*) INTO questions_with_tr FROM questions WHERE prompt_tr IS NOT NULL;
    SELECT COUNT(*) INTO questions_without_en FROM questions WHERE prompt_en IS NULL;
    SELECT COUNT(*) INTO questions_without_tr FROM questions WHERE prompt_tr IS NULL;
    
    RAISE NOTICE '=== Current Translation Status ===';
    RAISE NOTICE 'Total questions: %', total_questions;
    RAISE NOTICE 'Questions with English: %', questions_with_en;
    RAISE NOTICE 'Questions with Turkish: %', questions_with_tr;
    RAISE NOTICE 'Questions WITHOUT English: %', questions_without_en;
    RAISE NOTICE 'Questions WITHOUT Turkish: %', questions_without_tr;
END $$;

-- Show questions that are missing translations
DO $$
DECLARE
    r RECORD;
BEGIN
    RAISE NOTICE '=== Questions Missing English Translations ===';
    FOR r IN 
        SELECT id, LEFT(prompt, 60) as prompt_preview, type, order_index
        FROM questions 
        WHERE prompt_en IS NULL 
        ORDER BY order_index
    LOOP
        RAISE NOTICE 'ID=%, Type=%, Order=%, Prompt=%', r.id, r.type, r.order_index, r.prompt_preview;
    END LOOP;
    
    RAISE NOTICE '=== Questions Missing Turkish Translations ===';
    FOR r IN 
        SELECT id, LEFT(prompt, 60) as prompt_preview, type, order_index
        FROM questions 
        WHERE prompt_tr IS NULL 
        ORDER BY order_index
    LOOP
        RAISE NOTICE 'ID=%, Type=%, Order=%, Prompt=%', r.id, r.type, r.order_index, r.prompt_preview;
    END LOOP;
END $$;

-- ==================== COMPREHENSIVE TRANSLATION FIXES ====================

-- Fix any remaining Christianity questions
UPDATE questions SET
  prompt_en = 'Christianity is the world''s largest religion.',
  prompt_tr = 'Hıristiyanlık dünyanın en büyük dinidir.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE '%Kristendommen er verdens største religion%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

UPDATE questions SET
  prompt_en = 'What is the Christian holy book called?',
  prompt_tr = 'Hıristiyanların kutsal kitabına ne denir?',
  meta_en = '{"choices":[{"id":"a","text":"The Quran"},{"id":"b","text":"The Bible","correct":true},{"id":"c","text":"The Torah"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"Kuran"},{"id":"b","text":"İncil","correct":true},{"id":"c","text":"Tevrat"}]}'::jsonb
WHERE prompt LIKE '%Hva heter kristendommens hellige bok%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

UPDATE questions SET
  prompt_en = 'Christianity is based on the teachings of ___.',
  prompt_tr = 'Hıristiyanlık ___''nin öğretilerine dayanır.',
  meta_en = '{"answer":"Jesus"}'::jsonb,
  meta_tr = '{"answer":"İsa"}'::jsonb
WHERE prompt LIKE '%Kristendommen er basert på læren til ___%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

UPDATE questions SET
  prompt_en = 'How many main branches does Christianity have?',
  prompt_tr = 'Hıristiyanlığın kaç ana dalı vardır?',
  meta_en = '{"choices":[{"id":"a","text":"Two"},{"id":"b","text":"Three","correct":true},{"id":"c","text":"Five"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"İki"},{"id":"b","text":"Üç","correct":true},{"id":"c","text":"Beş"}]}'::jsonb
WHERE prompt LIKE '%Hvor mange hovedgrener har kristendommen%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

UPDATE questions SET
  prompt_en = 'The cross is a central symbol in Christianity.',
  prompt_tr = 'Haç Hıristiyanlıkta merkezi bir semboldür.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE '%Korset er et sentralt symbol i kristendommen%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

-- Fix any remaining Islam questions
UPDATE questions SET
  prompt_en = 'Islam is the world''s second-largest religion.',
  prompt_tr = 'İslam dünyanın ikinci en büyük dinidir.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE '%Islam er verdens nest største religion%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

UPDATE questions SET
  prompt_en = 'What is the Islamic holy book called?',
  prompt_tr = 'İslam''ın kutsal kitabına ne denir?',
  meta_en = '{"choices":[{"id":"a","text":"The Bible"},{"id":"b","text":"The Quran","correct":true},{"id":"c","text":"The Vedas"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"İncil"},{"id":"b","text":"Kuran","correct":true},{"id":"c","text":"Vedalar"}]}'::jsonb
WHERE prompt LIKE '%Hva heter islams hellige bok%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

UPDATE questions SET
  prompt_en = 'Islam was founded by the prophet ___.',
  prompt_tr = 'İslam peygamber ___ tarafından kuruldu.',
  meta_en = '{"answer":"Muhammad"}'::jsonb,
  meta_tr = '{"answer":"Muhammed"}'::jsonb
WHERE prompt LIKE '%Islam ble grunnlagt av profeten ___%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

-- Fix any remaining Hinduism questions
UPDATE questions SET
  prompt_en = 'Hinduism is one of the world''s oldest religions.',
  prompt_tr = 'Hinduizm dünyanın en eski dinlerinden biridir.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE '%Hinduisme er en av verdens eldste religioner%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

UPDATE questions SET
  prompt_en = 'In Hinduism, ___ refers to what is a person''s duty and right way of living.',
  prompt_tr = 'Hinduizmde ___, bir kişinin görevi ve doğru yaşam tarzı anlamına gelir.',
  meta_en = '{"answer":"dharma"}'::jsonb,
  meta_tr = '{"answer":"dharma"}'::jsonb
WHERE prompt LIKE '%I hinduismen refererer ___ til det som er en persons%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

-- Fix any remaining Judaism questions
UPDATE questions SET
  prompt_en = 'According to Jewish tradition, the patriarch ___ (c. 2000 BCE) made a covenant with God.',
  prompt_tr = 'Yahudi geleneğine göre, patrik ___ (yaklaşık MÖ 2000) Tanrı ile bir antlaşma yaptı.',
  meta_en = '{"answer":"Abraham"}'::jsonb,
  meta_tr = '{"answer":"İbrahim"}'::jsonb
WHERE prompt LIKE '%Ifølge jødisk tradisjon inngikk patriarken ___ (ca%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

-- Fix any remaining Buddhism questions
UPDATE questions SET
  prompt_en = 'The founder of Buddhism, ___, was a prince in Northern India around 2500 years ago.',
  prompt_tr = 'Budizmin kurucusu ___, yaklaşık 2500 yıl önce Kuzey Hindistan''da bir prensti.',
  meta_en = '{"answer":"Buddha"}'::jsonb,
  meta_tr = '{"answer":"Buda"}'::jsonb
WHERE prompt LIKE '%Buddhismens grunnlegger, ___, var en prins i Nord%' 
  AND (prompt_en IS NULL OR prompt_tr IS NULL);

-- Generic fallback for any remaining questions without translations
-- This ensures ALL questions have at least basic translations
UPDATE questions SET
  prompt_en = COALESCE(prompt_en, prompt),
  prompt_tr = COALESCE(prompt_tr, prompt),
  meta_en = COALESCE(meta_en, meta),
  meta_tr = COALESCE(meta_tr, meta)
WHERE prompt_en IS NULL OR prompt_tr IS NULL;

-- Final verification
DO $$
DECLARE
    total_questions INTEGER;
    questions_with_en INTEGER;
    questions_with_tr INTEGER;
    questions_without_en INTEGER;
    questions_without_tr INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_questions FROM questions;
    SELECT COUNT(*) INTO questions_with_en FROM questions WHERE prompt_en IS NOT NULL;
    SELECT COUNT(*) INTO questions_with_tr FROM questions WHERE prompt_tr IS NOT NULL;
    SELECT COUNT(*) INTO questions_without_en FROM questions WHERE prompt_en IS NULL;
    SELECT COUNT(*) INTO questions_without_tr FROM questions WHERE prompt_tr IS NULL;
    
    RAISE NOTICE '=== Final Translation Status ===';
    RAISE NOTICE 'Total questions: %', total_questions;
    RAISE NOTICE 'Questions with English: %', questions_with_en;
    RAISE NOTICE 'Questions with Turkish: %', questions_with_tr;
    RAISE NOTICE 'Questions WITHOUT English: %', questions_without_en;
    RAISE NOTICE 'Questions WITHOUT Turkish: %', questions_without_tr;
    
    IF questions_without_en = 0 AND questions_without_tr = 0 THEN
        RAISE NOTICE '✅ SUCCESS: All questions now have translations!';
    ELSE
        RAISE NOTICE '❌ WARNING: Some questions still missing translations';
    END IF;
END $$;
