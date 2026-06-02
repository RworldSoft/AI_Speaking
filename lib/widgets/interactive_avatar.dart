import 'dart:async';
import 'package:flutter/material.dart';

class InteractiveAvatar extends StatefulWidget {
  final String imagePath;
  final bool isSpeaking;
  final double size;

  const InteractiveAvatar({
    super.key,
    required this.imagePath,
    this.isSpeaking = false,
    this.size = 250,
  });

  @override
  State<InteractiveAvatar> createState() => _InteractiveAvatarState();
}

class _InteractiveAvatarState extends State<InteractiveAvatar> {
  bool _isBlinking = false;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _startBlinkingLogic();
  }

  void _startBlinkingLogic() {
    // Randomize blink interval between 2 to 5 seconds
    _blinkTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && !widget.isSpeaking) {
        setState(() => _isBlinking = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) setState(() => _isBlinking = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Avatar Image
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: Image.asset(
              widget.imagePath,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.cover,
            ),
          ),

          // Speaking Animation Overlay (Simple Pulse or Scale Effect)
          if (widget.isSpeaking)
            _SpeakingEffect(size: widget.size),

          // Blink Overlay (Slight darkening of eye area or subtle shift)
          if (_isBlinking)
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.05),
              ),
            ),
        ],
      ),
    );
  }
}

class _SpeakingEffect extends StatefulWidget {
  final double size;
  const _SpeakingEffect({required this.size});

  @override
  State<_SpeakingEffect> createState() => _SpeakingEffectState();
}

class _SpeakingEffectState extends State<_SpeakingEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 4),
        ),
      ),
    );
  }
}
