export function withStableDuplicateKeys(values: readonly string[], scope: string) {
  const occurrences = new Map<string, number>();

  return values.map((value) => {
    const occurrence = occurrences.get(value) ?? 0;
    occurrences.set(value, occurrence + 1);

    return {
      value,
      key: JSON.stringify([scope, value, occurrence]),
    };
  });
}
