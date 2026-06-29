import 'package:flutter/material.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final tractorPartsFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.tractorsParts,
  displayName:      'Tractor Parts',
  titleHint:        'e.g. Mahindra 575 DI Front Tyre – 90% Tread',
  descHint:         'Describe compatibility, condition, warranty, pickup/delivery…',
  listingCategory:  ListingCategory.tractors,
  forcedType:       ListingType.sell,
  accentColor:      Color(0xFF5D4037),
  bgColor:          Color(0xFFE8F5E9),
 imagePath:       'assets/sub_ctg/KrishiX_App-17.jpg', 
  fields: [
    PostFormField(
      label: 'Part Name',
      hint:  'e.g. Front Tyre, Battery, Clutch Plate, Engine Oil Filter',
      icon:  Icons.build_rounded,
    ),
    PostFormField(
      label: 'Compatible Tractor / Model',
      hint:  'e.g. Mahindra 575 DI, Swaraj 744, Universal fit',
      icon:  Icons.agriculture_rounded,
    ),
    PostFormField(
      label: 'Brand (if applicable)',
      hint:  'e.g. MRF, Exide, OEM, Aftermarket',
      icon:  Icons.branding_watermark_rounded,
    ),
    PostFormField(
      label: 'Condition',
      hint:  'e.g. New, Used – Good, Refurbished',
      icon:  Icons.star_outline_rounded,
    ),
  ],
);
