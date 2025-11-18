import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../auth/data/models/user.dart';
import '../../../building/models/building_model.dart';

class HomeController extends GetxController {
  // ------------------------------------------------------------------
  // Firebase instances
  // ------------------------------------------------------------------
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var userModel = Rx<AppUser?>(null);

  // ------------------------------------------------------------------
  // Reactive variables
  // ------------------------------------------------------------------
  final RxList<Building> buildings = <Building>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadUserData() async {
    final uid = _auth.currentUser!.uid;

    final doc = await _db.collection("users").doc(uid).get();

    if (doc.exists) {
      userModel.value = AppUser.fromJson(doc.data()!);
    }
  }

  // ------------------------------------------------------------------
  // Fetch buildings (Realtime Listener)
  // ------------------------------------------------------------------
  Future<void> fetchBuildings() async {
    try {
      _firestore
          .collection("buildings")
          .orderBy("created_at", descending: true)
          .snapshots()
          .listen((snapshot) {
        buildings.value = snapshot.docs
            .map((doc) => Building.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print("Error fetching buildings: $e");
    }
  }

  // ------------------------------------------------------------------
  // Add new building
  // ------------------------------------------------------------------
  Future<void> addBuilding({
    required BuildingInformation info,
    required BuildingLocation location,
    required String note,
  }) async {
    try {
      String buildingId = _firestore.collection("buildings").doc().id;

      print(buildingId.toString());

      final data = {
        "building_information": info.toMap(),
        "building_location": location.toMap(),
        "note": note,
        "uid": buildingId,
        "created_at": FieldValue.serverTimestamp(),
      };

      await _firestore.collection("buildings").doc(buildingId).set(data);
    } catch (e) {
      print("Error adding building: $e");
    }
  }

  // ------------------------------------------------------------------
  // Update building
  // ------------------------------------------------------------------
  Future<void> updateBuilding({
    required String id,
    required BuildingInformation info,
    required BuildingLocation location,
    required String note,
  }) async {
    try {
      final updatedData = {
        "building_information": info.toMap(),
        "building_location": location.toMap(),
        "note": note,
      };

      await _firestore
          .collection("buildings")
          .doc(id)
          .update(updatedData);
    } catch (e) {
      print("Error updating building: $e");
    }
  }

  // ------------------------------------------------------------------
  // Delete building
  // ------------------------------------------------------------------
  Future<void> deleteBuilding(String id) async {
    try {
      await _firestore.collection("buildings").doc(id).delete();
    } catch (e) {
      print("Error deleting building: $e");
    }
  }
}
