import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../auth/data/models/user.dart';

class HomeController extends GetxController {
  final auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection("users");

  // Rx model
  var userModel = Rx<AppUser?>(null);
  var isLoading = false.obs;

  // Load Firestore user model
  Future<void> loadUserData() async {
    try {
      isLoading(true);

      final currentUser = auth.currentUser;
      if (currentUser == null) {
        userModel.value = null;
        return;
      }

      final doc = await userCollection.doc(currentUser.uid).get();

      if (doc.exists) {
        userModel.value = AppUser.fromJson(doc.data()!);
      } else {
        userModel.value = null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    await auth.signOut();
    Get.offAllNamed("/login");
  }
}
