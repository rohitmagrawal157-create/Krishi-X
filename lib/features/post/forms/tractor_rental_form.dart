import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/core/models/listing.dart';
import 'package:krishix/features/post/forms/post_form_config.dart';

final tractorRentalFormConfig = PostFormConfig(
  sectionId:        CategorySectionId.tractorRental,
  displayName:      'Tractor Rental',
  titleHint:        'e.g. Mahindra 575 DI – Available for Season',
  descHint:         'Describe availability, operator included, service area, terms…',
  listingCategory:  ListingCategory.rental,
  forcedType:       ListingType.rent,
  accentColor:      Color(0xFF388E3C),
  bgColor:          Color(0xFFE8F5E9),
 imagePath:       'assets/sub_ctg/KrishiX_App-17.jpg', 
  fields: [
    PostFormField(
      label: 'Tractor Brand / Model',
      hint:  'e.g. Mahindra 575 DI, Swaraj 744 FE',
      icon:  Icons.agriculture_rounded,
    ),
    // PostFormField(
    //   label:        'Horse Power (HP)',
    //   hint:         'e.g. 45',
    //   icon:         Icons.speed_rounded,
    //   keyboardType: TextInputType.number,
    //   suffixText:   'HP',
    //   formatters:   [FilteringTextInputFormatter.digitsOnly],
    // ),
    PostFormField(
      label: 'Rental Duration',
      hint:  'e.g. Per Hour, Per Day, Season-wise',
      icon:  Icons.access_time_rounded,
    ),
    PostFormField(
      label: 'Operator Included?',
      hint:  'e.g. Yes – with driver, No – self drive only',
      icon:  Icons.person_outline_rounded,
    ),
  ],
);
