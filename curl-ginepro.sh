x=$1
source .env
echo $OPENAI_API_KEY
curl --request POST \
  --url https://api.openai.com/v1/audio/transcriptions \
  --header "Authorization: Bearer $OPENAI_API_KEY" \
  --header 'Content-Type: multipart/form-data' \
  --form file=@ginepro/verb-$x.mp3 \
  --form model=whisper-1 \
  --form response_format=text > ginepro/verb-$x.txt
