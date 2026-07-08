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
  imagePath:        'assets/new_ctg/KrishiX_App-17.jpg',
  fields: [
    PostFormField(
      label: 'Tractor Brand',
      hint:  'Select tractor brand',
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
      label:        'Year of Manufacture',
      hint:         'e.g. 2019',
      icon:         Icons.calendar_month_rounded,
      keyboardType: TextInputType.number,
      formatters:   [FilteringTextInputFormatter.digitsOnly],
    ),
  ],
);
