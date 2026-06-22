// lib/widgets/farmer_back_button.dart
import 'package:flutter/material.dart';

class FarmerBackButton extends StatelessWidget {
  const FarmerBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 22,
        color: Colors.white,
        weight: 900.0,
      ),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      splashRadius: 20,
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.white.withOpacity(0.12),
      ),
    );
  }
}

// Usage:
leading: const FarmerBackButton(),