source .env
curl https://api.openai.com/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "Un fonico vestito in nero, che usa un mixer ad un concerto in spiaggia con un gin tonic appoggiato al tavolo",
    "n": 1,
    "size": "1024x1024"
  }'
