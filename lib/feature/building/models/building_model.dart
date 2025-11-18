import 'package:cloud_firestore/cloud_firestore.dart';

class Building {
  final String id;
  final BuildingInformation buildingInformation;
  final BuildingLocation buildingLocation;
  final String note;
  final String uid;
  final Timestamp? createdAt;

  Building({
    required this.id,
    required this.buildingInformation,
    required this.buildingLocation,
    required this.note,
    required this.uid,
    required this.createdAt,
  });

  factory Building.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Building(
      id: doc.id,
      buildingInformation: BuildingInformation.fromMap(
          data["building_information"] ?? {}),
      buildingLocation:
      BuildingLocation.fromMap(data["building_location"] ?? {}),
      note: data["note"] ?? "",
      uid: data["uid"] ?? "",
      createdAt: data["created_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "building_information": buildingInformation.toMap(),
      "building_location": buildingLocation.toMap(),
      "note": note,
      "uid": uid,
      "created_at": createdAt,
    };
  }
}


class BuildingLocation {
  final String location;
  final String road;
  final String thana;
  final String postalCode;
  final String area;
  final String district;
  final String country;

  BuildingLocation({
    required this.location,
    required this.road,
    required this.thana,
    required this.postalCode,
    required this.area,
    required this.district,
    required this.country,
  });

  factory BuildingLocation.fromMap(Map<String, dynamic> map) {
    return BuildingLocation(
      location: map["location"] ?? "",
      road: map["road"] ?? "",
      thana: map["thana"] ?? "",
      postalCode: map["postal_code"] ?? "",
      area: map["area"] ?? "",
      district: map["district"] ?? "",
      country: map["country"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "location": location,
      "road": road,
      "thana": thana,
      "postal_code": postalCode,
      "area": area,
      "district": district,
      "country": country,
    };
  }
}

class BuildingInformation {
  final String buildingName;
  final String holdingNumber;

  BuildingInformation({
    required this.buildingName,
    required this.holdingNumber,
  });

  factory BuildingInformation.fromMap(Map<String, dynamic> map) {
    return BuildingInformation(
      buildingName: map["building_name"] ?? "",
      holdingNumber: map["holding_number"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "building_name": buildingName,
      "holding_number": holdingNumber,
    };
  }
}
