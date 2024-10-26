source .env
echo $OPENAI_API_KEY
curl --request POST \
  --url https://api.openai.com/v1/audio/transcriptions \
  --header "Authorization: Bearer $OPENAI_API_KEY" \
  --header 'Content-Type: multipart/form-data' \
  --form file=@ginepro-part/part001.wav \
  --form model=whisper-1 \
  --form response_format=text
