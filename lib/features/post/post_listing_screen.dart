// lib/features/post/post_listing_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/l10n/app_localizations.dart';

const Color _kOrange = Color(0xFFFF6B00);

class PostListingScreen extends StatefulWidget {
  const PostListingScreen({super.key});

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  ListingCategory _category = ListingCategory.tractors;
  ListingType     _type     = ListingType.sell;

  final _titleCtr    = TextEditingController();
  final _priceCtr    = TextEditingController();
  final _locationCtr = TextEditingController();
  final _descCtr     = TextEditingController();
  final _formKey     = GlobalKey<FormState>();
  bool  _isSubmitting = false;

  @override
  void dispose() {
    _titleCtr.dispose();
    _priceCtr.dispose();
    _locationCtr.dispose();
    _descCtr.dispose();
    super.dispose();
  }

  String _categoryLabel(AppLocalizations l10n, ListingCategory category) {
    switch (category) {
      case ListingCategory.tractors: return l10n.categoryTractors;
      case ListingCategory.crops:    return l10n.categoryCrops;
      case ListingCategory.livestock:return l10n.categoryLivestock;
      case ListingCategory.land:     return l10n.categoryLand;
      case ListingCategory.rental:   return l10n.categoryRental;
    }
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    // TODO: send to backend
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.comingSoon),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.postListing,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Banner ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end:   Alignment.bottomRight,
                    colors: [_kOrange, Color(0xFFFFB347)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color:        Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.sell_rounded,
                        size: 28, color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.postListing,
                            style: const TextStyle(
                              color:      Colors.white,
                              fontSize:   16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.postListingSubtitle,
                            style: const TextStyle(
                              color:    Colors.white,
                              fontSize: 12.5,
                              height:   1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Category ─────────────────────────────────
              _FieldLabel(
                  label: l10n.categories,
                  icon:  Icons.category_outlined),
              const SizedBox(height: 10),
              Wrap(
                spacing:    8,
                runSpacing: 8,
                children: ListingCategory.values.map((cat) {
                  final sel = _category == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: sel
                            ? const LinearGradient(
                                colors: [_kOrange, Color(0xFFFFB347)],
                              )
                            : null,
                        color: sel ? null : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: sel
                              ? Colors.transparent
                              : Colors.grey.shade300,
                          width: 1.2,
                        ),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                  color: _kOrange.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat.icon,
                              size:  16,
                              color: sel ? Colors.white : cat.color),
                          const SizedBox(width: 6),
                          Text(
                            _categoryLabel(l10n, cat),
                            style: TextStyle(
                              fontSize:   13,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // ── Sell / Rent toggle ────────────────────────
              _FieldLabel(
                  label: 'Listing Type',
                  icon:  Icons.swap_horiz_rounded),
              const SizedBox(height: 10),
              Row(
                children: [
                  _TypeToggle(
                    label:    'Sell',
                    icon:     Icons.sell_outlined,
                    selected: _type == ListingType.sell,
                    onTap:    () => setState(() => _type = ListingType.sell),
                  ),
                  const SizedBox(width: 12),
                  _TypeToggle(
                    label:    'Rent',
                    icon:     Icons.handshake_outlined,
                    selected: _type == ListingType.rent,
                    onTap:    () => setState(() => _type = ListingType.rent),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Title ────────────────────────────────────
              _FieldLabel(
                  label: l10n.listingTitle,
                  icon:  Icons.title_rounded),
              const SizedBox(height: 8),
              _Field(
                controller:     _titleCtr,
                hint:           'e.g. Mahindra Tractor 575 DI',
                capitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Title is required' : null,
              ),

              const SizedBox(height: 18),

              // ── Price ─────────────────────────────────────
              _FieldLabel(
                  label: l10n.listingPrice,
                  icon:  Icons.currency_rupee_rounded),
              const SizedBox(height: 8),
              _Field(
                controller:      _priceCtr,
                hint:            'Enter price in ₹',
                prefixText:      '₹ ',
                keyboardType:    TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Price is required' : null,
              ),

              const SizedBox(height: 18),

              // ── Location ──────────────────────────────────
              _FieldLabel(
                  label: l10n.listingLocation,
                  icon:  Icons.location_on_outlined),
              const SizedBox(height: 8),
              _Field(
                controller: _locationCtr,
                hint:       'Village / Taluka / District',
                validator:  (v) => (v == null || v.trim().isEmpty)
                    ? 'Location is required' : null,
              ),

              const SizedBox(height: 18),

              // ── Description ───────────────────────────────
              _FieldLabel(
                  label: l10n.listingDescription,
                  icon:  Icons.description_outlined),
              const SizedBox(height: 8),
              TextFormField(
                controller:  _descCtr,
                minLines:    3,
                maxLines:    5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText:  'Describe your listing in detail...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontSize: 14),
                  filled:         true,
                  fillColor:      Colors.white,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: _kOrange, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required' : null,
              ),

              const SizedBox(height: 18),

              // ── Add Photos ────────────────────────────────
              _FieldLabel(
                  label: 'Photos',
                  icon:  Icons.photo_library_outlined),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {}, // TODO: image picker
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color:        Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined,
                          size: 28, color: _kOrange),
                      const SizedBox(height: 6),
                      Text(
                        'Tap to add photos',
                        style: TextStyle(
                          fontSize:   13,
                          color:      Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Submit button ─────────────────────────────
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _submit(l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:         _kOrange,
                    foregroundColor:         Colors.white,
                    disabledBackgroundColor: _kOrange.withOpacity(0.6),
                    elevation:   3,
                    shadowColor: _kOrange.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.upload_rounded, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              l10n.submitListing,
                              style: const TextStyle(
                                fontSize:   16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Your listing will be reviewed before going live.',
                  style: TextStyle(
                    fontSize: 13,
                    color:    Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sell / Rent toggle button
// ─────────────────────────────────────────────────────────────
class _TypeToggle extends StatelessWidget {
  const _TypeToggle({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String       label;
  final IconData     icon;
  final bool         selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [_kOrange, Color(0xFFFFB347)],
                  )
                : null,
            color:        selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.transparent : Colors.grey.shade300,
              width: 1.2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color:      _kOrange.withOpacity(0.25),
                      blurRadius: 8,
                      offset:     const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size:  18,
                  color: selected ? Colors.white : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize:   14,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Field label — same as advertise & edit profile
// ─────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.icon});
  final String   label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _kOrange),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize:   14,
            fontWeight: FontWeight.w700,
            color:      Color(0xFF1A2E1A),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reusable field — same as advertise & edit profile
// ─────────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.prefixText,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController      controller;
  final String                     hint;
  final String?                    prefixText;
  final TextInputType?             keyboardType;
  final TextCapitalization         capitalization;
  final List<TextInputFormatter>?  inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:         controller,
      keyboardType:       keyboardType,
      textCapitalization: capitalization,
      inputFormatters:    inputFormatters,
      decoration: InputDecoration(
        hintText:    hint,
        hintStyle:   TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixText:  prefixText,
        prefixStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          color:      Color(0xFF1A2E1A),
        ),
        filled:         true,
        fillColor:      Colors.white,
        counterText:    '',
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: _kOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}