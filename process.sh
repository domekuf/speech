#!/bin/bash
source .env

# Directory di input e output
INPUT_DIR="ginepro-audio"
OUTPUT_DIR="ginepro-part"
TRANSCRIBE_DIR="ginepro-text"
PROCESSED_LOG="processed_files.log"

# Crea le directory di output se non esistono
mkdir -p "$OUTPUT_DIR"
mkdir -p "$TRANSCRIBE_DIR"

# File di log per tracciare i file gia trascritti
touch "$PROCESSED_LOG"

# Funzione per controllare e dividere i file WAV
process_file() {
    local file="$1"
    
    # Ottieni la dimensione del file in MB
    local filesize_mb=$(du -m "$file" | cut -f1)

    # Se il file supera i 5 MB, procedi alla suddivisione
    if [ "$filesize_mb" -gt 5 ]; then
        # Suddividi il file usando ffmpeg
        ffmpeg -i "$file" -f segment -segment_time 120 -c copy "$OUTPUT_DIR/$(basename "$file" .wav)_part_%03d.wav"
        
        # Trascrivi i file generati
        for part_file in "$OUTPUT_DIR"/*; do
            local part_filename=$(basename "$part_file")
            # Controlla se il file è ga  stato processato
            if ! grep -q "$part_filename" "$PROCESSED_LOG"; then
                echo "Trascrizione del file: $part_filename"

                # Esegui la richiesta CURL
                curl --request POST \
                    --url https://api.openai.com/v1/audio/transcriptions \
                    --header "Authorization: Bearer $OPENAI_API_KEY" \
                    --header 'Content-Type: multipart/form-data' \
                    --form file=@"$part_file" \
                    --form model=whisper-1 \
                    --form response_format=text > "$TRANSCRIBE_DIR/$part_filename.txt"

                # Controlla se la trascrizione è andata a buon fine
                if [ $? -eq 0 ]; then
                    echo "Trascrizione completata per $part_filename"

                    # Registra il file come processato
                    echo "$part_filename" >> "$PROCESSED_LOG"

                    # Cancella il file dopo la trascrizione
                    rm "$part_file"
                else
                    echo "Errore nella trascrizione di $part_filename"
                fi
            else
                echo "Il file $part_filename è ga stato trascritto."
            fi
        done
    fi
}

# Monitoraggio della cartella
while true; do
    # Controlla i file WAV nella directory
    for wav_file in "$INPUT_DIR"/*.wav; do
        [ -e "$wav_file" ] || continue  # Salta se non ci sono file
        process_file "$wav_file"
    done
    # Aspetta 10 secondi prima di controllare di nuovo
    sleep 10
done

