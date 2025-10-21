import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';

// Import translations
import en from '../locales/en.json';
import no from '../locales/no.json';
import tr from '../locales/tr.json';

const resources = {
  en: { translation: en },
  no: { translation: no },
  tr: { translation: tr },
};

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources,

    fallbackLng: 'en', // Fallback to English if browser language not supported
    supportedLngs: ['en', 'no', 'tr'],
    detection: {
      // Check localStorage first (user's saved preference), then browser language
      order: ['localStorage', 'navigator', 'htmlTag'],
      // Only cache in localStorage to remember user's choice
      caches: ['localStorage'],
      // Look for language codes in various formats
      lookupLocalStorage: 'i18nextLng',
      // Convert browser language codes to our supported codes
      convertDetectedLanguage: (lng) => {
        // Handle language codes like 'en-US', 'en-GB' -> 'en'
        // 'nb-NO', 'nn-NO' -> 'no'
        // 'tr-TR' -> 'tr'
        const languageCode = lng.split('-')[0].toLowerCase();
        
        // Map Norwegian variants to 'no'
        if (languageCode === 'nb' || languageCode === 'nn') {
          return 'no';
        }
        
        // Map to supported languages
        if (['en', 'no', 'tr'].includes(languageCode)) {
          return languageCode;
        }
        
        // Default to English for unsupported languages
        return 'en';
      },
    },
    interpolation: {
      escapeValue: false,
    },
    // Ensure language changes trigger re-renders
    react: {
      useSuspense: false,
    },
  })
  .then(() => {
    // Log the detected/selected language
    console.log('🌍 i18next initialized with language:', i18n.language);
    console.log('📍 Browser language:', navigator.language);
    console.log('💾 Stored preference:', localStorage.getItem('i18nextLng'));
    
    // Force a language change event to ensure all components are updated
    i18n.emit('languageChanged', i18n.language);
    
    // Add a listener for language changes to ensure consistency
    i18n.on('languageChanged', (lng) => {
      console.log('🔄 Language changed to:', lng);
      // Update localStorage to ensure consistency
      localStorage.setItem('i18nextLng', lng);
    });
  });

export default i18n;


