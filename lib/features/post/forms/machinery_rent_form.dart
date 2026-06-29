import 'package:flutter/material.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final machineryRentFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.farmMachineryRent,
  displayName:      'Farm Machinery Rental',
  titleHint:        'e.g. Rotavator 7-Feet – Available Daily',
  descHint:         'Describe availability, included operator, service area, terms…',
  listingCategory:  ListingCategory.rental,
  forcedType:       ListingType.rent,
  accentColor:      Color(0xFF6D4C41),
  bgColor:          Color(0xFFE8F5E9),
  imagePath:       'assets/sub_ctg/KrishiX_App-21.jpg', 
  fields: [
    PostFormField(
      label: 'Machine Type',
      hint:  'e.g. Rotavator, Harvester, Sprayer, Seeder',
      icon:  Icons.precision_manufacturing_rounded,
    ),
    PostFormField(
      label: 'Year of Manufacture',
      hint:  'e.g. 2020, 2021, 2022',
      icon:  Icons.calendar_month_rounded,
    ),
    PostFormField(
      label: 'Model',
      hint:  'e.g. Model 123, Model 456, Model 789',
      icon:  Icons.numbers_rounded,
    ),
  ],
);
