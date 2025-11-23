class UnitModel {
  final String id;
  final String buildingId; // 🔹 new

  final UnitInformation unitInformation;
  final UnitLocation unitLocation;
  final Utilities utilities;
  final IndoorAmenities indoorAmenities;
  final BuildingAmenities buildingAmenities;
  final RulesAndPolicies rulesAndPolicies;
  final NotesAndDocuments notesAndDocuments;

  UnitModel({
    required this.id,
    required this.buildingId, // 🔹 new

    required this.unitInformation,
    required this.unitLocation,
    required this.utilities,
    required this.indoorAmenities,
    required this.buildingAmenities,
    required this.rulesAndPolicies,
    required this.notesAndDocuments,
  });

  factory UnitModel.fromMap(String id,    String buildingId,
      Map<String, dynamic> data) {
    return UnitModel(
      id: id,
      buildingId: buildingId,

      unitInformation:
      UnitInformation.fromMap(data['unit_information'] ?? {}),
      unitLocation: UnitLocation.fromMap(data['unit_location'] ?? {}),
      utilities: Utilities.fromMap(data['utilities'] ?? {}),
      indoorAmenities:
      IndoorAmenities.fromMap(data['indoor_amenities'] ?? {}),
      buildingAmenities:
      BuildingAmenities.fromMap(data['building_amenities'] ?? {}),
      rulesAndPolicies:
      RulesAndPolicies.fromMap(data['rules_and_policies'] ?? {}),
      notesAndDocuments:
      NotesAndDocuments.fromMap(data['notes_and_documents'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "unit_information": unitInformation.toMap(),
      "unit_location": unitLocation.toMap(),
      "utilities": utilities.toMap(),
      "indoor_amenities": indoorAmenities.toMap(),
      "building_amenities": buildingAmenities.toMap(),
      "rules_and_policies": rulesAndPolicies.toMap(),
      "notes_and_documents": notesAndDocuments.toMap(),
    };
  }
}

// ---------------- SUB MODELS ----------------

class UnitInformation {
  final String buildingName;
  final String unitNumber;
  final int unitSizeSqFt;
  final int bedrooms;
  final int bathrooms;
  final int balconies;
  final String floor;
  final String unitOwnership;
  final String unitCategory;
  final String unitStatus;
  final String maintenanceBy;

  UnitInformation({
    required this.buildingName,
    required this.unitNumber,
    required this.unitSizeSqFt,
    required this.bedrooms,
    required this.bathrooms,
    required this.balconies,
    required this.floor,
    required this.unitOwnership,
    required this.unitCategory,
    required this.unitStatus,
    required this.maintenanceBy,
  });

  factory UnitInformation.fromMap(Map<String, dynamic> map) {
    return UnitInformation(
      buildingName: map['building_name'] ?? '',
      unitNumber: map['unit_number'] ?? '',
      unitSizeSqFt: (map['unit_size_sq_ft'] ?? 0) as int,
      bedrooms: (map['bedrooms'] ?? 0) as int,
      bathrooms: (map['bathrooms'] ?? 0) as int,
      balconies: (map['balconies'] ?? 0) as int,
      floor: map['floor'] ?? '',
      unitOwnership: map['unit_ownership'] ?? '',
      unitCategory: map['unit_category'] ?? '',
      unitStatus: map['unit_status'] ?? '',
      maintenanceBy: map['maintenance_by'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "building_name": buildingName,
      "unit_number": unitNumber,
      "unit_size_sq_ft": unitSizeSqFt,
      "bedrooms": bedrooms,
      "bathrooms": bathrooms,
      "balconies": balconies,
      "floor": floor,
      "unit_ownership": unitOwnership,
      "unit_category": unitCategory,
      "unit_status": unitStatus,
      "maintenance_by": maintenanceBy,
    };
  }
}

class UnitLocation {
  final String roadStreetName;
  final String areaSectorVillage;
  final String thanaUpazila;
  final String districtCity;
  final String postalCode;
  final String country;

  UnitLocation({
    required this.roadStreetName,
    required this.areaSectorVillage,
    required this.thanaUpazila,
    required this.districtCity,
    required this.postalCode,
    required this.country,
  });

  factory UnitLocation.fromMap(Map<String, dynamic> map) {
    return UnitLocation(
      roadStreetName: map['road_street_name'] ?? '',
      areaSectorVillage: map['area_sector_village'] ?? '',
      thanaUpazila: map['thana_upazila'] ?? '',
      districtCity: map['district_city'] ?? '',
      postalCode: map['postal_code'] ?? '',
      country: map['country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "road_street_name": roadStreetName,
      "area_sector_village": areaSectorVillage,
      "thana_upazila": thanaUpazila,
      "district_city": districtCity,
      "postal_code": postalCode,
      "country": country,
    };
  }
}

class Utilities {
  final bool electricity;
  final bool water;
  final bool internet;
  final bool gas;
  final bool garbageDisposal;
  final bool solarPanel;

  Utilities({
    required this.electricity,
    required this.water,
    required this.internet,
    required this.gas,
    required this.garbageDisposal,
    required this.solarPanel,
  });

  factory Utilities.fromMap(Map<String, dynamic> map) {
    return Utilities(
      electricity: map['electricity'] ?? false,
      water: map['water'] ?? false,
      internet: map['internet'] ?? false,
      gas: map['gas'] ?? false,
      garbageDisposal: map['garbage_disposal'] ?? false,
      solarPanel: map['solar_panel'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "electricity": electricity,
      "water": water,
      "internet": internet,
      "gas": gas,
      "garbage_disposal": garbageDisposal,
      "solar_panel": solarPanel,
    };
  }
}

class IndoorAmenities {
  final bool airConditioner;
  final bool heater;
  final bool fan;
  final bool wardrobe;
  final bool kitchen;
  final bool geyser;

  IndoorAmenities({
    required this.airConditioner,
    required this.heater,
    required this.fan,
    required this.wardrobe,
    required this.kitchen,
    required this.geyser,
  });

  factory IndoorAmenities.fromMap(Map<String, dynamic> map) {
    return IndoorAmenities(
      airConditioner: map['air_conditioner'] ?? false,
      heater: map['heater'] ?? false,
      fan: map['fan'] ?? false,
      wardrobe: map['wardrobe'] ?? false,
      kitchen: map['kitchen'] ?? false,
      geyser: map['geyser'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "air_conditioner": airConditioner,
      "heater": heater,
      "fan": fan,
      "wardrobe": wardrobe,
      "kitchen": kitchen,
      "geyser": geyser,
    };
  }
}

class BuildingAmenities {
  final bool lift;
  final bool generator;
  final bool parking;
  final bool cctv;
  final bool fireExit;
  final bool securityGuard;

  BuildingAmenities({
    required this.lift,
    required this.generator,
    required this.parking,
    required this.cctv,
    required this.fireExit,
    required this.securityGuard,
  });

  factory BuildingAmenities.fromMap(Map<String, dynamic> map) {
    return BuildingAmenities(
      lift: map['lift'] ?? false,
      generator: map['generator'] ?? false,
      parking: map['parking'] ?? false,
      cctv: map['cctv'] ?? false,
      fireExit: map['fire_exit'] ?? false,
      securityGuard: map['security_guard'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "lift": lift,
      "generator": generator,
      "parking": parking,
      "cctv": cctv,
      "fire_exit": fireExit,
      "security_guard": securityGuard,
    };
  }
}

class RulesAndPolicies {
  final bool furnishedAllowed;
  final bool unfurnishedAllowed;
  final String? otherRules;

  RulesAndPolicies({
    required this.furnishedAllowed,
    required this.unfurnishedAllowed,
    this.otherRules,
  });

  factory RulesAndPolicies.fromMap(Map<String, dynamic> map) {
    return RulesAndPolicies(
      furnishedAllowed: map['furnished_allowed'] ?? false,
      unfurnishedAllowed: map['unfurnished_allowed'] ?? false,
      otherRules: map['other_rules'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "furnished_allowed": furnishedAllowed,
      "unfurnished_allowed": unfurnishedAllowed,
      "other_rules": otherRules,
    };
  }
}

class NotesAndDocuments {
  final String adminNotes;
  final List<UnitDocument> documents;
  final String? lastMaintenanceDate;

  NotesAndDocuments({
    required this.adminNotes,
    required this.documents,
    required this.lastMaintenanceDate,
  });

  factory NotesAndDocuments.fromMap(Map<String, dynamic> map) {
    final docs = (map['documents'] as List<dynamic>? ?? [])
        .map((e) => UnitDocument.fromMap(e as Map<String, dynamic>))
        .toList();

    return NotesAndDocuments(
      adminNotes: map['admin_notes'] ?? '',
      documents: docs,
      lastMaintenanceDate: map['last_maintenance_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "admin_notes": adminNotes,
      "documents": documents.map((e) => e.toMap()).toList(),
      "last_maintenance_date": lastMaintenanceDate,
    };
  }
}

class UnitDocument {
  final String name;
  final String type;
  final String url;

  UnitDocument({
    required this.name,
    required this.type,
    required this.url,
  });

  factory UnitDocument.fromMap(Map<String, dynamic> map) {
    return UnitDocument(
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      url: map['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "type": type,
      "url": url,
    };
  }
}
