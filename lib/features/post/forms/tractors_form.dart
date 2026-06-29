import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final tractorsFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.tractorsBuy,
  displayName:      'Tractors',
  titleHint:        'e.g. Mahindra 575 DI – 2019 Model',
  descHint:         'Describe service history, attachments included, any repairs done…',
  listingCategory:  ListingCategory.tractors,
  forcedType:       ListingType.sell,
  accentColor:      Color(0xFF388E3C),
  bgColor:          Color(0xFFE8F5E9),
 imagePath:       'assets/sub_ctg/KrishiX_App-17.jpg', 
  fields: [
    PostFormField(
      label: 'Brand',
      hint:  'e.g. Mahindra, Swaraj, John Deere',
      icon:  Icons.branding_watermark_rounded,
    ),
    PostFormField(
      label:        'Year of Manufacture',
      hint:         'e.g. 2019',
      icon:         Icons.calendar_month_rounded,
      keyboardType: TextInputType.number,
      formatters:   [FilteringTextInputFormatter.digitsOnly],
    ),
    // PostFormField(
    //   label:        'Horse Power (HP)',
    //   hint:         'e.g. 45',
    //   icon:         Icons.speed_rounded,
    //   keyboardType: TextInputType.number,
    //   suffixText:   'HP',
    //   formatters:   [FilteringTextInputFormatter.digitsOnly],
    // ),
    // PostFormField(
    //   label: 'Condition',
    //   hint:  'e.g. Good, Excellent, Needs Repair',
    //   icon:  Icons.star_outline_rounded,
    // ),
  ],
);
