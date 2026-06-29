import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final seedsPlantsFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.seedsAndPlants,
  displayName:      'Seeds & Plants',
  titleHint:        'e.g. Hybrid Tomato Seeds – 500g Pack',
  descHint:         'Describe germination rate, source, any certifications, storage advice…',
  listingCategory:  ListingCategory.crops,
  forcedType:       ListingType.sell,
  accentColor:      Color(0xFF558B2F),
  bgColor:          Color(0xFFE8F5E9),
  imagePath:       'assets/sub_ctg/KrishiX_App-71.jpg', 
  fields: [
    PostFormField(
      label: 'Seed / Plant Type',
      hint:  'e.g. Tomato, Brinjal, Onion, Mango',
      icon:  Icons.eco_rounded,
    ),
    PostFormField(
      label:        'Quantity / Pack Size',
      hint:         'e.g. 500',
      icon:         Icons.scale_rounded,
      keyboardType: TextInputType.number,
      unitOptions:  PostUnits.seedsPlants,
      defaultUnit:  'grams',
      formatters:   [FilteringTextInputFormatter.digitsOnly],
    ),
    PostFormField(
      label: 'Seed / Plant Brand',
      hint:  'e.g. Mahyco, Syngenta, Local variety',
      icon:  Icons.branding_watermark_rounded,
    ),
    PostFormField(
      label: 'Variety',
      hint:  'e.g. Hybrid, Local, Any variety',
      icon:  Icons.workspace_premium_rounded,
    ),
  ],
);
