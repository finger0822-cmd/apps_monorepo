// Supabase Edge Function: calls OpenAI and returns normalized JSON for Pulse Insights.
// OPENAI_API_KEY must be set via supabase secrets.

const OPENAI_URL = "https://api.openai.com/v1/chat/completions";
const SYSTEM_PROMPT = `You must respond with valid JSON only, no other text.
Format: {"summary": "one short summary sentence", "bullets": ["item1", "item2", "item3"]}.
Summary and bullets must be strings.`;

function corsHeaders(origin?: string): Record<string, string> {
  const o = origin ?? "*";
  return {
    "Access-Control-Allow-Origin": o,
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  };
}

interface RequestBody {
  model?: string;
  prompt?: string;
}

interface NormalizedOutput {
  summary: string;
  bullets: string[];
}

function normalizeLlmOutput(raw: string): NormalizedOutput {
  let parsed: unknown;
  try {
    parsed = JSON.parse(raw);
  } catch {
    const m = raw.match(/\{[\s\S]*\}/);
    if (m) {
      try {
        parsed = JSON.parse(m[0]);
      } catch {
        throw new Error("Failed to parse LLM output as JSON");
      }
    } else {
      throw new Error("No JSON object in LLM output");
    }
  }
  const obj = parsed as Record<string, unknown>;
  const summary = typeof obj.summary === "string" ? obj.summary : "";
  let bullets: string[] = [];
  if (Array.isArray(obj.bullets)) {
    bullets = obj.bullets.map((b) => (typeof b === "string" ? b : String(b)));
  } else if (typeof obj.bullets !== "undefined") {
    bullets = [String(obj.bullets)];
  }
  return { summary, bullets };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders(req.headers.get("origin") ?? "*") });
  }
  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Method not allowed" }),
      { status: 405, headers: { "Content-Type": "application/json", ...corsHeaders(req.headers.get("origin") ?? "*") } }
    );
  }

  const apiKey = Deno.env.get("OPENAI_API_KEY");
  if (!apiKey) {
    return new Response(
      JSON.stringify({ error: "OPENAI_API_KEY not configured" }),
      { status: 500, headers: { "Content-Type": "application/json", ...corsHeaders(req.headers.get("origin") ?? "*") } }
    );
  }

  let body: RequestBody;
  try {
    body = (await req.json()) as RequestBody;
  } catch {
    return new Response(
      JSON.stringify({ error: "Invalid JSON body" }),
      { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders(req.headers.get("origin") ?? "*") } }
    );
  }

  const model = typeof body.model === "string" ? body.model.trim() : "";
  const prompt = typeof body.prompt === "string" ? body.prompt.trim() : "";
  if (!model || !prompt) {
    return new Response(
      JSON.stringify({ error: "model and prompt are required" }),
      { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders(req.headers.get("origin") ?? "*") } }
    );
  }

  try {
    const res = await fetch(OPENAI_URL, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model,
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user", content: prompt },
        ],
        temperature: 0.2,
      }),
    });

    if (!res.ok) {
      const errText = await res.text();
      return new Response(
        JSON.stringify({ error: `OpenAI API error: ${res.status} ${errText.slice(0, 200)}` }),
        { status: 502, headers: { "Content-Type": "application/json", ...corsHeaders(req.headers.get("origin") ?? "*") } }
      );
    }

    const data = (await res.json()) as { choices?: Array<{ message?: { content?: string } }> };
    const content = data.choices?.[0]?.message?.content?.trim() ?? "";
    if (!content) {
      return new Response(
        JSON.stringify({ error: "Empty response from OpenAI" }),
        { status: 502, headers: { "Content-Type": "application/json", ...corsHeaders(req.headers.get("origin") ?? "*") } }
      );
    }

    const normalized = normalizeLlmOutput(content);
    const text = JSON.stringify({ summary: normalized.summary, bullets: normalized.bullets });

    return new Response(JSON.stringify({ text }), {
      status: 200,
      headers: { "Content-Type": "application/json", ...corsHeaders(req.headers.get("origin") ?? "*") },
    });
  } catch (e) {
    return new Response(
      JSON.stringify({ error: e instanceof Error ? e.message : "Failed to call OpenAI" }),
      { status: 500, headers: { "Content-Type": "application/json", ...corsHeaders(req.headers.get("origin") ?? "*") } }
    );
  }
});
