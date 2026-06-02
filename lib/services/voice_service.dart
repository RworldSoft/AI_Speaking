import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> init() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.4); // Slow and clear
    await _flutterTts.setPitch(1.1); // Slightly higher for a friendly female tone
    await _flutterTts.setVolume(1.0);
    
    // Attempt to set a female voice if available
    try {
      dynamic voices = await _flutterTts.getVoices;
      if (voices != null) {
        for (var voice in voices) {
          if (voice["name"].toString().toLowerCase().contains("female") || 
              voice["name"].toString().toLowerCase().contains("samantha") ||
              voice["name"].toString().toLowerCase().contains("google en-us-x-sfg-local")) {
            await _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
            break;
          }
        }
      }
    } catch (e) {
      print("Error setting specific voice: $e");
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

final voiceService = VoiceService();
