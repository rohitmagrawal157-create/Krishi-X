import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final landSaleFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.agricultureLandSale,
  displayName:      'Farm Land',
  titleHint:        'e.g. 5 Acre Irrigated Farm Land for Sale',
  descHint:         'Describe road access, irrigation, nearby facilities, legal status…',
  listingCategory:  ListingCategory.land,
  forcedType:       ListingType.sell,
  accentColor:      Color(0xFF0277BD),
  bgColor:          Color(0xFFE8F5E9),
imagePath:       'assets/sub_ctg/KrishiX_App-65.jpg', 
  fields: [
    PostFormField(
      label:        'Total Area',
      hint:         'e.g. 5',
      icon:         Icons.straighten_rounded,
      keyboardType: TextInputType.number,
      unitOptions:  PostUnits.landArea,
      defaultUnit:  'Acre',
      formatters:   [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
    ),
    PostFormField(
      label: 'Survey Number',
      hint:  'e.g. 142/3 (optional)',
      icon:  Icons.pin_outlined,
    ),
    PostFormField(
      label: 'Soil Type',
      hint:  'e.g. Black, Red, Alluvial',
      icon:  Icons.layers_rounded,
    ),
    PostFormField(
      label: 'Water Source',
      hint:  'e.g. Borewell, Canal, Rain-fed',
      icon:  Icons.water_rounded,
    ),
    PostFormField(
      label: 'Road Access',
      hint:  'e.g. Yes – 10ft road, No',
      icon:  Icons.add_road_rounded,
    ),
    PostFormField(
      label: 'Legal Status',
      hint:  'e.g. Clear title, NA converted',
      icon:  Icons.gavel_rounded,
    ),
  ],
);
