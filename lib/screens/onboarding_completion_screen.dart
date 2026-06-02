import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'main_screen.dart';

enum CompletionStep { loadingPlan, planReady, aiTutorLoading }

class OnboardingCompletionScreen extends StatefulWidget {
  const OnboardingCompletionScreen({super.key});

  @override
  State<OnboardingCompletionScreen> createState() => _OnboardingCompletionScreenState();
}

class _OnboardingCompletionScreenState extends State<OnboardingCompletionScreen>
    with SingleTickerProviderStateMixin {
  CompletionStep _currentStep = CompletionStep.loadingPlan;
  double _progress = 0.0;
  bool _step1Checked = false;
  bool _step2Checked = false;
  bool _step3Checked = false;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {
          _progress = _progressController.value;
          if (_progress > 0.3) _step1Checked = true;
          if (_progress > 0.6) _step2Checked = true;
          if (_progress > 0.9) _step3Checked = true;
        });
      });

    _startPlanCreation();
  }

  void _startPlanCreation() async {
    await _progressController.forward();
    setState(() {
      _currentStep = CompletionStep.planReady;
    });
  }

  void _goToAiTutorLoading() {
    setState(() {
      _currentStep = CompletionStep.aiTutorLoading;
    });
    // Final transition to main screen after some time
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(),
              if (_currentStep == CompletionStep.loadingPlan || _currentStep == CompletionStep.planReady)
                _buildPlanCreationView()
              else
                _buildAiTutorView(),
              const Spacer(),
              if (_currentStep == CompletionStep.planReady)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _goToAiTutorLoading,
                    child: const Text('Continue'),
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCreationView() {
    return Column(
      children: [
        // Circular Progress or Checkmark
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade100,
                color: AppTheme.primaryBlue,
              ),
            ),
            if (_currentStep == CompletionStep.planReady)
              const Icon(Icons.check, size: 80, color: AppTheme.primaryBlue)
            else
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
              ),
          ],
        ),
        const SizedBox(height: 60),
        const Text(
          'Based on your input, we\'ve\ncreated a customized\nlearning plan for you!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
        ),
        const SizedBox(height: 40),
        _buildCheckItem('Selecting topics for you', _step1Checked),
        _buildCheckItem('Customizing the program', _step2Checked),
        _buildCheckItem('Your Proficiency Level', _step3Checked),
      ],
    );
  }

  Widget _buildCheckItem(String title, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check : Icons.circle,
            size: 20,
            color: isChecked ? AppTheme.primaryBlue : Colors.grey.shade300,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isChecked ? Colors.black87 : Colors.grey.shade500,
              fontWeight: isChecked ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiTutorView() {
    return Column(
      children: [
        // AI Avatar Placeholder
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryBlue.withOpacity(0.1),
            border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2), width: 10),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/onboarding_avatar.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.face, size: 80, color: AppTheme.primaryBlue),
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Ai Tutor Loading...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'We\'re personalizing your lessons and practice\nplan for you.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 60),
        // Conversation Tip
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.yellow.shade800, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Conversation Tip',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Press and hold to say something.\nExample: "I want to practice speaking."',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
