import 'package:flutter/material.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final jcbRentalFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.jcbRental,
  displayName:      'JCB / Excavator',
  titleHint:        'Selected from subcategory',
  descHint:         'Describe availability, service area, operator, terms…',
  listingCategory:  ListingCategory.rental,
  forcedType:       ListingType.rent,
  accentColor:      Color(0xFFF57C00),
  bgColor:          Color(0xFFE8F5E9),
  imagePath:        'assets/images/jcb1.jpeg',
  fields: [
    PostFormField(
      label: 'Machine Name',
      hint:  'Selected from subcategory',
      icon:  Icons.construction_rounded,
    ),
    PostFormField(
      label: 'Rental Price',
      hint:  'Amount with hourly or daily basis',
      icon:  Icons.currency_rupee_rounded,
    ),
  ],
);
