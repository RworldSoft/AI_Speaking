import 'package:flutter/material.dart';

/// A widget that displays a header image covering the top 40% of the screen
/// with a back button in the top left corner.
class AvatarHeader extends StatelessWidget {
  /// The asset path for the header image.
  final String imagePath;

  /// Optional callback for the back button.
  final VoidCallback? onBackTap;

  const AvatarHeader({
    super.key,
    required this.imagePath,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Header Image
        SizedBox(
          height: size.height * 0.4,
          width: double.infinity,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.blue.shade100,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
        // Back Button
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: onBackTap ?? () => Navigator.maybePop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
