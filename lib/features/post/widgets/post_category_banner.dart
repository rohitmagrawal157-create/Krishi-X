import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFFF6B00);

class PostCategoryBanner extends StatelessWidget {
  const PostCategoryBanner({
    super.key,
    required this.config,
    required this.categoryLabel,
  });

  final PostFormConfig config;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    final isRent = config.isRent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isRent
              ? [const Color(0xFFE65100), _kOrange]
              : [const Color(0xFF2E7D32), _kGreen],
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ── icon / image container ──────────────────────────
          Container(
            width:  48,
            height: 48,
            decoration: BoxDecoration(
              color:        Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: config.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      config.imagePath!,
                      width:  48,
                      height: 48,
                      fit:    BoxFit.cover,
                    ),
                  )
                : Icon(config.icon, color: Colors.white, size: 26),
          ),
          // ───────────────────────────────────────────────────
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryLabel,
                  style: const TextStyle(
                    color:      Colors.white,
                    fontSize:   15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isRent ? 'Rental listing' : 'For sale listing',
                  style: TextStyle(
                    color:    Colors.white.withOpacity(0.80),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:        Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.40)),
            ),
            child: Text(
              isRent ? 'Rent' : 'Sell',
              style: const TextStyle(
                color:      Colors.white,
                fontSize:   10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}