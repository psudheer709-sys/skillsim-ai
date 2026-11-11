import './globals.css';
import type { Metadata } from 'next';
import { LocaleProvider } from '@/components/locale-provider';
export const metadata: Metadata = { title: 'SkillSim AI — Practice Real Skills', description: 'AI-powered workplace simulations and skill development.' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="en"><body><LocaleProvider>{children}</LocaleProvider></body></html>; }
