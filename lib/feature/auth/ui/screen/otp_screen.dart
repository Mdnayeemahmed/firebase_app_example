import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/app_routes.dart';
import '../controller/auth_controller.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final otp = TextEditingController();
  late AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = AuthController.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: otp,
              decoration: const InputDecoration(labelText: "Enter OTP"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => controller.verifyOtp(otp.text.trim()),
              child: const Text("Verify"),
            )
          ],
        ),
      )),
    );
  }
}
