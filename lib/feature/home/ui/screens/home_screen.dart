import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/data/models/user.dart';
import '../../../building/models/building_model.dart';
import '../../../building/ui/screen/building_form.dart';
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

    controller = Get.put(HomeController());

    controller.loadUserData();
    // controller.fetchBuildings(); // <--- IMPORTANT
  }

  // ------------------------------------------------------------
  // OPEN ADD FORM
  // ------------------------------------------------------------
  void _openAddBuilding() {
    Get.bottomSheet(
      BuildingFormSheet(
        isEdit: false,
        onSubmit: (info, location, note) {
          controller.addBuilding(
            info: info,
            location: location,
            note: note,
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  // ------------------------------------------------------------
  // OPEN UPDATE FORM
  // ------------------------------------------------------------
  void _openUpdateBuilding(Building b) {
    Get.bottomSheet(
      BuildingFormSheet(
        isEdit: true,
        info: b.buildingInformation,
        location: b.buildingLocation,
        note: b.note,
        onSubmit: (info, location, note) {
          controller.updateBuilding(
            id: b.id,
            info: info,
            location: location,
            note: note,
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  // ------------------------------------------------------------
  // BUILD UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () {} ,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openAddBuilding,
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.userModel.value;

        if (user == null) {
          return const Center(child: Text("No user data found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------- USER HEADER --------------------
              Text(
                "Welcome, ${user.name}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Text("📛 Name: ${user.name}", style: _infoStyle()),
              Text("🎂 DOB: ${user.dob}", style: _infoStyle()),
              Text("📞 Phone: ${user.phone}", style: _infoStyle()),
              Text("🪪 Role: ${user.role}", style: _infoStyle()),
              Text("✉ Email: ${user.email}", style: _infoStyle()),

              const SizedBox(height: 30),

              // -------------------- BUILDING LIST --------------------
              const Text(
                "🏢 Buildings",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Obx(() {
                if (controller.buildings.isEmpty) {
                  return const Text("No building data found. Tap + to add.");
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.buildings.length,
                  itemBuilder: (context, index) {
                    final b = controller.buildings[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(b.buildingInformation.buildingName),
                        subtitle: Text(
                          "${b.buildingLocation.area}, "
                              "${b.buildingLocation.thana}, "
                              "${b.buildingLocation.district}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _openUpdateBuilding(b),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  controller.deleteBuilding(b.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  TextStyle _infoStyle() => const TextStyle(fontSize: 18, height: 1.4);
}

