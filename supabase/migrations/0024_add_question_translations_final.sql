-- Add English and Turkish translations for ALL questions
-- Using LIKE patterns and checking quiz relationships for more reliable matching

-- ISLAM - Origins Lesson Questions
UPDATE questions SET
  prompt_en = 'When did Islam originate?',
  prompt_tr = 'İslam ne zaman ortaya çıktı?',
  meta_en = '{"choices":[
    {"id":"a","text":"In the 7th century CE","correct":true},
    {"id":"b","text":"In the 1st century CE"},
    {"id":"c","text":"In the 10th century CE"}
  ]}'::jsonb,
  meta_tr = '{"choices":[
    {"id":"a","text":"MS 7. yüzyılda","correct":true},
    {"id":"b","text":"MS 1. yüzyılda"},
    {"id":"c","text":"MS 10. yüzyılda"}
  ]}'::jsonb
WHERE prompt LIKE 'Når oppsto islam%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'The founder of the religion, the Prophet ___ (c. 570-632 CE), received according to Islamic belief his first revelation from God in the year 610.',
  prompt_tr = 'Dinin kurucusu Peygamber ___ (yaklaşık 570-632 MS), İslam inancına göre 610 yılında Tanrı''dan ilk vahyini aldı.',
  meta_en = '{"answer":"Muhammad"}'::jsonb,
  meta_tr = '{"answer":"Muhammed"}'::jsonb
WHERE prompt LIKE 'Religionens grunnlegger, profeten ___ (ca. 570%' AND type = 'gap';

-- CHRISTIANITY - Origins Lesson Questions
UPDATE questions SET
  prompt_en = 'When did Christianity originate?',
  prompt_tr = 'Hıristiyanlık ne zaman ortaya çıktı?',
  meta_en = '{"choices":[
    {"id":"a","text":"Around year 30 CE","correct":true},
    {"id":"b","text":"Around year 100 BCE"},
    {"id":"c","text":"Around year 500 CE"}
  ]}'::jsonb,
  meta_tr = '{"choices":[
    {"id":"a","text":"MS 30 civarında","correct":true},
    {"id":"b","text":"MÖ 100 civarında"},
    {"id":"c","text":"MS 500 civarında"}
  ]}'::jsonb
WHERE prompt LIKE 'Når oppsto kristendommen%' AND type = 'mcq';

UPDATE questions SET
  prompt_en = 'Jesus was executed by crucifixion, but his followers proclaimed that he rose from the dead.',
  prompt_tr = 'İsa çarmıha gerilerek idam edildi, ancak takipçileri onun ölümden dirildiğini ilan etti.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE 'Jesus ble henrettet ved korsfestelse%' AND type = 'tf';

-- HINDUISM Questions
UPDATE questions SET
  prompt_en = 'Hinduism is one of the world''s oldest religions.',
  prompt_tr = 'Hinduizm dünyanın en eski dinlerinden biridir.',
  meta_en = '{"answer": true}'::jsonb,
  meta_tr = '{"answer": true}'::jsonb
WHERE prompt LIKE 'Hinduisme er en av verdens eldste religioner%' AND type = 'tf';

UPDATE questions SET
  prompt_en = 'In Hinduism, ___ refers to what is a person''s duty and right way of living.',
  prompt_tr = 'Hinduizmde ___, bir kişinin görevi ve doğru yaşam tarzı anlamına gelir.',
  meta_en = '{"answer":"dharma"}'::jsonb,
  meta_tr = '{"answer":"dharma"}'::jsonb
WHERE prompt LIKE 'I hinduismen refererer ___ til det som er en persons%' AND type = 'gap';

-- JUDAISM Questions  
UPDATE questions SET
  prompt_en = 'According to Jewish tradition, the patriarch ___ (c. 2000 BCE) made a covenant with God.',
  prompt_tr = 'Yahudi geleneğine göre, patrik ___ (yaklaşık MÖ 2000) Tanrı ile bir antlaşma yaptı.',
  meta_en = '{"answer":"Abraham"}'::jsonb,
  meta_tr = '{"answer":"İbrahim"}'::jsonb
WHERE prompt LIKE 'Ifølge jødisk tradisjon inngikk patriarken ___ (ca%' AND type = 'gap';

-- BUDDHISM Questions
UPDATE questions SET
  prompt_en = 'The founder of Buddhism, ___, was a prince in Northern India around 2500 years ago.',
  prompt_tr = 'Budizmin kurucusu ___, yaklaşık 2500 yıl önce Kuzey Hindistan''da bir prensti.',
  meta_en = '{"answer":"Buddha"}'::jsonb,
  meta_tr = '{"answer":"Buda"}'::jsonb
WHERE prompt LIKE 'Buddhismens grunnlegger, ___, var en prins i Nord%' AND type = 'gap';

-- Verify the update
DO $$
DECLARE
    total_questions INTEGER;
    questions_with_en INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_questions FROM questions;
    SELECT COUNT(*) INTO questions_with_en FROM questions WHERE prompt_en IS NOT NULL;
    
    RAISE NOTICE '=== Translation Update Complete ===';
    RAISE NOTICE 'Total questions: %', total_questions;
    RAISE NOTICE 'Questions with English translation: %', questions_with_en;
    RAISE NOTICE 'Coverage: %%%', ROUND((questions_with_en::DECIMAL / total_questions * 100), 2);
END $$;
