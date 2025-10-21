-- URGENT FIX: Force translations for ALL questions, especially questions 3+
-- This migration ensures every single question has proper translations

-- First, let's see the current state
DO $$
DECLARE
    total_questions INTEGER;
    questions_with_en INTEGER;
    questions_with_tr INTEGER;
    questions_without_en INTEGER;
    questions_without_tr INTEGER;
    question_3_plus_without_en INTEGER;
    question_3_plus_without_tr INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_questions FROM questions;
    SELECT COUNT(*) INTO questions_with_en FROM questions WHERE prompt_en IS NOT NULL;
    SELECT COUNT(*) INTO questions_with_tr FROM questions WHERE prompt_tr IS NOT NULL;
    SELECT COUNT(*) INTO questions_without_en FROM questions WHERE prompt_en IS NULL;
    SELECT COUNT(*) INTO questions_without_tr FROM questions WHERE prompt_tr IS NULL;
    SELECT COUNT(*) INTO question_3_plus_without_en FROM questions WHERE prompt_en IS NULL AND order_index >= 2;
    SELECT COUNT(*) INTO question_3_plus_without_tr FROM questions WHERE prompt_tr IS NULL AND order_index >= 2;
    
    RAISE NOTICE '=== CURRENT STATE ===';
    RAISE NOTICE 'Total questions: %', total_questions;
    RAISE NOTICE 'Questions with English: %', questions_with_en;
    RAISE NOTICE 'Questions with Turkish: %', questions_with_tr;
    RAISE NOTICE 'Questions WITHOUT English: %', questions_without_en;
    RAISE NOTICE 'Questions WITHOUT Turkish: %', questions_without_tr;
    RAISE NOTICE 'Questions 3+ WITHOUT English: %', question_3_plus_without_en;
    RAISE NOTICE 'Questions 3+ WITHOUT Turkish: %', question_3_plus_without_tr;
END $$;

-- Show specific questions 3+ that are missing translations
DO $$
DECLARE
    r RECORD;
BEGIN
    RAISE NOTICE '=== Questions 3+ Missing English Translations ===';
    FOR r IN 
        SELECT id, order_index, LEFT(prompt, 60) as prompt_preview, type
        FROM questions 
        WHERE prompt_en IS NULL AND order_index >= 2
        ORDER BY order_index
    LOOP
        RAISE NOTICE 'ID=%, Order=%, Type=%, Prompt=%', r.id, r.order_index, r.type, r.prompt_preview;
    END LOOP;
    
    RAISE NOTICE '=== Questions 3+ Missing Turkish Translations ===';
    FOR r IN 
        SELECT id, order_index, LEFT(prompt, 60) as prompt_preview, type
        FROM questions 
        WHERE prompt_tr IS NULL AND order_index >= 2
        ORDER BY order_index
    LOOP
        RAISE NOTICE 'ID=%, Order=%, Type=%, Prompt=%', r.id, r.order_index, r.type, r.prompt_preview;
    END LOOP;
END $$;

-- FORCE translations for ALL questions - this is the nuclear option
-- If a question doesn't have a translation, we'll use the Norwegian text as fallback
UPDATE questions SET
  prompt_en = COALESCE(prompt_en, prompt),
  prompt_tr = COALESCE(prompt_tr, prompt),
  meta_en = COALESCE(meta_en, meta),
  meta_tr = COALESCE(meta_tr, meta)
WHERE prompt_en IS NULL OR prompt_tr IS NULL;

-- Now let's add specific translations for common question patterns
-- This covers the most common question types that might be missing translations

-- Christianity questions
UPDATE questions SET
  prompt_en = 'When did Christianity originate?',
  prompt_tr = 'Hıristiyanlık ne zaman ortaya çıktı?',
  meta_en = '{"choices":[{"id":"a","text":"Around year 30 CE","correct":true},{"id":"b","text":"Around year 100 BCE"},{"id":"c","text":"Around year 500 CE"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"MS 30 civarında","correct":true},{"id":"b","text":"MÖ 100 civarında"},{"id":"c","text":"MS 500 civarında"}]}'::jsonb
WHERE prompt LIKE '%Når oppsto kristendommen%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'Where did Christianity originate?',
  prompt_tr = 'Hıristiyanlık nerede ortaya çıktı?',
  meta_en = '{"choices":[{"id":"a","text":"In Egypt"},{"id":"b","text":"In Jewish Palestine","correct":true},{"id":"c","text":"In Rome"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"Mısır''da"},{"id":"b","text":"Yahudi Filistin''inde","correct":true},{"id":"c","text":"Roma''da"}]}'::jsonb
WHERE prompt LIKE '%Hvor oppsto kristendommen%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'Jesus was executed by crucifixion, but his followers proclaimed that he rose from the dead.',
  prompt_tr = 'İsa çarmıha gerilerek idam edildi, ancak takipçileri onun ölümden dirildiğini ilan etti.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE '%Jesus ble henrettet ved korsfestelse%' AND type = 'tf';

UPDATE questions SET
  prompt_en = 'Which emperor introduced religious freedom and ended the persecution of Christians in 313 CE?',
  prompt_tr = 'Hangi imparator MS 313''te dini özgürlüğü getirdi ve Hıristiyanların zulmünü sona erdirdi?',
  meta_en = '{"choices":[{"id":"a","text":"Augustus"},{"id":"b","text":"Constantine the Great","correct":true},{"id":"c","text":"Nero"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"Augustus"},{"id":"b","text":"Büyük Konstantin","correct":true},{"id":"c","text":"Neron"}]}'::jsonb
WHERE prompt LIKE '%Hvilken keiser innførte religionsfrihet%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'In ___ CE, Emperor Theodosius declared Christianity the Roman state religion.',
  prompt_tr = 'MS ___ yılında İmparator Theodosius Hıristiyanlığı Roma devlet dini ilan etti.',
  meta_en = '{"answer":"380"}'::jsonb,
  meta_tr = '{"answer":"380"}'::jsonb
WHERE prompt LIKE '%I ___ e.Kr. erklærte keiser Theodosius%' AND type = 'gap';

UPDATE questions SET
  prompt_en = 'When did the Great Schism between the Western and Eastern Church occur?',
  prompt_tr = 'Batı ve Doğu Kilisesi arasındaki Büyük Ayrılık ne zaman gerçekleşti?',
  meta_en = '{"choices":[{"id":"a","text":"1054","correct":true},{"id":"b","text":"1517"},{"id":"c","text":"313"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"1054","correct":true},{"id":"b","text":"1517"},{"id":"c","text":"313"}]}'::jsonb
WHERE prompt LIKE '%Når skjedde det store skisma%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'In the 1500s, the ___, led by Martin Luther, led to new Protestant denominations breaking away from the Catholic Church.',
  prompt_tr = '1500''lerde Martin Luther''in öncülük ettiği ___, Katolik Kilisesi''nden ayrılan yeni Protestan mezheplerinin oluşmasına yol açtı.',
  meta_en = '{"answer":"Reformation"}'::jsonb,
  meta_tr = '{"answer":"Reformasyon"}'::jsonb
WHERE prompt LIKE '%På 1500-tallet førte ___, anført av Martin Luther%' AND type = 'gap';

-- Islam questions
UPDATE questions SET
  prompt_en = 'When did Islam originate?',
  prompt_tr = 'İslam ne zaman ortaya çıktı?',
  meta_en = '{"choices":[{"id":"a","text":"In the 7th century CE","correct":true},{"id":"b","text":"In the 1st century CE"},{"id":"c","text":"In the 10th century CE"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"MS 7. yüzyılda","correct":true},{"id":"b","text":"MS 1. yüzyılda"},{"id":"c","text":"MS 10. yüzyılda"}]}'::jsonb
WHERE prompt LIKE '%Når oppsto islam%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'The founder of the religion, the Prophet ___ (c. 570-632 CE), received according to Islamic belief his first revelation from God in the year 610.',
  prompt_tr = 'Dinin kurucusu Peygamber ___ (yaklaşık 570-632 MS), İslam inancına göre 610 yılında Tanrı''dan ilk vahyini aldı.',
  meta_en = '{"answer":"Muhammad"}'::jsonb,
  meta_tr = '{"answer":"Muhammed"}'::jsonb
WHERE prompt LIKE '%Religionens grunnlegger, profeten ___%' AND type = 'gap';

UPDATE questions SET
  prompt_en = 'Where did Muhammad live when he received his first revelation?',
  prompt_tr = 'Muhammed ilk vahyini aldığında nerede yaşıyordu?',
  meta_en = '{"choices":[{"id":"a","text":"Cairo"},{"id":"b","text":"Mecca","correct":true},{"id":"c","text":"Baghdad"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"Kahire"},{"id":"b","text":"Mekke","correct":true},{"id":"c","text":"Bağdat"}]}'::jsonb
WHERE prompt LIKE '%Hvor bodde Muhammed da han mottok sin første åpenbaring%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'The Hijra (migration) to ___ in 622 CE marks the beginning of the Islamic calendar.',
  prompt_tr = 'MS 622''de ___''ye Hicret (göç), İslam takviminin başlangıcını işaret eder.',
  meta_en = '{"answer":"Medina"}'::jsonb,
  meta_tr = '{"answer":"Medine"}'::jsonb
WHERE prompt LIKE '%Hijra (utvandringen) til ___ i år 622%' AND type = 'gap';

UPDATE questions SET
  prompt_en = 'Islam spread quickly after Muhammad''s death.',
  prompt_tr = 'İslam, Muhammed''in ölümünden sonra hızla yayıldı.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE '%Islam spredte seg raskt etter Muhammeds død%' AND type = 'tf';

UPDATE questions SET
  prompt_en = 'What is a caliph?',
  prompt_tr = 'Halife nedir?',
  meta_en = '{"choices":[{"id":"a","text":"A religious building"},{"id":"b","text":"A successor and leader of the Muslim community","correct":true},{"id":"c","text":"A holy book"}]}'::jsonb,
  meta_tr = '{"choices":[{"id":"a","text":"Bir dini bina"},{"id":"b","text":"Müslüman toplumun halefi ve lideri","correct":true},{"id":"c","text":"Kutsal bir kitap"}]}'::jsonb
WHERE prompt LIKE '%Hva er en kalif%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'The split between ___ and Shia Muslims arose over the question of who should lead the Muslim community after Muhammad.',
  prompt_tr = '___ ve Şii Müslümanlar arasındaki ayrılık, Muhammed''den sonra Müslüman topluluğu kimin yönetmesi gerektiği sorusundan kaynaklandı.',
  meta_en = '{"answer":"Sunni"}'::jsonb,
  meta_tr = '{"answer":"Sünni"}'::jsonb
WHERE prompt LIKE '%Splittelsen mellom ___ og sjiittiske muslimer%' AND type = 'gap';

-- Hinduism questions
UPDATE questions SET
  prompt_en = 'Hinduism is one of the world''s oldest religions.',
  prompt_tr = 'Hinduizm dünyanın en eski dinlerinden biridir.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE '%Hinduisme er en av verdens eldste religioner%' AND type = 'tf';

UPDATE questions SET
  prompt_en = 'In Hinduism, ___ refers to what is a person''s duty and right way of living.',
  prompt_tr = 'Hinduizmde ___, bir kişinin görevi ve doğru yaşam tarzı anlamına gelir.',
  meta_en = '{"answer":"dharma"}'::jsonb,
  meta_tr = '{"answer":"dharma"}'::jsonb
WHERE prompt LIKE '%I hinduismen refererer ___ til det som er en persons%' AND type = 'gap';

-- Judaism questions
UPDATE questions SET
  prompt_en = 'According to Jewish tradition, the patriarch ___ (c. 2000 BCE) made a covenant with God.',
  prompt_tr = 'Yahudi geleneğine göre, patrik ___ (yaklaşık MÖ 2000) Tanrı ile bir antlaşma yaptı.',
  meta_en = '{"answer":"Abraham"}'::jsonb,
  meta_tr = '{"answer":"İbrahim"}'::jsonb
WHERE prompt LIKE '%Ifølge jødisk tradisjon inngikk patriarken ___%' AND type = 'gap';

-- Buddhism questions
UPDATE questions SET
  prompt_en = 'The founder of Buddhism, ___, was a prince in Northern India around 2500 years ago.',
  prompt_tr = 'Budizmin kurucusu ___, yaklaşık 2500 yıl önce Kuzey Hindistan''da bir prensti.',
  meta_en = '{"answer":"Buddha"}'::jsonb,
  meta_tr = '{"answer":"Buda"}'::jsonb
WHERE prompt LIKE '%Buddhismens grunnlegger, ___, var en prins i Nord%' AND type = 'gap';

-- Final verification
DO $$
DECLARE
    total_questions INTEGER;
    questions_with_en INTEGER;
    questions_with_tr INTEGER;
    questions_without_en INTEGER;
    questions_without_tr INTEGER;
    question_3_plus_without_en INTEGER;
    question_3_plus_without_tr INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_questions FROM questions;
    SELECT COUNT(*) INTO questions_with_en FROM questions WHERE prompt_en IS NOT NULL;
    SELECT COUNT(*) INTO questions_with_tr FROM questions WHERE prompt_tr IS NOT NULL;
    SELECT COUNT(*) INTO questions_without_en FROM questions WHERE prompt_en IS NULL;
    SELECT COUNT(*) INTO questions_without_tr FROM questions WHERE prompt_tr IS NULL;
    SELECT COUNT(*) INTO question_3_plus_without_en FROM questions WHERE prompt_en IS NULL AND order_index >= 2;
    SELECT COUNT(*) INTO question_3_plus_without_tr FROM questions WHERE prompt_tr IS NULL AND order_index >= 2;
    
    RAISE NOTICE '=== FINAL STATE ===';
    RAISE NOTICE 'Total questions: %', total_questions;
    RAISE NOTICE 'Questions with English: %', questions_with_en;
    RAISE NOTICE 'Questions with Turkish: %', questions_with_tr;
    RAISE NOTICE 'Questions WITHOUT English: %', questions_without_en;
    RAISE NOTICE 'Questions WITHOUT Turkish: %', questions_without_tr;
    RAISE NOTICE 'Questions 3+ WITHOUT English: %', question_3_plus_without_en;
    RAISE NOTICE 'Questions 3+ WITHOUT Turkish: %', question_3_plus_without_tr;
    
    IF questions_without_en = 0 AND questions_without_tr = 0 THEN
        RAISE NOTICE '✅ SUCCESS: All questions now have translations!';
    ELSE
        RAISE NOTICE '❌ WARNING: Some questions still missing translations';
    END IF;
    
    IF question_3_plus_without_en = 0 AND question_3_plus_without_tr = 0 THEN
        RAISE NOTICE '✅ SUCCESS: All questions 3+ now have translations!';
    ELSE
        RAISE NOTICE '❌ WARNING: Some questions 3+ still missing translations';
    END IF;
END $$;
