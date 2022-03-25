# Recognise speech.
import speech_recognition
# To play an audio file.
import playsound
# Google text to speech.
from gtts import gTTS
import random
# To remove created audio files.
import os


# Listen for audio and convert it to text.
def recordAudioInput(audioFile):
    # Initialise a recogniser.
    recognizer = speech_recognition.Recognizer()
    microphone = speech_recognition.Microphone()
    #recognizer.dynamic_energy_threshold = False
    recognizer.energy_threshold = 10000.0
    try:
        # Microphone as source.
        with microphone as source:
            # Listen for the audio via source.
            recognizer.adjust_for_ambient_noise(source,duration=0.5)
            audio = recognizer.listen(source,timeout=1)
            try:
                # Convert audio to text.
                voiceData = recognizer.recognize_google(audio)
                speakOutput(audioFile, voiceData)
            # Error: recognizer does not understand.
            except speech_recognition.UnknownValueError:
                voiceData = 'Sorry, I did not get that.'
                speakOutput(audioFile, voiceData)
            # Error: recognizer is not connected.
            except speech_recognition.RequestError:
                voiceData = 'Sorry, the service is down.'
                speakOutput(audioFile, voiceData)
            # Error: Unknown Errors.
            except:
                voiceData = 'Sorry, the service is down for an unknown reason.'
                speakOutput(audioFile, voiceData)
            return voiceData.lower()
    except:
        voiceData = ''
        return voiceData.lower()

# Get string and make a audio file to be played.
def speakOutput(audioFile,audioString):
    # Text to speech(voice).
    textToSpeech = gTTS(text=audioString, lang='en')
    # Save as mp3.
    textToSpeech.save(audioFile)
    # Play the audio f  le.
    playsound.playsound(audioFile)
    # Remove audio file.
    os.remove(audioFile)

#audioFile = r"test.mp3"
#recordAudioInput(audioFile)
#speakOutput(audioFile, 'matlab assistant is active')