import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State model for the onboarding flow.
class OnboardingState {
  final String name;
  final String nativeLanguage;
  final bool? priorLessons;
  final String englishLevel;
  final List<String> focusSkills;
  final List<String> topics;

  OnboardingState({
    this.name = '',
    this.nativeLanguage = '',
    this.priorLessons,
    this.englishLevel = '',
    this.focusSkills = const [],
    this.topics = const [],
  });

  OnboardingState copyWith({
    String? name,
    String? nativeLanguage,
    bool? priorLessons,
    String? englishLevel,
    List<String>? focusSkills,
    List<String>? topics,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      priorLessons: priorLessons ?? this.priorLessons,
      englishLevel: englishLevel ?? this.englishLevel,
      focusSkills: focusSkills ?? this.focusSkills,
      topics: topics ?? this.topics,
    );
  }
}

/// Notifier to manage onboarding state updates.
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateNativeLanguage(String language) {
    state = state.copyWith(nativeLanguage: language);
  }

  void updatePriorLessons(bool prior) {
    state = state.copyWith(priorLessons: prior);
  }

  void updateEnglishLevel(String level) {
    state = state.copyWith(englishLevel: level);
  }

  void toggleFocusSkill(String skill) {
    final currentSkills = List<String>.from(state.focusSkills);
    if (currentSkills.contains(skill)) {
      currentSkills.remove(skill);
    } else {
      currentSkills.add(skill);
    }
    state = state.copyWith(focusSkills: currentSkills);
  }

  void updateTopics(List<String> topics) {
    state = state.copyWith(topics: topics);
  }
}

/// Provider for the onboarding state.
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
