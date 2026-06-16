// lib/features/category/tractor_picker_screen.dart
//
// Matches category_detail_screen.dart layout exactly.
// Shows two subcategory tiles: "Tractors" and "Spare Parts"
// using the same _SubcategoryTile / Wrap / grid as CategoryDetailScreen.

import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/category/category_detail_screen.dart';

// ─────────────────────────────────────────────────────────────
// DATA — two top-level picker items (no l10n needed, English only
//        but easy to add later)
// ─────────────────────────────────────────────────────────────
class _TractorPickerItem {
  const _TractorPickerItem({
    required this.label,
    required this.imagePath,
    required this.sectionId,
  });
  final String label;
  final String imagePath;
  final String sectionId;
}

const _kPickerItems = [
  _TractorPickerItem(
    label:     'Tractors',
    imagePath: 'assets/images/tractor.jpeg',
    sectionId: CategorySectionId.tractorsBuy,
  ),
  _TractorPickerItem(
    label:     'Spare Parts',
    imagePath: 'assets/sub_ctg/KrishiX_App-17.jpg',
    sectionId: CategorySectionId.tractorsParts,
  ),
];

// ─────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────
class TractorPickerScreen extends StatelessWidget {
  const TractorPickerScreen({super.key, required this.userLocation});

  final UserLocation userLocation;

  void _openSection(BuildContext context, String sectionId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CategoryDetailScreen(
          sectionId:    sectionId,
          userLocation: userLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ── AppBar — identical to CategoryDetailScreen ────────
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation:       0,
        centerTitle:     false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20, color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tractors',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize:   AppTextSize.title,
            color:      Colors.white,
          ),
        ),
      ),

      // ── Body — same padding as CategoryDetailScreen ───────
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── Section title — same style as group title ─────
          const Text(
            'Select Category',
            style: TextStyle(
              fontSize:   16,
              fontWeight: FontWeight.w800,
              color:      AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // ── Grid — exact same LayoutBuilder + Wrap ────────
          LayoutBuilder(
            builder: (context, constraints) {
              const cols     = 4;
              const hGap     = 10.0;
              const runGap   = 14.0;
              final totalGap = (cols - 1) * hGap;
              final itemW    = (constraints.maxWidth - totalGap) / cols;
              final imgSize  = itemW * 0.78;
              const labelH   = 30.0;

              return Wrap(
                spacing:    hGap,
                runSpacing: runGap,
                children: _kPickerItems.map((item) {
                  return SizedBox(
                    width:  itemW,
                    height: imgSize + 6 + labelH,
                    child: _PickerTile(
                      label:    item.label,
                      imgPath:  item.imagePath,
                      imgSize:  imgSize,
                      labelH:   labelH,
                      onTap:    () => _openSection(context, item.sectionId),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TILE — copy of _SubcategoryTile from category_detail_screen
// ─────────────────────────────────────────────────────────────
class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.label,
    required this.imgPath,
    required this.imgSize,
    required this.labelH,
    required this.onTap,
  });

  final String       label;
  final String       imgPath;
  final double       imgSize;
  final double       labelH;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:        onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize:       MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ── Square image — same as CategoryDetailScreen ───
          Container(
            width:  imgSize,
            height: imgSize,
            decoration: BoxDecoration(
              color:        const Color(0xFFEDF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.22),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                imgPath,
                fit:           BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.primaryGreen,
                  size:  imgSize * 0.45,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ── Label — same as CategoryDetailScreen ──────────
          SizedBox(
            height: labelH,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines:  2,
                overflow:  TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize:   11,
                  fontWeight: FontWeight.w700,
                  height:     1.3,
                  color:      AppColors.textPrimary,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}