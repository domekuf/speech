source .env

curl --request POST \
      --url https://api.openai.com/v1/threads/thread_l4M9QhGTyPFUZVtaUrcu7ShE/runs \
      --header 'OpenAI-Beta: assistants=v2' \
      --header "Authorization: Bearer $OPENAI_API_KEY" \
      --header 'Content-Type: application/json' \
      --data '{
        "assistant_id": "asst_fm692P6o3XnBDfoyEOrTSK39"
      }'
