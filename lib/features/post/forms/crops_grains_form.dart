import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final cropsGrainsFormConfig = PostFormConfig(
  sectionId:       CategorySectionId.cropsAndGrains,
  displayName:     'Crops & Grains',
  titleHint:       'e.g. Wheat – 20 Quintal, A-Grade',
  descHint:        'Describe crop quality, packaging, storage, any certifications…',
  listingCategory: ListingCategory.crops,
  forcedType:      ListingType.sell,
  accentColor:     const Color(0xFF689F38),
  bgColor:         const Color(0xFFE8F5E9),
  icon:            Icons.grass_rounded,
  imagePath:       'assets/sub_ctg/KrishiX_App-31.jpg', // ← new
  fields: [
    PostFormField(
      label:        'Quantity',
      hint:         'e.g. 20',
      icon:         Icons.scale_rounded,
      keyboardType: TextInputType.number,
      unitOptions:  PostUnits.cropsGrains,
      defaultUnit:  'Quintal',
      formatters:   [FilteringTextInputFormatter.digitsOnly],
    ),
  ],
);