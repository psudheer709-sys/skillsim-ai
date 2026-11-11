import 'server-only';

export function getAiConfig() {
  const provider = (process.env.AI_PROVIDER || 'openai').trim().toLowerCase();
  const apiKey = process.env.OPENAI_API_KEY?.trim();
  const model = process.env.AI_MODEL?.trim();
  const configured = provider === 'openai' && Boolean(apiKey && model);
  return { provider, apiKey, model, configured };
}

export const AI_SETUP_MESSAGE = 'AI evaluation is not configured yet. Set OPENAI_API_KEY, AI_MODEL, and SUPABASE_SERVICE_ROLE_KEY in the server environment, then restart the app.';
