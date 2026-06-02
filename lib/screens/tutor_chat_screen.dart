import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/lesson.dart';
import '../services/voice_service.dart';
import '../widgets/interactive_avatar.dart';
import '../utils/theme.dart';

class TutorChatScreen extends ConsumerStatefulWidget {
  final Lesson lesson;
  const TutorChatScreen({super.key, required this.lesson});

  @override
  ConsumerState<TutorChatScreen> createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends ConsumerState<TutorChatScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _userText = "";
  bool _isSpeaking = false;
  bool _isFullScreen = false;
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _startLesson();
  }

  void _startLesson() async {
    setState(() {
      _messages.add({"role": "chloe", "text": widget.lesson.initialPrompt});
      _isSpeaking = true;
    });
    await voiceService.speak(widget.lesson.initialPrompt);
    if (mounted) setState(() => _isSpeaking = false);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _userText = val.recognizedWords;
            if (val.finalResult) {
              _isListening = false;
              _handleUserInput(_userText);
            }
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _handleUserInput(String input) async {
    if (input.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": input});
    });

    // Simple Validation Logic
    String feedback;
    bool isCorrect = input.toLowerCase().contains(widget.lesson.targetPhrase.toLowerCase());

    if (isCorrect) {
      feedback = "Great! \"${widget.lesson.targetPhrase.split(' ')[0]}\" means a friendly greeting. Now, please say \"Hello, Anna!\"";
    } else {
      feedback = "Not quite. Try again! Say exactly: \"${widget.lesson.targetPhrase}\"";
    }

    setState(() {
      _messages.add({"role": "chloe", "text": feedback});
      _isSpeaking = true;
    });

    await voiceService.speak(feedback);
    if (mounted) setState(() => _isSpeaking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isFullScreen ? Colors.black : const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(_isFullScreen ? "" : widget.lesson.title),
        backgroundColor: _isFullScreen ? Colors.transparent : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: _isFullScreen ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Chloe Avatar Area
          Expanded(
            flex: _isFullScreen ? 10 : 4,
            child: Center(
              child: InteractiveAvatar(
                imagePath: 'assets/images/onboarding_avatar.png',
                isSpeaking: _isSpeaking,
                size: _isFullScreen ? MediaQuery.of(context).size.width : 200,
              ),
            ),
          ),

          // Chat/Interaction Area
          if (!_isFullScreen)
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isChloe = msg["role"] == "chloe";
                          return _buildMessageBubble(msg["text"]!, isChloe);
                        },
                      ),
                    ),
                    _buildInputArea(),
                  ],
                ),
              ),
            ),
          
          if (_isFullScreen)
            _buildFullScreenControls(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isChloe) {
    return Align(
      alignment: isChloe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isChloe ? Colors.grey.shade100 : AppTheme.primaryBlue,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft: isChloe ? const Radius.circular(0) : const Radius.circular(20),
            bottomRight: isChloe ? const Radius.circular(20) : const Radius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isChloe ? Colors.black87 : Colors.white),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.keyboard, () {
            // Show text input dialog
            _showTypeDialog();
          }),
          _buildMicButton(),
          _buildActionButton(Icons.videocam, () {
            setState(() => _isFullScreen = !_isFullScreen);
          }),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _listen,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isListening ? Colors.red : AppTheme.primaryBlue,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.3), blurRadius: 15)],
        ),
        child: Icon(_isListening ? Icons.stop : Icons.mic, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, color: Colors.grey, size: 24),
      ),
    );
  }

  Widget _buildFullScreenControls() {
    return Container(
      padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close_fullscreen, color: Colors.white, size: 30),
            onPressed: () => setState(() => _isFullScreen = false),
          ),
          _buildMicButton(),
          const SizedBox(width: 50), // Spacer
        ],
      ),
    );
  }

  void _showTypeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(hintText: "Type your answer..."),
                  autofocus: true,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: AppTheme.primaryBlue),
                onPressed: () {
                  final text = _textController.text;
                  _textController.clear();
                  Navigator.pop(context);
                  _handleUserInput(text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
