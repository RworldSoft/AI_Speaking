import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/avatar_header.dart';
import '../widgets/bottom_card_container.dart';
import '../widgets/selection_button.dart';
import '../utils/theme.dart';
import 'onboarding_completion_screen.dart';
import '../services/voice_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  final List<String> _questions = [
    "What is your name?",
    "What is your native language?",
    "Have you ever taken lessons before?",
    "What is your English level?",
    "Which language skills are most important for you to improve?",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initVoice();
  }

  Future<void> _initVoice() async {
    await voiceService.init();
    // Speak first question after a short delay for the app to settle
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _speakCurrentQuestion();
    });
  }

  void _speakCurrentQuestion() {
    int index = _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;
    if (index < _questions.length) {
      voiceService.speak(_questions[index]);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController
        .nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((_) {
      _speakCurrentQuestion();
    });
  }

  void _previousPage() {
    if (_pageController.page! > 0) {
      _pageController
          .previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        _speakCurrentQuestion();
      });
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Avatar Header
          AvatarHeader(
            imagePath: 'assets/images/onboarding_avatar.png', // Placeholder path
            onBackTap: _previousPage,
          ),

          // Content Container
          Column(
            children: [
              const Spacer(flex: 3), // Push the card down
              Expanded(
                flex: 7,
                child: BottomCardContainer(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildNamePage(),
                            _buildLanguagePage(),
                            _buildPriorLessonsPage(),
                            _buildLevelPage(),
                            _buildSkillsPage(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Smooth Page Indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 5,
                        effect: const ScaleEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: AppTheme.primaryBlue,
                          dotColor: Colors.grey,
                          scale: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Individual Pages ---

  Widget _buildNamePage() {
    final name = ref.watch(onboardingProvider).name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your name?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) => ref.read(onboardingProvider.notifier).updateName(value),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: name.trim().isEmpty ? null : _nextPage,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagePage() {
    final selectedLanguage = ref.watch(onboardingProvider).nativeLanguage;
    final languages = ['English', 'Spanish', 'Chinese', 'French', 'German'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your native language?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              return SelectionButton(
                title: lang,
                isSelected: selectedLanguage == lang,
                onTap: () {
                  // State updates and navigates to the next page
                  ref.read(onboardingProvider.notifier).updateNativeLanguage(lang);
                  _nextPage();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriorLessonsPage() {
    final priorLessons = ref.watch(onboardingProvider).priorLessons;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Have you ever taken lessons before?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        SelectionButton(
          title: 'Yes',
          isSelected: priorLessons == true,
          onTap: () {
            ref.read(onboardingProvider.notifier).updatePriorLessons(true);
            _nextPage();
          },
        ),
        SelectionButton(
          title: 'No',
          isSelected: priorLessons == false,
          onTap: () {
            ref.read(onboardingProvider.notifier).updatePriorLessons(false);
            _nextPage();
          },
        ),
      ],
    );
  }

  Widget _buildLevelPage() {
    final selectedLevel = ref.watch(onboardingProvider).englishLevel;
    final levels = [
      'Beginner (A1-A2)',
      'Intermediate (B1-B2)',
      'Advanced (C1-C2)'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your English level?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final level = levels[index];
              return SelectionButton(
                title: level,
                isSelected: selectedLevel == level,
                onTap: () {
                  ref.read(onboardingProvider.notifier).updateEnglishLevel(level);
                  _nextPage();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsPage() {
    final selectedSkills = ref.watch(onboardingProvider).focusSkills;
    final skills = ['Speaking', 'Reading', 'Writing'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Which language skills are most important for you to improve?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: skills.length,
            itemBuilder: (context, index) {
              final skill = skills[index];
              return SelectionButton(
                title: skill,
                isSelected: selectedSkills.contains(skill),
                onTap: () {
                  // Multi-selection logic: toggles selection state
                  ref.read(onboardingProvider.notifier).toggleFocusSkill(skill);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: selectedSkills.isEmpty ? null : () {
              // Navigate to the completion sequence
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const OnboardingCompletionScreen(),
                ),
              );
            },
            child: const Text('Complete'),
          ),
        ),
      ],
    );
  }
}
