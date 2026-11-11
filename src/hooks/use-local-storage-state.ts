'use client';
import { useEffect, useState } from 'react';
import { readJSON, writeJSON } from '@/lib/storage';

export function useLocalStorageState<T>(key: string, initialValue: T) {
  const [value, setValue] = useState(initialValue);
  useEffect(() => setValue(readJSON(key, initialValue)), [key]);
  function updateValue(next: T) {
    setValue(next);
    writeJSON(key, next);
  }
  return [value, updateValue] as const;
}
