import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final farmMachineryFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.farmMachinery,
  displayName:      'Farm Machinery',
  titleHint:        'e.g. Rotavator 7-Feet – Good Condition',
  descHint:         'Describe attachments, usage hours, warranty, delivery options…',
  listingCategory:  ListingCategory.tractors,
  forcedType:       ListingType.sell,
  accentColor:      Color(0xFF6D4C41),
  bgColor:          Color(0xFFE8F5E9),
 imagePath:       'assets/sub_ctg/KrishiX_App-21.jpg', 
  fields: [
    PostFormField(
      label: 'Equipment Type',
      hint:  'e.g. Rotavator, Sprayer, Thresher, Seed Drill',
      icon:  Icons.precision_manufacturing_rounded,
    ),
    // PostFormField(
    //   label: 'Brand / Manufacturer',
    //   hint:  'e.g. Shaktiman, Lemken, Local make',
    //   icon:  Icons.branding_watermark_rounded,
    // ),
    // PostFormField(
    //   label:        'Year of Purchase',
    //   hint:         'e.g. 2020',
    //   icon:         Icons.calendar_month_rounded,
    //   keyboardType: TextInputType.number,
    //   formatters:   [FilteringTextInputFormatter.digitsOnly],
    // ),
    // PostFormField(
    //   label: 'Condition',
    //   hint:  'e.g. Good, Excellent, Needs Repair',
    //   icon:  Icons.star_outline_rounded,
    // ),
  ],
);
