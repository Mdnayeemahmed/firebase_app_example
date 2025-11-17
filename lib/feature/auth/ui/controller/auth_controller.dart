import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../app/app_routes.dart';
import '../../data/data_source/auth_data_source.dart';


class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final auth = FirebaseAuth.instance;
  final users = FirebaseFirestore.instance.collection("users");
  final building = FirebaseFirestore.instance.collection("building");


  var isLoading = false.obs;
  var verificationId = "".obs;

  ///collection->doc->data

  // STORE TEMP DATA FOR PHONE LOGIN
  String tempName = "";
  String tempDob = "";
  String tempPhone = "";
  String tempRole = "";

  // ----------------------------------------
  // SAVE USER DATA TO FIRESTORE
  // ----------------------------------------

  Future<void> saveUserData(User user, String name, String dob, String phone, String role) async {
    await users.doc(user.uid).set({
      "uid": user.uid,
      "name": name,
      "dob": dob,
      "phone": phone,
      "role": role,
      "email": user.email,
      "created_at": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Future<void> saveBuildingData(
  //     User user,
  //     String name,
  //     String dob,
  //     String phone,
  //     String role,
  //     ) async {
  //
  //   final Map<String, dynamic> data = {
  //     "information": {
  //       "uid": user.uid,
  //       "name": name,
  //       "dob": dob,
  //       "phone": phone,
  //       "role": role,
  //       "email": user.email,
  //       "created_at": FieldValue.serverTimestamp(),
  //     },
  //   };
  //
  //   await users.doc(user.uid).set(
  //     data,
  //     SetOptions(merge: true),
  //   );
  // }


  // ----------------------------------------
  // EMAIL REGISTRATION
  // ----------------------------------------

  Future<void> registerEmail({
    required String name,
    required String dob,
    required String phone,
    required String role,
    required String email,
    required String password,
  }) async {
    try {
      isLoading(true);

      final userCred = await auth.createUserWithEmailAndPassword(email: email, password: password);


       final x = userCred.user;

      if (x != null) {
        await saveUserData(x, name, dob, phone, role);
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // ----------------------------------------
  // EMAIL LOGIN
  // ----------------------------------------
  Future<void> loginEmail(String email, String password) async {
    try {
      isLoading(true);

      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // ----------------------------------------
  // GOOGLE SIGN-IN
  // ----------------------------------------
  // Future<void> loginGoogle() async {
  //   try {
  //     isLoading(true);
  //
  //     final user = await AuthService().signInWithGoogle(role: "student");
  //
  //     if (user != null) {
  //       Get.offAllNamed(AppRoutes.home);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Google Error", e.toString());
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  // ----------------------------------------
  // PHONE AUTH – SEND OTP
  // ----------------------------------------
  Future<void> sendOtp({
    required String name,
    required String dob,
    required String phone,
    required String role,
  }) async {
    try {
      isLoading(true);

      tempName = name;
      tempDob = dob;
      tempPhone = phone;
      tempRole = role;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          Get.snackbar("Phone Error", e.message ?? "Failed");
        },
        codeSent: (verId, _) {
          verificationId.value = verId;
          Get.toNamed(AppRoutes.otp);
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      Get.snackbar("Phone Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // ----------------------------------------
  // VERIFY OTP
  // ----------------------------------------
  Future<void> verifyOtp(String otp) async {
    try {
      isLoading(true);

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      final userCred = await auth.signInWithCredential(credential);
      final user = userCred.user;

      if (user != null) {
        await saveUserData(user, tempName, tempDob, tempPhone, tempRole);
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar("OTP Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // ----------------------------------------
  // LOGOUT
  // ----------------------------------------
  Future<void> logout() async {
    await auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
