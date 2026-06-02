import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/theme.dart';
import '../models/lesson.dart';
import '../providers/onboarding_provider.dart';
import 'tutor_chat_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const LessonPathPage(),
    const RolePage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStreakPopup();
    });
  }

  void _showStreakPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const StreakPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: Column(
          children: [
            if (_selectedIndex == 0) _buildLessonHeader(),
            if (_selectedIndex == 1) _buildRoleHeader(),
            if (_selectedIndex == 2) _buildProfileHeader(),
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildLessonHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.flag, color: Colors.red, size: 30),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lesson', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('B1 - B2', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const Spacer(),
          _buildStreakBadge(),
          const SizedBox(width: 12),
          _buildProBadge(),
        ],
      ),
    );
  }

  Widget _buildRoleHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Text('Role Play', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          const Spacer(),
          _buildStreakBadge(),
          const SizedBox(width: 12),
          _buildProBadge(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          const Spacer(),
          _buildProBadge(),
        ],
      ),
    );
  }

  Widget _buildStreakBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: const Row(
        children: [
          Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
          SizedBox(width: 4),
          Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text('PRO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_filled, 'Lesson'),
          _buildNavItem(1, Icons.chat_bubble_rounded, 'Role'),
          _buildNavItem(2, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFEDEEFD),
                borderRadius: BorderRadius.circular(30),
              )
            : const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade400, size: 22),
            if (isSelected)
              Text(label, style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 10, fontWeight: FontWeight.bold))
            else
              Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class LessonPathPage extends ConsumerStatefulWidget {
  const LessonPathPage({super.key});

  @override
  ConsumerState<LessonPathPage> createState() => _LessonPathPageState();
}

class _LessonPathPageState extends ConsumerState<LessonPathPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final userLevel = ref.watch(onboardingProvider).englishLevel;
    
    EnglishLevel level = EnglishLevel.beginner;
    if (userLevel.contains('Intermediate')) level = EnglishLevel.intermediate;
    if (userLevel.contains('Advanced')) level = EnglishLevel.advanced;

    final lessons = allLessons.where((l) => l.level == level).toList();

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 100, bottom: 40),
          child: Column(
            children: List.generate(lessons.length, (index) {
              double offset = (index % 2 == 0) ? -50 : 50;
              if (index == 0) offset = 0;
              
              return Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: offset > 0 ? offset * 2 : 0,
                  right: offset < 0 ? offset.abs() * 2 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorChatScreen(lesson: lessons[index]),
                      ),
                    );
                  },
                  child: _buildLessonNode(
                    lessons[index].title,
                    lessons[index].icon,
                    index == 0, // First one active for demo
                  ),
                ),
              );
            }),
          ),
        ),
        Positioned(
          top: 10,
          left: 20,
          right: 20,
          child: const ChloeBanner(),
        ),
      ],
    );
  }

  Widget _buildLessonNode(String title, IconData icon, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryBlue : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryBlue, width: 4),
              boxShadow: [
                BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Icon(icon, color: isActive ? Colors.white : AppTheme.primaryBlue, size: 30),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class ChloeBanner extends StatelessWidget {
  const ChloeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/onboarding_avatar.png'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chloe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('You can start the free talk with tutor', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.mic, color: Colors.white, size: 28),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const ChloeBanner(),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildTopicCard('Food & Dining', 'Ordering at a Restaurant', '🍜', '6 min'),
              _buildTopicCard('Travel & Tourism', 'Checking into a Hotel', '✈️', '4 min'),
              _buildTopicCard('Business Social', 'Networking at an Event', '💬', '11 min'),
              _buildTopicCard('Social & Friends', 'Making Weekend Plans', '🎊', '8 min'),
              _buildTopicCard('Career & Business', 'Acing the Job Interview', '👨‍💼', '12 min'),
              _buildTopicCard('Hobbies & Culture', 'Discussing Movies and Books', '🏛️', '8 min'),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTopicCard(String title, String subtitle, String icon, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle),
                child: const Center(child: Text('R', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey))),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Afternoon', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text('Raj', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('PERSONALIZE', style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _buildToggleItem('Learn in native language', '🧠', false),
            _buildSettingsItem('English Level', '🇬🇧', 'Intermediate'),
            _buildSettingsItem('Native Language', '🌍', 'English'),
            _buildSettingsItem('Interest', '🎱', 'Social & Dating'),
            _buildSettingsItem('Daily Goal', '🎯', '5 min / day'),
          ]),
          const SizedBox(height: 24),
          _buildSettingsGroup([
            _buildSettingsItem('Restore Purchase', '🔄', ''),
            _buildSettingsItem('Manage Subscription', '💳', ''),
            _buildSettingsItem('FAQ', '❓', ''),
            _buildSettingsItem('Feedback', '💌', ''),
            _buildSettingsItem('Rate Us', '⭐', ''),
            _buildSettingsItem('Terms of Use', '📋', ''),
            _buildSettingsItem('Privacy Policy', '🔒', ''),
          ]),
          const SizedBox(height: 24),
          _buildSettingsGroup([
            _buildSettingsItem('Instagram', '📸', ''),
            _buildSettingsItem('TikTok', '🎵', ''),
          ]),
          const SizedBox(height: 24),
          _buildSettingsGroup([
            _buildSettingsItem('User ID', '🆔', '3d31c9a07d98b...', isCopyable: true),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: items),
    );
  }

  Widget _buildSettingsItem(String label, String icon, String value, {bool isCopyable = false}) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(width: 8),
          Icon(isCopyable ? Icons.copy_rounded : Icons.chevron_right, size: 20, color: Colors.grey.shade400),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildToggleItem(String label, String icon, bool val) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: val,
        onChanged: (v) {},
        activeThumbColor: AppTheme.primaryBlue,
      ),
    );
  }
}

class StreakPopup extends StatelessWidget {
  const StreakPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ),
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 100),
          const SizedBox(height: 16),
          const Text('1 days streak!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Complete a lesson every day to\nbuild your streak!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 32),
          _buildStreakRow(),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue Learning'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStreakRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          bool isDay1 = index == 0;
          return Column(
            children: [
              Text('Day ${index + 1}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Icon(
                Icons.local_fire_department,
                color: isDay1 ? Colors.orange : Colors.grey.shade300,
                size: 30,
              ),
            ],
          );
        }),
      ),
    );
  }
}
