-- Consolidated, idempotent backfill + verification for question translations
-- Safe to run multiple times. Guarantees no NULL translations remain.
-- Strategy:
--  1) Ensure EN/TR text/meta are present by copying Norwegian where missing
--  2) Report coverage per lesson/quiz

-- 1) BACKFILL: copy NO -> EN/TR where missing
UPDATE public.questions
SET
  prompt_en = COALESCE(prompt_en, prompt),
  prompt_tr = COALESCE(prompt_tr, prompt),
  meta_en   = COALESCE(meta_en,   meta),
  meta_tr   = COALESCE(meta_tr,   meta)
WHERE prompt_en IS NULL
   OR prompt_tr IS NULL
   OR meta_en   IS NULL
   OR meta_tr   IS NULL;

-- 2) DIAGNOSTICS: totals
DO $$
DECLARE
  total_q INT;
  missing_en INT;
  missing_tr INT;
  missing_meta_en INT;
  missing_meta_tr INT;
BEGIN
  SELECT COUNT(*) INTO total_q FROM public.questions;
  SELECT COUNT(*) INTO missing_en FROM public.questions WHERE prompt_en IS NULL;
  SELECT COUNT(*) INTO missing_tr FROM public.questions WHERE prompt_tr IS NULL;
  SELECT COUNT(*) INTO missing_meta_en FROM public.questions WHERE meta_en IS NULL;
  SELECT COUNT(*) INTO missing_meta_tr FROM public.questions WHERE meta_tr IS NULL;

  RAISE NOTICE '=== Translation Coverage (Totals) ===';
  RAISE NOTICE 'Total questions: %', total_q;
  RAISE NOTICE 'Missing EN prompt: %', missing_en;
  RAISE NOTICE 'Missing TR prompt: %', missing_tr;
  RAISE NOTICE 'Missing EN meta: %', missing_meta_en;
  RAISE NOTICE 'Missing TR meta: %', missing_meta_tr;
END $$;

-- 2b) DIAGNOSTICS: per lesson + quiz
-- Note: Uses RAISE NOTICE for a concise summary. Query also left below for SQL IDE use.
DO $$
DECLARE rec RECORD;
BEGIN
  RAISE NOTICE '=== Missing by Lesson/Quiz (should all be zero) ===';
  FOR rec IN (
    SELECT
      l.slug AS lesson_slug,
      qz.id   AS quiz_id,
      COUNT(*) FILTER (WHERE qu.prompt_en IS NULL)     AS missing_en,
      COUNT(*) FILTER (WHERE qu.prompt_tr IS NULL)     AS missing_tr,
      COUNT(*) FILTER (WHERE qu.meta_en   IS NULL)     AS missing_meta_en,
      COUNT(*) FILTER (WHERE qu.meta_tr   IS NULL)     AS missing_meta_tr
    FROM public.questions qu
    JOIN public.quizzes   qz ON qz.id = qu.quiz_id
    JOIN public.lessons   l  ON l.id  = qz.lesson_id
    GROUP BY l.slug, qz.id
    ORDER BY l.slug
  ) LOOP
    RAISE NOTICE 'Lesson=% Quiz=% | miss_en=% miss_tr=% miss_meta_en=% miss_meta_tr=%',
      rec.lesson_slug, rec.quiz_id, rec.missing_en, rec.missing_tr, rec.missing_meta_en, rec.missing_meta_tr;
  END LOOP;
END $$;

-- Optional: standalone query to run in SQL editor for a tabular view
-- SELECT
--   l.slug AS lesson_slug,
--   qz.id   AS quiz_id,
--   COUNT(*) FILTER (WHERE qu.prompt_en IS NULL)     AS missing_en,
--   COUNT(*) FILTER (WHERE qu.prompt_tr IS NULL)     AS missing_tr,
--   COUNT(*) FILTER (WHERE qu.meta_en   IS NULL)     AS missing_meta_en,
--   COUNT(*) FILTER (WHERE qu.meta_tr   IS NULL)     AS missing_meta_tr
-- FROM public.questions qu
-- JOIN public.quizzes   qz ON qz.id = qu.quiz_id
-- JOIN public.lessons   l  ON l.id  = qz.lesson_id
-- GROUP BY l.slug, qz.id
-- ORDER BY l.slug;


