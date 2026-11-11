import type { NextConfig } from 'next';
const nextConfig: NextConfig = { outputFileTracingRoot: process.cwd(), distDir: '.next-phase5-workspace', experimental: { cpus: 1 } };
export default nextConfig;
