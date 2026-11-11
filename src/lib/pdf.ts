function escaped(value: string) {
  return value.normalize('NFKD').replace(/[^\x20-\x7E]/g, '').replace(/[\\()]/g, '\\$&').slice(0, 150);
}

export function makeSimplePdf(lines: string[]) {
  const encoder = new TextEncoder();
  const commands = lines.slice(0, 16).map((line, index) => `BT /F1 ${index === 0 ? 20 : 11} Tf 56 ${740 - index * 38} Td (${escaped(line)}) Tj ET`).join('\n');
  const objects = [
    '<< /Type /Catalog /Pages 2 0 R >>',
    '<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
    '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>',
    `<< /Length ${encoder.encode(commands).length} >>\nstream\n${commands}\nendstream`,
  ];
  let document = '%PDF-1.4\n'; const offsets = [0];
  for (let i = 0; i < objects.length; i++) { offsets.push(encoder.encode(document).length); document += `${i + 1} 0 obj\n${objects[i]}\nendobj\n`; }
  const xref = encoder.encode(document).length;
  document += `xref\n0 ${objects.length + 1}\n0000000000 65535 f \n${offsets.slice(1).map(offset => `${String(offset).padStart(10, '0')} 00000 n \n`).join('')}trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xref}\n%%EOF`;
  return encoder.encode(document);
}
