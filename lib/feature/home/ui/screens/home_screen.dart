import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/data/models/user.dart';
import '../controller/homecontroller.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController controller;

  @override
  void initState() {
    super.initState();

    // Initialize GetX controller
    controller = Get.put(HomeController());

    // Fetch user model
    controller.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () => controller.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final AppUser? user = controller.userModel.value;

        if (user == null) {
          return const Center(child: Text("No user data found"));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, ${user.name}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text("📛 Name: ${user.name}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),

              Text("🎂 DOB: ${user.dob}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),

              Text("📞 Phone: ${user.phone}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),

              Text("🪪 Role: ${user.role}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),

              Text("✉ Email: ${user.email}", style: const TextStyle(fontSize: 18)),
            ],
          ),
        );
      }),
    );
  }
}
