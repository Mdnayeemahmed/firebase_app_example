import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'feature/auth/ui/controller/auth_controller.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(AuthController()); // Inject controller
  runApp(const MyApp());
}

