-- Add Buddhism lesson translation keys
-- This ensures Buddhism lessons are properly translated

-- Update Buddhism lessons with translation keys
UPDATE public.lessons SET 
  title_key = 'lessons.buddhism.origins.title',
  description_key = 'lessons.buddhism.origins.description'
WHERE slug = 'buddhisme-opprinnelse';

UPDATE public.lessons SET 
  title_key = 'lessons.buddhism.beliefs.title',
  description_key = 'lessons.buddhism.beliefs.description'
WHERE slug = 'buddhisme-tro';

UPDATE public.lessons SET 
  title_key = 'lessons.buddhism.practices.title',
  description_key = 'lessons.buddhism.practices.description'
WHERE slug = 'buddhisme-praksis';

UPDATE public.lessons SET 
  title_key = 'lessons.buddhism.holidays.title',
  description_key = 'lessons.buddhism.holidays.description'
WHERE slug = 'buddhisme-hoytider';

UPDATE public.lessons SET 
  title_key = 'lessons.buddhism.texts.title',
  description_key = 'lessons.buddhism.texts.description'
WHERE slug = 'buddhisme-tekster';

UPDATE public.lessons SET 
  title_key = 'lessons.buddhism.modern.title',
  description_key = 'lessons.buddhism.modern.description'
WHERE slug = 'buddhisme-moderne';
