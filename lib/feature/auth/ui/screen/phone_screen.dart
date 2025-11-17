import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  final name = TextEditingController();
  final dob = TextEditingController();
  final phone = TextEditingController();
  String role = "student";

  late AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = AuthController.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login (OTP)")),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dob,
              decoration: const InputDecoration(labelText: "Date of Birth"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "Phone Number (+880...)"),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: role,
              items: ["student", "seller", "admin"]
                  .map((r) => DropdownMenuItem(
                value: r,
                child: Text(r.toUpperCase()),
              ))
                  .toList(),
              onChanged: (v) => setState(() => role = v!),
              decoration: const InputDecoration(labelText: "Role"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                controller.sendOtp(
                  name: name.text,
                  dob: dob.text,
                  phone: phone.text.trim(),
                  role: role,
                );
              },
              child: const Text("Send OTP"),
            ),
          ],
        ),
      )),
    );
  }
}
