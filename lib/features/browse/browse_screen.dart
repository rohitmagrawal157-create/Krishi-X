import 'dart:async';

import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/data/listing_feed.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/core/models/user_location.dart';
import 'package:krishix/core/widgets/listing_widgets.dart';
import 'package:krishix/l10n/app_localizations.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({
    super.key,
    this.initialCategory,
    this.userLocation,
  });

  final ListingCategory? initialCategory;
  final UserLocation? userLocation;

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late ListingCategory? _selectedCategory;
  var _verifiedOnly = false;
  final _items = <Listing>[];
  var _page = 0;
  var _isLoadingMore = false;
  var _hasMore = true;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String _) {
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), _resetAndSearch);
  }

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

  void _onScroll() {
    if (!_hasMore || _isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _resetAndSearch() {
    setState(() {
      _page = 0;
      _items.clear();
      _hasMore = true;
    });
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(milliseconds: 180));

    final batch = ListingFeed.fetchPage(
      _page,
      searchQuery: _searchController.text,
      category: _selectedCategory,
      verifiedOnly: _verifiedOnly,
      userLocation: widget.userLocation,
    );

    if (!mounted) return;
    setState(() {
      _items.addAll(batch);
      _page++;
      _isLoadingMore = false;
      _hasMore = batch.length == ListingFeed.pageSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final location = widget.userLocation;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(l10n.browse)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 17),
              decoration: InputDecoration(
                hintText: l10n.searchPlaceholder,
                prefixIcon: const Icon(Icons.search, size: 28),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _resetAndSearch();
                        },
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (location != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primaryGreen),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: Text(l10n.filterAll),
                    selected: _selectedCategory == null,
                    onSelected: (_) {
                      setState(() => _selectedCategory = null);
                      _resetAndSearch();
                    },
                  ),
                ),
                ...ListingCategory.values.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      avatar: Icon(category.icon, size: 18, color: category.color),
                      label: Text(_categoryLabel(l10n, category)),
                      selected: _selectedCategory == category,
                      onSelected: (_) {
                        setState(() => _selectedCategory = category);
                        _resetAndSearch();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: FilterChip(
              label: Text(l10n.filterVerified),
              selected: _verifiedOnly,
              onSelected: (value) {
                setState(() => _verifiedOnly = value);
                _resetAndSearch();
              },
              avatar: const Icon(Icons.verified, size: 18),
            ),
          ),
          Expanded(
            child: _items.isEmpty && !_isLoadingMore
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        l10n.noListingsYet,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _items.length + (_isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      if (index >= _items.length) {
                        return Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 12),
                              Text(l10n.loadingMore),
                            ],
                          ),
                        );
                      }
                      return ListingCard(listing: _items[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
