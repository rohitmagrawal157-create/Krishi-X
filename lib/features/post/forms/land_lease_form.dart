import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final landLeaseFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.agricultureLandLease,
  displayName:      'Land Lease',
  titleHint:        'e.g. 3 Acre Farm Land Available for Lease',
  descHint:         'Describe current land condition, who bears water/electricity cost, access road…',
  listingCategory:  ListingCategory.land,
  forcedType:       ListingType.rent,
  accentColor:      Color(0xFF00838F),
  bgColor:          Color(0xFFE8F5E9),
 imagePath:       'assets/sub_ctg/KrishiX_App-65.jpg', 
  fields: [
    PostFormField(
      label:        'Total Area Available',
      hint:         'e.g. 3',
      icon:         Icons.straighten_rounded,
      keyboardType: TextInputType.number,
      unitOptions:  PostUnits.landArea,
      defaultUnit:  'Acre',
      formatters:   [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
    ),
    PostFormField(
      label: 'Lease Duration',
      hint:  'e.g. 1 year, Season-wise, 3 years',
      icon:  Icons.access_time_rounded,
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
      label: 'Existing Crop (if any)',
      hint:  'e.g. Sugarcane, Cotton, Fallow',
      icon:  Icons.grass_rounded,
    ),
    PostFormField(
      label: 'Lease Terms',
      hint:  'e.g. Negotiable, Fixed rent ₹8000/acre/yr',
      icon:  Icons.handshake_outlined,
    ),
  ],
);
