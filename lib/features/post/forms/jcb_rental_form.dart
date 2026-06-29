import 'package:flutter/material.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final jcbRentalFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.jcbRental,
  displayName:      'JCB / Excavator',
  titleHint:        'e.g. JCB 3DX Backhoe – Available Daily',
  descHint:         'Describe availability, included operator, service area, terms…',
  listingCategory:  ListingCategory.rental,
  forcedType:       ListingType.rent,
  accentColor:      Color(0xFFF57C00),
  bgColor:          Color(0xFFE8F5E9),
imagePath:       'assets/sub_ctg/KrishiX_App-23.jpg', 
  fields: [
    PostFormField(
      label: 'Machine Type',
      hint:  'e.g. JCB 3DX, Excavator, Loader, Bulldozer',
      icon:  Icons.construction_rounded,
    ),
    PostFormField(
      label: 'Rental Duration',
      hint:  'e.g. Per Hour, Per Day, Weekly',
      icon:  Icons.access_time_rounded,
    ),
    PostFormField(
      label: 'Operator Included?',
      hint:  'e.g. Yes – with operator, No – machine only',
      icon:  Icons.person_outline_rounded,
    ),
    // PostFormField(
    //   label: 'Service Area',
    //   hint:  'e.g. Within 30 km of Aurangabad',
    //   icon:  Icons.map_outlined,
    // ),
  ],
);
