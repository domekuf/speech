// Import the Cloud Speech-to-Text library
const speech = require('@google-cloud/speech').v2;

// Instantiates a client
const client = new speech.SpeechClient();

// Your local audio file to transcribe
const audioFilePath = "gs://scriva/audio-files/verbale.wav";
// Full recognizer resource name
const recognizer = "projects/scriba-426116/locations/global/recognizers/_";
// The output path of the transcription result.
const workspace = "gs://scriva/transcripts";

const recognitionConfig = {
  explicitDecodingConfig: {
    encoding: "LINEAR16",
    sampleRateHertz: 48000,
    audioChannelCount: 1,
  },
  model: "long",
  languageCodes: ["it-IT"],
  features: {
  enableWordTimeOffsets: true,
  enable_word_confidence: true,
  enableAutomaticPunctuation: true,
  },
};

const audioFiles = [
  { uri: audioFilePath }
];
const outputPath = {
  gcsOutputConfig: {
    uri: workspace
  }
};

async function transcribeSpeech() {
  const transcriptionRequest = {
    recognizer: recognizer,
    config: recognitionConfig,
    files: audioFiles,
    recognitionOutputConfig: outputPath,
  };

  await client.batchRecognize(transcriptionRequest);
}

transcribeSpeech();
