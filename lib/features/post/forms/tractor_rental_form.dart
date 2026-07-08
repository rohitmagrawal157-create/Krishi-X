import 'package:flutter/material.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final tractorRentalFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.tractorRental,
  displayName:      'Tractor Rental',
  titleHint:        'e.g. Mahindra 575 DI – Available for Rent',
  descHint:         'Describe availability, service area, terms…',
  listingCategory:  ListingCategory.rental,
  forcedType:       ListingType.rent,
  accentColor:      Color(0xFFF57C00),
  bgColor:          Color(0xFFFFF3E0),
  imagePath:        'assets/new_ctg/KrishiX_App-17.jpg',
  fields: [
    PostFormField(
      label: 'Tractor Brand',
      hint:  'Selected from brand list',
      icon:  Icons.branding_watermark_rounded,
    ),
    PostFormField(
      label: 'Tractor Model',
      hint:  'e.g. 575 DI, Farmtrac 60',
      icon:  Icons.agriculture_rounded,
    ),
    PostFormField(
      label: 'Horse Power (HP)',
      hint:  'Select horse power range',
      icon:  Icons.speed_rounded,
    ),
    PostFormField(
      label: 'Rental Price',
      hint:  'Amount with hourly or daily basis',
      icon:  Icons.currency_rupee_rounded,
    ),
  ],
);
