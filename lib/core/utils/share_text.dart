import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/icons/dealer_data.dart';
import 'package:krishix/l10n/app_localizations.dart';

/// Play Store link appended to share messages.
const krishiXAppLink =
    'https://play.google.com/store/apps/details?id=in.krishix.krishix';

String formatSharePrice(int price) {
  final s     = price.toString();
  final last  = s.substring(s.length - 3);
  final rest  = s.substring(0, s.length - 3);
  if (rest.isEmpty) return '₹$last';
  final buf = StringBuffer();
  for (var i = 0; i < rest.length; i++) {
    if (i > 0 && (rest.length - i) % 2 == 0) buf.write(',');
    buf.write(rest[i]);
  }
  return '₹${buf.toString()},$last';
}

String? _listingQuantityForShare(Listing listing) {
  if (listing.quantity != null) {
    final q = listing.quantity! % 1 == 0
        ? listing.quantity!.toInt().toString()
        : listing.quantity.toString();
    if (listing.unit != null && listing.unit!.isNotEmpty) {
      return '$q ${listing.unit}';
    }
    return q;
  }
  if (listing.areaAcres != null) {
    final a = listing.areaAcres! % 1 == 0
        ? listing.areaAcres!.toInt().toString()
        : listing.areaAcres.toString();
    return '$a Acres';
  }
  return null;
}

String buildListingShareText(AppLocalizations l10n, Listing listing) {
  final buf = StringBuffer();
  buf.writeln('🌾 ${l10n.shareListingHeader}');
  buf.writeln();
  buf.writeln('📌 ${listing.title}');
  final priceSuffix = listing.rentalDuration != null
      ? ' / ${listing.rentalDuration!.toLowerCase()}'
      : '';
  buf.writeln(
      '💰 ${l10n.sharePriceLabel}: ${formatSharePrice(listing.price)}$priceSuffix');
  buf.writeln('📍 ${listing.location}');
  final qty = _listingQuantityForShare(listing);
  if (qty != null) {
    buf.writeln('${l10n.shareQuantityLabel}: $qty');
  }
  buf.writeln();
  buf.writeln('📲 ${l10n.shareConnectSeller} $krishiXAppLink');
  return buf.toString();
}

String buildDealerShareText(AppLocalizations l10n, AgriDealer dealer) {
  final products = dealer.productCategories
      .map((c) => localizedDealerCategory(l10n, c))
      .join(', ');
  return '🌾 ${l10n.shareDealerListingHeader}\n\n'
      '📌 ${dealer.name}\n'
      '💰 ${l10n.shareProductsLabel}: $products\n'
      '📍 ${dealer.location}\n\n'
      '📲 ${l10n.shareConnectSeller} $krishiXAppLink';
}
