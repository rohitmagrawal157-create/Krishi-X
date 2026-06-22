// lib/features/wishlist/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/l10n/app_localizations.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation:       0,
        title: const Text(
          'Saved Items',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width:  100,
                height: 100,
                decoration: BoxDecoration(
                  color:        const Color(0xFFEDF7ED),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.favorite_border_rounded,
                  size:  48,
                  color: AppColors.primaryGreen.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No saved items yet',
                style: TextStyle(
                  fontSize:   20,
                  fontWeight: FontWeight.w800,
                  color:      AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Items you save will appear here.\nTap the heart icon on any listing to save it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color:    Colors.grey.shade600,
                  height:   1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon:  const Icon(Icons.search_rounded),
                label: const Text(
                  'Browse Listings',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}