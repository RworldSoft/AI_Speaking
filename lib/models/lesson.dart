import 'package:flutter/material.dart';

enum EnglishLevel { beginner, intermediate, advanced }

class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String time;
  final EnglishLevel level;
  final List<String> vocabulary;
  final String objective;
  final String initialPrompt;
  final String targetPhrase;

  Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
    required this.level,
    required this.vocabulary,
    required this.objective,
    required this.initialPrompt,
    required this.targetPhrase,
  });
}

final List<Lesson> allLessons = [
  // Beginner (A1-A2)
  Lesson(
    id: 'b1',
    title: 'This is My...',
    subtitle: 'Greetings & Introduction',
    icon: Icons.book,
    time: '5 min',
    level: EnglishLevel.beginner,
    vocabulary: ['Hello', 'Hi', 'Good morning', 'Bye', 'See you', 'Nice', 'Meet', 'You'],
    objective: 'You\'ll be able to say: "Hi! Nice to meet you. Bye, see you!"',
    initialPrompt: 'Hello! I am Chloe, your friendly English tutor. Today, we will learn how to say hello and greet people. For example, "Hello, my name is Chloe." Now, say: Hello, my name is Chloe.',
    targetPhrase: 'Hello, my name is Chloe',
  ),
  Lesson(
    id: 'b2',
    title: 'How Are You?',
    subtitle: 'Expressing Feelings',
    icon: Icons.emoji_emotions,
    time: '4 min',
    level: EnglishLevel.beginner,
    vocabulary: ['Fine', 'Happy', 'Sad', 'Good', 'Great'],
    objective: 'Learn to express your current mood.',
    initialPrompt: 'Hi there! How are you feeling today?',
    targetPhrase: 'I am doing great',
  ),
  
  // Intermediate (B1-B2)
  Lesson(
    id: 'i1',
    title: 'Food & Dining',
    subtitle: 'Ordering at a Restaurant',
    icon: Icons.restaurant,
    time: '6 min',
    level: EnglishLevel.intermediate,
    vocabulary: ['Menu', 'Order', 'Delicious', 'Bill', 'Table'],
    objective: 'Confidently order food in a restaurant setting.',
    initialPrompt: 'Welcome to our restaurant! Are you ready to order?',
    targetPhrase: 'I would like to order a pizza',
  ),
  Lesson(
    id: 'i2',
    title: 'Travel & Tourism',
    subtitle: 'Checking into a Hotel',
    icon: Icons.flight,
    time: '8 min',
    level: EnglishLevel.intermediate,
    vocabulary: ['Reservation', 'Check-in', 'Key', 'Room', 'Stay'],
    objective: 'Manage hotel check-in procedures.',
    initialPrompt: 'Hello! Do you have a reservation under any name?',
    targetPhrase: 'I have a reservation under Mike',
  ),

  // Advanced (C1-C2)
  Lesson(
    id: 'a1',
    title: 'Business Social',
    subtitle: 'Networking at an Event',
    icon: Icons.handshake,
    time: '12 min',
    level: EnglishLevel.advanced,
    vocabulary: ['Strategy', 'Network', 'Partnership', 'Venture', 'Growth'],
    objective: 'Discuss business strategies in social settings.',
    initialPrompt: 'It\'s a pleasure to meet you. What do you think about the current market strategy?',
    targetPhrase: 'I believe our market strategy needs more innovation',
  ),
];
