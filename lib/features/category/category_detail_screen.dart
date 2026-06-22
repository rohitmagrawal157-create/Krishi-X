// lib/features/category/category_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
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
    SubcategoryItem item,
    String itemLabel,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BrowseScreen(
          initialCategory: detail.listingCategory,
          initialListingType: _listingTypeForDetail(detail),
          initialDetailLabel: itemLabel,
          initialDetailKeywords: _keywordsForItem(item, itemLabel),
          userLocation: userLocation,
        ),
      ),
    );
  }

  ListingType? _listingTypeForDetail(CategoryDetail detail) {
    if (detail.listingCategory == ListingCategory.rental) return ListingType.rent;
    if (sectionId == CategorySectionId.agricultureLandLease) {
      return ListingType.rent;
    }
    return ListingType.sell;
  }

  List<String> _keywordsForItem(SubcategoryItem item, String itemLabel) {
    final baseKey = item.labelKey.replaceAll('_', ' ');
    final keywords = <String>{baseKey, item.labelKey, itemLabel};
    const aliases = <String, List<String>>{
      'mahindra': ['Mahindra'],
      'swaraj': ['Swaraj'],
      'onion': ['Onion'],
      'buffalo': ['Buffalo'],
      'rotavator': ['Rotavator'],
      'agricultural_land': ['Land'],
      'farm_house_land': ['Land'],
      'orchard_land': ['Land'],
      'land_for_lease': ['Land'],
      'partnership_farming': ['Land'],
    };

    keywords.addAll(aliases[item.labelKey] ?? const []);

    return keywords.toList(growable: false);
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
         leading: IconButton(
  icon: const Icon(
    Icons.arrow_back_ios_new_rounded,
    size: 22,
    color: Colors.white,
    weight: 900.0,
  ),
  onPressed: () => Navigator.of(context).pop(),
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
        leading: IconButton(
  icon: const Icon(
    Icons.arrow_back_ios_new_rounded,
    size: 22,
    color: Colors.white,
    weight: 900.0,
  ),
  onPressed: () => Navigator.of(context).pop(),
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
),
        title: Text(
          // l10nLookup handles all titleKeys; new rent keys fall
          // back gracefully to the key itself if not in ARB yet
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
        itemBuilder: (context, index) {
          final group = detail.groups[index];
          return _SubcategoryGroupSection(
            group: group,
            l10n:  l10n,
            onItemTap: (item, label) =>
                _openSubcategory(context, detail, item, label),
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
  final void Function(SubcategoryItem item, String label) onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10nLookup(l10n, group.titleKey),
          style: const TextStyle(
            fontSize:   16,
            fontWeight: FontWeight.w800,
            color:      AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            const cols     = 3;
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
                    onTap:   () => onItemTap(item, label),
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
                  fontSize:   12,
                  fontWeight: FontWeight.w700,
                  height:     1.25,
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


