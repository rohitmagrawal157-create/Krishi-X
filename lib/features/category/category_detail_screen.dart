// lib/features/category/category_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/features/browse/browse_screen.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:krishix/l10n/l10n_lookup.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({
    super.key,
    required this.sectionId,
    required this.userLocation,
  });

  final String       sectionId;
  final UserLocation userLocation;

  void _openSubcategory(
    BuildContext context,
    CategoryDetail detail,
    String itemLabel,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BrowseScreen(
          initialCategory: detail.listingCategory,
          userLocation:    userLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = kCategoryDetails[sectionId];
    final l10n   = AppLocalizations.of(context)!;

    if (detail == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          // ── white back button, no icon in title ──
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Category'),
        ),
        body: const Center(
          child: Text('No subcategories available yet.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        // ── white back button ──
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // ── title text only — emoji + icon removed ──
        title: Text(
          l10nLookup(l10n, detail.titleKey),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize:   AppTextSize.title,
            color:      Colors.white,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: detail.groups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        // ── divider line removed ──
        itemBuilder: (context, index) {
          final group = detail.groups[index];
          return _SubcategoryGroupSection(
            group: group,
            l10n:  l10n,
            onItemTap: (item) => _openSubcategory(context, detail, item),
          );
        },
      ),
    );
  }
}

class _SubcategoryGroupSection extends StatelessWidget {
  const _SubcategoryGroupSection({
    required this.group,
    required this.l10n,
    required this.onItemTap,
  });

  final SubcategoryGroup     group;
  final AppLocalizations     l10n;
  final ValueChanged<String> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Group title — NO divider line ──
        Text(
          l10nLookup(l10n, group.titleKey),
          style: const TextStyle(
            fontSize:   16,
            fontWeight: FontWeight.w800,
            color:      AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),

        // ── Grid — same layout as home screen ──
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
              children: group.items.map((item) {
                final label = l10nLookup(l10n, item.labelKey);
                return SizedBox(
                  width:  itemW,
                  height: imgSize + 6 + labelH,
                  child: _SubcategoryTile(
                    item:    item,
                    label:   label,
                    imgSize: imgSize,
                    labelH:  labelH,
                    onTap:   () => onItemTap(label),
                  ),
                );
              }).toList(),
            );
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Tile — same style as _CategoryTile in home_screen ──
class _SubcategoryTile extends StatelessWidget {
  const _SubcategoryTile({
    required this.item,
    required this.label,
    required this.imgSize,
    required this.labelH,
    required this.onTap,
  });

  final SubcategoryItem item;
  final String          label;
  final double          imgSize;
  final double          labelH;
  final VoidCallback    onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:        onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize:       MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ── Square image — same as home ──────────────────
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
                item.imagePath,
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

          // ── Label — same as home ──────────────────────────
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