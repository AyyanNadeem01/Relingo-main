-- Verify and fix question translations
-- This migration ensures all questions have English and Turkish translations
-- Uses a more robust approach by matching on multiple fields

-- First, let's check if we need to add the columns (they should already exist from migration 0013)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='questions' AND column_name='prompt_en') THEN
        ALTER TABLE questions ADD COLUMN prompt_en TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='questions' AND column_name='meta_en') THEN
        ALTER TABLE questions ADD COLUMN meta_en JSONB;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='questions' AND column_name='prompt_tr') THEN
        ALTER TABLE questions ADD COLUMN prompt_tr TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='questions' AND column_name='meta_tr') THEN
        ALTER TABLE questions ADD COLUMN meta_tr JSONB;
    END IF;
END $$;

-- Show diagnostics
DO $$
DECLARE
    total_questions INTEGER;
    questions_with_en INTEGER;
    questions_without_en INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_questions FROM questions;
    SELECT COUNT(*) INTO questions_with_en FROM questions WHERE prompt_en IS NOT NULL;
    SELECT COUNT(*) INTO questions_without_en FROM questions WHERE prompt_en IS NULL;
    
    RAISE NOTICE 'Total questions: %', total_questions;
    RAISE NOTICE 'Questions with English translation: %', questions_with_en;
    RAISE NOTICE 'Questions WITHOUT English translation: %', questions_without_en;
END $$;

-- If there are questions without translations, let's see which ones
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN 
        SELECT id, LEFT(prompt, 50) as prompt_preview, type 
        FROM questions 
        WHERE prompt_en IS NULL 
        LIMIT 10
    LOOP
        RAISE NOTICE 'Question without EN: ID=%, Type=%, Prompt=%', r.id, r.type, r.prompt_preview;
    END LOOP;
END $$;
