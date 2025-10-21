-- Diagnostic script to check specific questions and their translations
-- This will help identify exactly which questions are missing translations

-- Check all questions with their translation status
SELECT 
    q.id,
    q.order_index,
    q.type,
    q.prompt,
    CASE 
        WHEN q.prompt_en IS NOT NULL THEN 'HAS_EN' 
        ELSE 'MISSING_EN' 
    END as english_status,
    CASE 
        WHEN q.prompt_tr IS NOT NULL THEN 'HAS_TR' 
        ELSE 'MISSING_TR' 
    END as turkish_status,
    LEFT(q.prompt, 50) as prompt_preview,
    LEFT(q.prompt_en, 50) as english_preview,
    LEFT(q.prompt_tr, 50) as turkish_preview
FROM questions q
ORDER BY q.order_index
LIMIT 20;

-- Check specifically questions 3+ in each quiz
SELECT 
    q.id,
    q.order_index,
    q.type,
    q.prompt,
    CASE 
        WHEN q.prompt_en IS NOT NULL THEN 'HAS_EN' 
        ELSE 'MISSING_EN' 
    END as english_status,
    CASE 
        WHEN q.prompt_tr IS NOT NULL THEN 'HAS_TR' 
        ELSE 'MISSING_TR' 
    END as turkish_status,
    LEFT(q.prompt, 50) as prompt_preview
FROM questions q
WHERE q.order_index >= 2  -- Questions 3+ (0-indexed)
ORDER BY q.order_index;

-- Count questions missing translations by position
SELECT 
    CASE 
        WHEN order_index = 0 THEN 'Question 1'
        WHEN order_index = 1 THEN 'Question 2'
        WHEN order_index = 2 THEN 'Question 3'
        WHEN order_index = 3 THEN 'Question 4'
        WHEN order_index = 4 THEN 'Question 5'
        WHEN order_index = 5 THEN 'Question 6'
        WHEN order_index = 6 THEN 'Question 7'
        ELSE 'Question ' || (order_index + 1)
    END as question_position,
    COUNT(*) as total_questions,
    COUNT(CASE WHEN prompt_en IS NULL THEN 1 END) as missing_english,
    COUNT(CASE WHEN prompt_tr IS NULL THEN 1 END) as missing_turkish
FROM questions
GROUP BY order_index
ORDER BY order_index;
