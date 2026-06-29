import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final livestockFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.livestock,
  displayName:      'Livestock',
  titleHint:        'e.g. Murrah Buffalo – High Milk Yield',
  descHint:         'Describe health condition, vaccination history, feeding habits…',
  listingCategory:  ListingCategory.livestock,
  forcedType:       ListingType.sell,
  accentColor:      Color(0xFF8D6E63),
  bgColor:          Color(0xFFE8F5E9),
 imagePath:       'assets/sub_ctg/KrishiX_App-54.jpg', 
  fields: [
    // PostFormField(
    //   label: 'Breed',
    //   hint:  'e.g. Murrah, HF, Gir, Sahiwal',
    //   icon:  Icons.pets_rounded,
    // ),
    PostFormField(
      label: 'Age',
      hint:  'e.g. 3 years, 18 months',
      icon:  Icons.cake_rounded,
    ),
    // PostFormField(
    //   label:        'Milk Yield (if applicable)',
    //   hint:         'e.g. 14',
    //   icon:         Icons.water_drop_rounded,
    //   keyboardType: TextInputType.number,
    //   suffixText:   'L/day',
    //   formatters:   [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
    // ),
  ],
);
