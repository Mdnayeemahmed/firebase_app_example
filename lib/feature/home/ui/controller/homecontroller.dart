import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../auth/data/models/user.dart';
import '../../../building/models/building_model.dart';
import '../../../building/models/unit_model.dart';

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
  final RxList<BuildingModel> buildings = <BuildingModel>[].obs;
  final RxList<UnitModel> units = <UnitModel>[].obs;
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
            .map((doc) => BuildingModel.fromFirestore(doc))
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
      String uuid = _auth.currentUser!.uid.toString();

      print(buildingId.toString());

      final data = {
        "building_information": info.toMap(),
        "building_location": location.toMap(),
        "note": note,
        "uid": buildingId,
        "created_at": FieldValue.serverTimestamp(),
        "owner_uid":uuid
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


  Future<void> fetchUnits(String buildingId) async {
    isLoading.value = true;
    try {
      final unitsSnap = await FirebaseFirestore.instance
          .collection('buildings')
          .doc(buildingId)
          .collection('units')
          .get();

      final list = unitsSnap.docs.map((d) {
        final data = d.data();
        return UnitModel.fromMap(d.id,buildingId, data);
      }).toList();

      units.assignAll(list); // <-- RxList update
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUnit(UnitModel unit) async {
    await FirebaseFirestore.instance
        .collection('buildings')
        .doc(unit.buildingId)
        .collection('units')
        .doc(unit.id)
        .delete();

    units.removeWhere((u) => u.id == unit.id);
  }


  Future<void> fetchAllUnits() async {
    isLoading.value = true;
    try {
      final unitsSnap = await FirebaseFirestore.instance
          .collectionGroup('units') // 🔥 hits all /buildings/{id}/units
          .get();

      final list = unitsSnap.docs.map((d) {
        final data = d.data();

        // If you also want buildingId, you can grab it like this:
        final buildingId = d.reference.parent.parent?.id;

        // You can extend UnitModel to store buildingId if you want.
        return UnitModel.fromMap(d.id,buildingId!, data);
      }).toList();

      units.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUnit(String buildingId, UnitModel unit) async {
    await FirebaseFirestore.instance
        .collection('buildings')
        .doc(buildingId)
        .collection('units')
        .add(unit.toMap());

    await fetchUnits(buildingId);
  }

  Future<void> updateUnit({
    required String buildingId,
    required UnitModel unit,
  }) async {
    await FirebaseFirestore.instance
        .collection('buildings')
        .doc(buildingId)
        .collection('units')
        .doc(unit.id)
        .update(unit.toMap());

    // refresh list if needed
    await fetchAllUnits(); // or fetchUnits(buildingId)
  }




}
