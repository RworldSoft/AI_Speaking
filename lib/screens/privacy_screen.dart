import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';
import 'onboarding_screen.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  Future<void> _acceptPrivacy(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('privacy_accepted', true);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Welcome to Better Speak',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'B',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  'AI Voice\nProcessing & Privacy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'To provide our AI-powered features, we process the audio recordings you provide. This data is securely transmitted to and processed by our third-party provider, OpenAI, solely for the purpose of generating transcripts, summaries, and AI-driven insights within the app.',
                  style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 20),
                const Text(
                  'We do not sell your personal information, and your audio data is never used for advertising purposes.',
                  style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 20),
                const Text(
                  'By tapping Agree & Continue, you explicitly consent to the collection and processing of your audio files and the secure transmission of this data to OpenAI for processing. If you do not agree, you will not be able to access Al-powered features.',
                  style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 30),
                const Text(
                  'For more details, read full Privacy Policy.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _acceptPrivacy(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Agree & Continue',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
