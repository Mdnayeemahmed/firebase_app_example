// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// import '../models/user.dart';
//
// class AuthService {
//   final auth = FirebaseAuth.instance;
//   final users = FirebaseFirestore.instance.collection("users");
//
//   // GOOGLE LOGIN (WORKS FOR google_sign_in: ^7.2.0)
//   Future<AppUser?> signInWithGoogle({String role = "student"}) async {
//     try {
//       // GoogleSignIn constructor STILL works in v7.2.0 when using named constructors
//       final GoogleSignIn googleSignIn = GoogleSignIn(
//         scopes: ["email", "profile"],
//       );
//
//       final GoogleSignInAccount? googleUser =
//       await googleSignIn.signIn();      // ✅ This still works
//       if (googleUser == null) return null;
//
//       // Get tokens (STILL VALID in 7.2.0)
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final userCred = await auth.signInWithCredential(credential);
//       final User? user = userCred.user;
//
//       if (user == null) return null;
//
//       // Check if Firestore doc exists
//       final doc = await users.doc(user.uid).get();
//
//       if (!doc.exists) {
//         final newUser = AppUser(
//           uid: user.uid,
//           name: user.displayName ?? "",
//           dob: "",
//           phone: user.phoneNumber ?? "",
//           role: role,
//           email: user.email ?? "",
//         );
//
//         // Save to Firestore
//         await users.doc(user.uid).set(newUser.toJson());
//         return newUser;
//       }
//
//       return AppUser.fromJson(doc.data()!);
//     } catch (e) {
//       print("GOOGLE LOGIN ERROR: $e");
//       return null;
//     }
//   }
// }
