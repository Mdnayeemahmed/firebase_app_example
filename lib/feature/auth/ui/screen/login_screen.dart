import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/app_routes.dart';
import '../controller/auth_controller.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  late AuthController controller;

  @override
  void initState() {
    super.initState();

    controller = AuthController.instance;

    email.text = "";
    pass.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: pass,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  controller.loginEmail(
                    email.text.trim(),
                    pass.text.trim(),
                  );
                }else{
                  Get.snackbar("Error", "No Data");
                }

              },
              child: const Text("Login"),
            ),

            const SizedBox(height: 12),

            // OutlinedButton(
            //   onPressed: () => controller.loginGoogle(),
            //   child: const Text("Login with Google"),
            // ),

            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.phone),
              child: const Text("Login with Phone (OTP)"),
            ),

            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.register),
              child: const Text("Create new account"),
            ),
          ],
        ),
      )),
    );
  }
}
