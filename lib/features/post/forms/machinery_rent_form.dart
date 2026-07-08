import 'package:flutter/material.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final machineryRentFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.farmMachineryRent,
  displayName:      'Farm Machinery Rental',
  titleHint:        'e.g. Rotavator 7-Feet – Available for Rent',
  descHint:         'Describe availability, included operator, service area, terms…',
  listingCategory:  ListingCategory.rental,
  forcedType:       ListingType.rent,
  accentColor:      Color(0xFF6D4C41),
  bgColor:          Color(0xFFE8F5E9),
  imagePath:        'assets/new_ctg/KrishiX_App-21.jpg',
  fields: [
    PostFormField(
      label: 'Machinery Name',
      hint:  'Selected from subcategory',
      icon:  Icons.precision_manufacturing_rounded,
    ),
    PostFormField(
      label: 'Rental Price',
      hint:  'Amount with hourly or daily basis',
      icon:  Icons.currency_rupee_rounded,
    ),
  ],
);
