// netlify/functions/api-chat.js
exports.handler = async (event) => {
  const CORS_HEADERS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
    "Access-Control-Allow-Methods": "POST, OPTIONS"
  };

  if (event.httpMethod === "OPTIONS") {
    return { statusCode: 200, headers: CORS_HEADERS, body: "" };
  }
  if (event.httpMethod !== "POST") {
    return {
      statusCode: 405,
      headers: CORS_HEADERS,
      body: JSON.stringify({ error: "Method not allowed" })
    };
  }

  let payload;
  try {
    payload = JSON.parse(event.body);
    if (!Array.isArray(payload.messages)) {
      throw new Error("`messages` must be an array");
    }
  } catch (err) {
    return {
      statusCode: 400,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      body: JSON.stringify({ error: "Invalid JSON payload", detail: err.message })
    };
  }

  const apiKey = process.env.OPENAI_API_KEY;
  const model = process.env.OPENAI_MODEL || "gpt-4o-mini";
  const systemPrompt = process.env.SYSTEM_PROMPT || "";

  if (!apiKey || !systemPrompt) {
    return {
      statusCode: 500,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      body: JSON.stringify({ error: "Missing env vars" })
    };
  }

  const incoming = payload.messages
    .filter(m => m.role === "user" || m.role === "assistant")
    .slice(-12);

  const builtPayload = {
    model,
    messages: [
      { role: "system", content: systemPrompt },
      ...incoming
    ]
  };

  try {
    const openaiRes = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${apiKey}`
      },
      body: JSON.stringify(builtPayload)
    });

    const data = await openaiRes.json();
    const content = data?.choices?.[0]?.message?.content || "";

    return {
      statusCode: 200,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      body: JSON.stringify({ content })
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      body: JSON.stringify({ error: err.toString() })
    };
  }
};