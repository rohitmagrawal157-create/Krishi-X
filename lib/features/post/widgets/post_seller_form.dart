import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/services/location_service.dart';
import 'package:krishix/core/widgets/location_picker.dart';
import 'package:krishix/features/post/widgets/post_form_fields.dart';

const Color _kGreen = AppColors.primaryGreen;

class PostSellerForm extends StatelessWidget {
  const PostSellerForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.locationController,
    required this.phoneController,
    required this.categoryLabel,
    required this.typeLabel,
    required this.title,
    required this.price,
    required this.isSubmitting,
    required this.onSubmit,
    this.accentColor = const Color(0xFF2E7D32), // ← new, defaults to green
  });

  final GlobalKey<FormState>    formKey;
  final TextEditingController   nameController;
  final TextEditingController   locationController;
  final TextEditingController   phoneController;
  final String                  categoryLabel;
  final String                  typeLabel;
  final String                  title;
  final String                  price;
  final bool                    isSubmitting;
  final VoidCallback            onSubmit;
  final Color                   accentColor;    // ← new

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:        _kGreen.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border:       Border.all(color: _kGreen.withOpacity(0.20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: _kGreen, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'These details will be shown to buyers. '
                      'Phone number is fetched from your account.',
                      style: TextStyle(
                        fontSize: 12,
                        color:    _kGreen.withOpacity(0.85),
                        height:   1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const PostFieldLabel(
              label: 'Your Name *',
              icon:  Icons.person_outline_rounded,
            ),
            const SizedBox(height: 8),
            PostField(
              controller:     nameController,
              hint:           'Full name',
              capitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Name is required'
                  : null,
            ),
            const SizedBox(height: 18),
            const PostFieldLabel(
              label: 'Location *',
              icon:  Icons.location_on_outlined,
            ),
            const SizedBox(height: 4),
            Text(
              'Village / Taluka / District where the item is located',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            LocationPickerField(
              controller:    locationController,
              accentColor:   accentColor,
              useFullScreen: true,
              onUseMyLocation: () async {
                final loc = await LocationService.fetchCurrentLocation(
                  requestPermissionIfNeeded: true,
                );
                return loc.permissionGranted ? loc : null;
              },
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Location is required'
                  : null,
            ),
            const SizedBox(height: 18),
            const PostFieldLabel(
              label: 'Contact Number',
              icon:  Icons.phone_outlined,
            ),
            const SizedBox(height: 4),
            Text(
              'Fetched from your account — cannot be changed here',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller:   phoneController,
              enabled:        false,
              keyboardType:   TextInputType.phone,
              style: TextStyle(
                color:      Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
              decoration: postInputDecoration(
                hint:       '+91 XXXXX XXXXX',
                filled:     true,
                fillColor:  Colors.grey.shade100,
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(height: 32),
            PostListingSummary(
              category: categoryLabel,
              type:     typeLabel,
              title:    title,
              price:    price,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width:  double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor:         _kGreen,
                  foregroundColor:         Colors.white,
                  disabledBackgroundColor: _kGreen.withOpacity(0.50),
                  elevation:               0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width:  24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color:      Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_rounded, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Submit Listing',
                            style: TextStyle(
                              fontSize:   16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Your listing will be reviewed before going live.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostListingSummary extends StatelessWidget {
  const PostListingSummary({
    super.key,
    required this.category,
    required this.type,
    required this.title,
    required this.price,
  });

  final String category;
  final String type;
  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        const Color(0xFFF0F7F0),
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: _kGreen.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded, size: 16, color: _kGreen),
              const SizedBox(width: 6),
              const Text(
                'Listing Summary',
                style: TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.w800,
                  color:      AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Category', value: category),
          _SummaryRow(label: 'Type', value: type),
          if (title.isNotEmpty) _SummaryRow(label: 'Title', value: title),
          if (price.isNotEmpty) _SummaryRow(label: 'Price', value: '₹$price'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize:   12,
                color:      Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text('  ·  '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize:   12,
                fontWeight: FontWeight.w700,
                color:      AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
