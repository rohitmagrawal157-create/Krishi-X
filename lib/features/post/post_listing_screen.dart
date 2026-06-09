import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/l10n/app_localizations.dart';

class PostListingScreen extends StatefulWidget {
  const PostListingScreen({super.key});

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  ListingCategory _category = ListingCategory.tractors;
  ListingType _type = ListingType.sell;

  String _categoryLabel(AppLocalizations l10n, ListingCategory category) {
    switch (category) {
      case ListingCategory.tractors:
        return l10n.categoryTractors;
      case ListingCategory.crops:
        return l10n.categoryCrops;
      case ListingCategory.livestock:
        return l10n.categoryLivestock;
      case ListingCategory.land:
        return l10n.categoryLand;
      case ListingCategory.rental:
        return l10n.categoryRental;
    }
  }

  void _submit(AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.comingSoon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.postListing)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l10n.postListingSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.categories, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: ListingCategory.values.map((category) {
              return ChoiceChip(
                avatar: Icon(category.icon, size: 18, color: category.color),
                label: Text(_categoryLabel(l10n, category)),
                selected: _category == category,
                onSelected: (_) => setState(() => _category = category),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          SegmentedButton<ListingType>(
            segments: const [
              ButtonSegment(value: ListingType.sell, label: Text('Sell')),
              ButtonSegment(value: ListingType.rent, label: Text('Rent')),
            ],
            selected: {_type},
            onSelectionChanged: (selection) {
              setState(() => _type = selection.first);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            decoration: InputDecoration(labelText: l10n.listingTitle),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.listingPrice),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            decoration: InputDecoration(labelText: l10n.listingLocation),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(labelText: l10n.listingDescription),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Add Photos'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSpacing.minTouchTarget),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => _submit(l10n),
            child: Text(l10n.submitListing),
          ),
        ],
      ),
    );
  }
}
