# https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=streaming#authentication
# https://azure.microsoft.com/en-us/products/cognitive-services/text-to-speech/#features

token=`curl -v --http1.1 -X POST "https://eastasia.api.cognitive.microsoft.com/sts/v1.0/issueToken"  -H "Content-type: application/x-www-form-urlencoded" -H "Content-Length: 0" -H "Ocp-Apim-Subscription-Key: $AZURE_TTS_KEY"`
echo $token

curl -o out.wav -v --http1.1 -d @tts_input_2.xml "https://eastasia.tts.speech.microsoft.com/cognitiveservices/v1" \
-H "Content-type: application/ssml+xml" \
-H "X-Microsoft-OutputFormat: riff-24khz-16bit-mono-pcm" \
-H "Authorization: Bearer $token"

