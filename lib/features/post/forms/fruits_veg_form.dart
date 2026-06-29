import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final fruitsVegFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.fruitsVeg,
  displayName:      'Fruits & Vegetables',
  titleHint:        'e.g. Fresh Alphonso Mangoes – 10 Dozen',
  descHint:         'Describe freshness, packaging, delivery options, minimum order…',
  listingCategory:  ListingCategory.crops,
  forcedType:       ListingType.sell,
  accentColor:      Color(0xFF7CB342),
  bgColor:          Color(0xFFE8F5E9),
imagePath:       'assets/sub_ctg/KrishiX_App-47.jpg', 
  fields: [
    PostFormField(
      label: 'Variety',
      hint:  'e.g. Alphonso, Devgad, Cherry Tomato',
      icon:  Icons.eco_rounded,
    ),
    PostFormField(
      label:        'Quantity Available',
      hint:         'e.g. 50',
      icon:         Icons.scale_rounded,
      keyboardType: TextInputType.number,
      unitOptions:  PostUnits.fruitsVeg,
      defaultUnit:  'Kg',
      formatters:   [FilteringTextInputFormatter.digitsOnly],
    ),
    // PostFormField(
    //   label: 'Grade / Quality',
    //   hint:  'e.g. Premium, Export, Mixed',
    //   icon:  Icons.workspace_premium_rounded,
    // ),
    // PostFormField(
    //   label: 'Harvest / Available From',
    //   hint:  'e.g. Ready now, July 2026',
    //   icon:  Icons.calendar_today_rounded,
    // ),
  ],
);
