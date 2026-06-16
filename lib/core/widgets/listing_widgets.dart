// lib/core/widgets/listing_widgets.dart

import 'package:flutter/material.dart';
import 'package:krishix/core/models/listing.dart';

// ═══════════════════════════════════════════════════════════════
// IMAGE ASSET MAPPING
// ═══════════════════════════════════════════════════════════════
extension ListingImageAsset on Listing {
  String get imageAsset {
    switch (category) {
      case ListingCategory.tractors:
        return 'assets/images/tractor.jpeg';
      case ListingCategory.crops:
        return 'assets/images/food.jpeg';
      case ListingCategory.livestock:
        return 'assets/images/pets.jpeg';
      case ListingCategory.land:
        return 'assets/images/land.jpeg';
      case ListingCategory.rental:
        return 'assets/images/machin.jpeg';
      default:
        return 'assets/images/seed.jpg';
    }
  }
}

class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.listing});

  final Listing listing;

  /// Formats price as plain rupee amount with comma separators,
  /// e.g. 450000 -> "₹4,50,000" (Indian numbering).
  String _formatPrice(int price) {
    final str = price.toString();
    if (str.length <= 3) return '₹$str';

    final lastThree = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);

    final buffer = StringBuffer();
    for (var i = 0; i < rest.length; i++) {
      final posFromEnd = rest.length - i;
      buffer.write(rest[i]);
      if (posFromEnd > 1 && posFromEnd % 2 == 1) {
        buffer.write(',');
      }
    }

    return '₹$buffer,$lastThree';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Image ─────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Container(
                color: Colors.grey.shade100,
                child: Image.asset(
                  listing.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Price ─────────────────────────────────────
          Text(
            _formatPrice(listing.price),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.green,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // ── Title ─────────────────────────────────────
          Text(
            listing.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),

          // ── Location ──────────────────────────────────
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  listing.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          // ── Verified badge ──────────────────────────────
          if (listing.isVerified) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 14, color: Colors.blue),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Verified',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}