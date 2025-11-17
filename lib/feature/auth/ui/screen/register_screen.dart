import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final name = TextEditingController();
  final dob = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();

  String role = "student";

  late AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = AuthController.instance;

    /// Optional default values
    role = "student";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
              decoration: const InputDecoration(labelText: "Date of Birth (YYYY-MM-DD)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
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
                final isSuccess=controller.registerEmail(
                  name: name.text.trim(),
                  dob: dob.text.trim(),
                  phone: phone.text.trim(),
                  role: role,
                  email: email.text.trim(),
                  password: pass.text.trim(),
                );
              },
              child: const Text("Register"),
            )
          ],
        ),
      )),
    );
  }
}
