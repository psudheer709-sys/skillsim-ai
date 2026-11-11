import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { isLocale, localeNames, supportedLocales, translate, translationKeys } from '../src/lib/i18n.ts';

test('Phase 6 language catalog has complete English, Telugu, Hindi and Tamil UI strings', () => {
  assert.deepEqual(supportedLocales, ['en', 'te', 'hi', 'ta']);
  for (const locale of supportedLocales) {
    assert.ok(localeNames[locale]);
    for (const key of translationKeys) assert.ok(translate(locale, key).trim(), `${locale} is missing ${key}`);
  }
  assert.equal(isLocale('te'), true);
  assert.equal(isLocale('fr'), false);
});

test('multilingual AI route validates supported languages and keeps user-scoped auth', async () => {
  const route = await readFile(new URL('../src/app/api/ai/assistant/route.ts', import.meta.url), 'utf8');
  assert.match(route, /requireUser\(\['student'\]\)/);
  assert.match(route, /z\.enum\(\['en', 'te', 'hi', 'ta'\]\)/);
  assert.match(route, /Preserve programming syntax, code, identifiers, commands, and standard technical keywords exactly/);
  assert.match(route, /student_skill_scores/);
});
