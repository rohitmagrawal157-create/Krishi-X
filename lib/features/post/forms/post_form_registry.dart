import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/crops_grains_form.dart';
import 'package:krishix/features/post/forms/farm_machinery_form.dart';
import 'package:krishix/features/post/forms/fruits_veg_form.dart';
import 'package:krishix/features/post/forms/jcb_rental_form.dart';
import 'package:krishix/features/post/forms/land_lease_form.dart';
import 'package:krishix/features/post/forms/land_sale_form.dart';
import 'package:krishix/features/post/forms/livestock_form.dart';
import 'package:krishix/features/post/forms/machinery_rent_form.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';
import 'package:krishix/features/post/forms/seeds_plants_form.dart';
import 'package:krishix/features/post/forms/tractor_rental_form.dart';
import 'package:krishix/features/post/forms/tractors_form.dart';

final _allFormConfigs = <PostFormConfig>[
  cropsGrainsFormConfig,
  fruitsVegFormConfig,
  seedsPlantsFormConfig,
  livestockFormConfig,
  tractorsFormConfig,
  farmMachineryFormConfig,
  landSaleFormConfig,
  tractorRentalFormConfig,
  machineryRentFormConfig,
  jcbRentalFormConfig,
  landLeaseFormConfig,
];

final Map<String, PostFormConfig> _formRegistry = {
  for (final config in _allFormConfigs) config.sectionId: config,
};

PostFormConfig? configFor(String sectionId) => _formRegistry[sectionId];

PostFormConfig defaultFormConfig({
  ListingCategory? category,
  ListingType? type,
}) {
  if (category == ListingCategory.livestock) return livestockFormConfig;
  if (category == ListingCategory.tractors) return tractorsFormConfig;
  if (category == ListingCategory.land) {
    return type == ListingType.rent ? landLeaseFormConfig : landSaleFormConfig;
  }
  if (category == ListingCategory.rental) return machineryRentFormConfig;
  return cropsGrainsFormConfig;
}

PostFormConfig resolveFormConfig({
  required String? sectionId,
  ListingCategory? category,
  ListingType? type,
}) {
  if (sectionId != null) {
    return configFor(sectionId) ??
        defaultFormConfig(category: category, type: type);
  }
  return defaultFormConfig(category: category, type: type);
}
