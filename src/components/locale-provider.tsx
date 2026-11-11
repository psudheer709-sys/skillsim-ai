'use client';

import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { isLocale, supportedLocales, translate, type Locale, type TranslationKey } from '@/lib/i18n';

type LocaleContextValue = { locale: Locale; setLocale: (locale: Locale) => void; t: (key: TranslationKey) => string };
const LocaleContext = createContext<LocaleContextValue | null>(null);
const storageKey = 'skillsim-locale';

export function LocaleProvider({ children }: { children: React.ReactNode }) {
  const [locale, setLocaleState] = useState<Locale>('en');

  useEffect(() => {
    try {
      const saved = window.localStorage.getItem(storageKey);
      if (isLocale(saved)) setLocaleState(saved);
    } catch {
      // The app remains usable when browser storage is disabled.
    }
  }, []);

  useEffect(() => {
    document.documentElement.lang = locale;
  }, [locale]);

  const setLocale = useCallback((next: Locale) => {
    setLocaleState(next);
    try { window.localStorage.setItem(storageKey, next); } catch { /* Keep the current page usable. */ }
  }, []);
  const value = useMemo(() => ({ locale, setLocale, t: (key: TranslationKey) => translate(locale, key) }), [locale, setLocale]);
  return <LocaleContext.Provider value={value}>{children}</LocaleContext.Provider>;
}

export function useLocale() {
  const value = useContext(LocaleContext);
  if (!value) throw new Error('useLocale must be used inside LocaleProvider.');
  return value;
}

export { supportedLocales };
