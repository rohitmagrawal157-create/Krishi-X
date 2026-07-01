import 'package:krishix/core/data/subcategories.dart';
import 'package:krishix/l10n/app_localizations.dart';

/// Resolves all post-listing form labels, hints, and units for the active locale.
class PostFormL10n {
  const PostFormL10n(this.l10n);

  final AppLocalizations l10n;

  String titleFieldLabel(String postCat, {String? sectionId}) {
    if (sectionId == CategorySectionId.farmMachinery) {
      return l10n.postTitleFarmMachinery;
    }
    if (sectionId == CategorySectionId.tractorsParts) {
      return l10n.postTitleTractorPart;
    }
    if (sectionId == CategorySectionId.farmMachineryRent) {
      return l10n.postTitleMachineryName;
    }
    if (sectionId == CategorySectionId.jcbRental) {
      return l10n.postTitleJcb;
    }
    if (sectionId == CategorySectionId.tractorRental) {
      return l10n.postTitleTractorRental;
    }
    return switch (postCat) {
      'cropsGrains' => l10n.postTitleCropGrain,
      'seedsPlants' => l10n.postTitleSeedPlant,
      'fruitsVeg'   => l10n.postTitleFruitVeg,
      'livestock'   => l10n.postTitleLivestock,
      'tractors'    => l10n.postTitleTractor,
      'landBuy'     => l10n.postTitleFarmLand,
      'landRent'    => l10n.postTitleFarmLand,
      'rental'      => l10n.postTitleEquipment,
      _             => l10n.postTitleGeneric,
    };
  }

  String categoryLabel(String postCat) => switch (postCat) {
    'cropsGrains' => l10n.cropsAndGrains,
    'seedsPlants' => l10n.seeds_and_plants,
    'fruitsVeg'   => l10n.fruitsAndVegetables,
    'livestock'   => l10n.livestock,
    'tractors'    => l10n.postCatTractorsMachinery,
    'landBuy'     => l10n.postCatLandBuySell,
    'landRent'    => l10n.postCatLandLease,
    'rental'      => l10n.postCatRentalEquipment,
    _             => l10n.categories,
  };

  String titleHint(String postCat) => switch (postCat) {
    'cropsGrains' => l10n.postTitleHintCropsGrains,
    'seedsPlants' => l10n.postTitleHintSeedsPlants,
    'fruitsVeg'   => l10n.postTitleHintFruitsVeg,
    'livestock'   => l10n.postTitleHintLivestock,
    'tractors'    => l10n.postTitleHintTractors,
    'landBuy'     => l10n.postTitleHintLandBuy,
    'landRent'    => l10n.postTitleHintLandRent,
    'rental'      => l10n.postTitleHintRental,
    _             => l10n.postTitleHintGeneric,
  };

  String descHint(String postCat) => switch (postCat) {
    'cropsGrains' => l10n.postDescHintCropsGrains,
    'seedsPlants' => l10n.postDescHintSeedsPlants,
    'fruitsVeg'   => l10n.postDescHintFruitsVeg,
    'livestock'   => l10n.postDescHintLivestock,
    'tractors'    => l10n.postDescHintTractors,
    'landBuy'     => l10n.postDescHintLandBuy,
    'landRent'    => l10n.postDescHintLandRent,
    'rental'      => l10n.postDescHintRental,
    _             => l10n.postDescHintGeneric,
  };

  String fieldLabel(String id) => switch (id) {
    'quantity'           => l10n.postFldQuantity,
    'gradeQuality'       => l10n.postFldGradeQuality,
    'harvestDate'        => l10n.postFldHarvestDate,
    'cropPlantType'      => l10n.postFldCropPlantType,
    'quantityPackSize'   => l10n.postFldQuantityPackSize,
    'seedBrand'          => l10n.postFldSeedBrand,
    'sowingSeason'       => l10n.postFldSowingSeason,
    'variety'            => l10n.postFldVariety,
    'quantityAvailable'  => l10n.postFldQuantityAvailable,
    'harvestAvailable'   => l10n.postFldHarvestAvailable,
    'breed'              => l10n.postFldBreed,
    'age'                => l10n.postFldAge,
    'milkYield'          => l10n.postFldMilkYield,
    'brand'              => l10n.postFldBrand,
    'yearManufacture'    => l10n.postFldYearManufacture,
    'horsePower'         => l10n.postFldHorsePower,
    'condition'          => l10n.postFldCondition,
    'totalArea'          => l10n.postFldTotalArea,
    'surveyNumber'       => l10n.postFldSurveyNumber,
    'soilType'           => l10n.postFldSoilType,
    'waterSource'        => l10n.postFldWaterSource,
    'roadAccess'         => l10n.postFldRoadAccess,
    'legalStatus'        => l10n.postFldLegalStatus,
    'totalAreaAvailable' => l10n.postFldTotalAreaAvailable,
    'leaseDuration'      => l10n.postFldLeaseDuration,
    'existingCrop'       => l10n.postFldExistingCrop,
    'leaseTerms'         => l10n.postFldLeaseTerms,
    'equipmentType'      => l10n.postFldEquipmentType,
    'rentalDuration'     => l10n.postFldRentalDuration,
    'deliveryAvailable'  => l10n.postFldDeliveryAvailable,
    'machineType'        => l10n.postFldMachineType,
    'operatorIncluded'   => l10n.postFldOperatorIncluded,
    _                    => id,
  };

  String fieldHint(String id) => switch (id) {
    'quantity'           => l10n.postHintQuantity,
    'gradeQuality'       => l10n.postHintGradeQuality,
    'harvestDate'        => l10n.postHintHarvestDate,
    'cropPlantType'      => l10n.postHintCropPlantType,
    'quantityPackSize'   => l10n.postHintQuantityPackSize,
    'seedBrand'          => l10n.postHintSeedBrand,
    'sowingSeason'       => l10n.postHintSowingSeason,
    'variety'            => l10n.postHintVariety,
    'quantityAvailable'  => l10n.postHintQuantityAvailable,
    'harvestAvailable'   => l10n.postHintHarvestAvailable,
    'breed'              => l10n.postHintBreed,
    'age'                => l10n.postHintAge,
    'milkYield'          => l10n.postHintMilkYield,
    'brand'              => l10n.postHintBrand,
    'yearManufacture'    => l10n.postHintYearManufacture,
    'horsePower'         => l10n.postHintHorsePower,
    'condition'          => l10n.postHintCondition,
    'totalArea'          => l10n.postHintTotalArea,
    'surveyNumber'       => l10n.postHintSurveyNumber,
    'soilType'           => l10n.postHintSoilType,
    'waterSource'        => l10n.postHintWaterSource,
    'roadAccess'         => l10n.postHintRoadAccess,
    'legalStatus'        => l10n.postHintLegalStatus,
    'totalAreaAvailable' => l10n.postHintTotalAreaAvailable,
    'leaseDuration'      => l10n.postHintLeaseDuration,
    'existingCrop'       => l10n.postHintExistingCrop,
    'leaseTerms'         => l10n.postHintLeaseTerms,
    'equipmentType'      => l10n.postHintEquipmentType,
    'rentalDuration'     => l10n.postHintRentalDuration,
    'deliveryAvailable'  => l10n.postHintDeliveryAvailable,
    'machineType'        => l10n.postHintMachineType,
    'operatorIncluded'   => l10n.postHintOperatorIncluded,
    _                    => id,
  };

  String? fieldSuffix(String id) => switch (id) {
    'milkYield'          => l10n.postSuffixLitersPerDay,
    'totalArea'          => l10n.postSuffixAcres,
    'totalAreaAvailable' => l10n.postSuffixAcres,
    'horsePower'         => l10n.postSuffixHp,
    _                    => null,
  };

  String unitLabel(String unit) => switch (unit) {
    'Quintal' => l10n.unitQuintal,
    'Kg'      => l10n.unitKg,
    'Ton'     => l10n.unitTon,
    'Man'     => l10n.unitMan,
    'Bag'     => l10n.unitBag,
    'Dozen'   => l10n.unitDozen,
    'Crate'   => l10n.unitCrate,
    'Box'     => l10n.unitBox,
    'grams'   => l10n.unitGrams,
    'Packet'  => l10n.unitPacket,
    'Piece'   => l10n.unitPiece,
    'Acre'    => l10n.unitAcre,
    'Hectare' => l10n.unitHectare,
    'Guntha'  => l10n.unitGuntha,
    _         => unit,
  };

  List<String> localizedUnits(List<String> units) =>
      units.map(unitLabel).toList(growable: false);

  String unitFromPicker(List<String> units, String picked) {
    final localized = localizedUnits(units);
    final index = localized.indexOf(picked);
    return index >= 0 ? units[index] : units.first;
  }
}
