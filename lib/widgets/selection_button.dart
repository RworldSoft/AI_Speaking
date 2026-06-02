import 'package:flutter/material.dart';
import '../utils/theme.dart';

/// A custom styled button for list options in the onboarding flow.
/// It supports leading icons (flags/emojis), trailing widgets (counters/checkmarks),
/// and visual changes based on selection state.
class SelectionButton extends StatelessWidget {
  /// The main text label for the button.
  final String title;

  /// Optional widget displayed at the start of the button (e.g., a flag or emoji).
  final Widget? leadingIcon;

  /// Optional widget displayed at the end of the button (e.g., user count or checkmark).
  final Widget? trailingWidget;

  /// Whether the button is currently selected.
  final bool isSelected;

  /// Callback when the button is tapped.
  final VoidCallback onTap;

  const SelectionButton({
    super.key,
    required this.title,
    required this.onTap,
    this.leadingIcon,
    this.trailingWidget,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryBlue.withOpacity(0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade200,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppTheme.primaryBlue : Colors.black87,
                  ),
                ),
              ),
              if (trailingWidget != null) ...[
                const SizedBox(width: 8),
                trailingWidget!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
