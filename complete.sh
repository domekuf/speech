source .env
text=$(cat ginepro-text/*)
escaped_text=$(printf '%s' "$text" | jq -Rsa .)
curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "gpt-4o-mini",
    "messages": [
      {
        "role": "system",
        "content": "Leggi il trascritto della riunione e scrivi un verbale, capendo ordine del giorno, decisioni prese e scadenze"
      },
      {
        "role": "user",
        "content": '"$escaped_text"'
	  }
    ]
  }'

  # "content": "Leggi il trascritto della riunione e scrivi un verbale, capendo ordine del giorno, decisioni prese e scadenze"
