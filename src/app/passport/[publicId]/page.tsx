import { PublicSkillPassportView } from '@/components/phase4-views';

export default async function SharedPassportPage({ params }: { params: Promise<{ publicId: string }> }) {
  const { publicId } = await params;
  return <PublicSkillPassportView publicId={publicId} />;
}
