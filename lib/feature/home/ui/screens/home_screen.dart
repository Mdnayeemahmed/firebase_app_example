import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/data/models/user.dart';
import '../../../building/models/building_model.dart';
import '../../../building/models/unit_model.dart';
import '../../../building/ui/screen/building_form.dart';
import '../../../building/ui/screen/unit_form.dart';
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
    controller.fetchBuildings();
    controller.fetchAllUnits(); // implement in controller
  }

  // ------------------------------------------------------------
  // OPEN ADD FORM (BUILDING)
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
  // OPEN UPDATE FORM (BUILDING)
  // ------------------------------------------------------------
  void _openUpdateBuilding(BuildingModel b) {
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
  // UNIT ADD FORM (USES UnitModel)
  // ------------------------------------------------------------
  void _openAddUnit() {
    Get.bottomSheet(
      UnitFormSheet(
        isEdit: false,
        buildings: controller.buildings, // RxList works as List here
        onSubmit: (buildingId, unitData) {
          controller.addUnit(buildingId, unitData);
        },
      ),
      isScrollControlled: true,
    );
  }


  // ------------------------------------------------------------
  // BUILD UI WITH TABS
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 1: Buildings, 2: Units
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.apartment), text: "Buildings"),
              Tab(icon: Icon(Icons.meeting_room), text: "Units"),
            ],
          ),
        ),

        // FAB behaves differently depending on which tab is active
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                final tabIndex = DefaultTabController.of(context).index;
                if (tabIndex == 0) {
                  _openAddBuilding();
                } else {
                  _openAddUnit();
                }
              },
            );
          },
        ),

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = controller.userModel.value;

          if (user == null) {
            return const Center(child: Text("No user data found"));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------- USER HEADER --------------------
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                    const SizedBox(height: 16),
                    Text("📛 Name: ${user.name}", style: _infoStyle()),
                    Text("🎂 DOB: ${user.dob}", style: _infoStyle()),
                    Text("📞 Phone: ${user.phone}", style: _infoStyle()),
                    Text("🪪 Role: ${user.role}", style: _infoStyle()),
                    Text("✉ Email: ${user.email}", style: _infoStyle()),
                  ],
                ),
              ),

              const Divider(height: 1),

              // -------------------- TABS CONTENT --------------------
              Expanded(
                child: TabBarView(
                  children: [
                    // ---------- TAB 1: BUILDINGS ----------
                    Obx(() {
                      if (controller.buildings.isEmpty) {
                        return const Center(
                          child: Text("No building data found. Tap + to add."),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.buildings.length,
                        itemBuilder: (context, index) {
                          final b = controller.buildings[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                b.buildingInformation.buildingName,
                              ),
                              subtitle: Text(
                                "${b.buildingLocation.area}, "
                                    "${b.buildingLocation.thana}, "
                                    "${b.buildingLocation.district}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () => _openUpdateBuilding(b),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
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

                    // ---------- TAB 2: UNITS ----------
// ---------- TAB 2: UNITS ----------
                    Obx(() {
                      if (controller.units.isEmpty) {
                        return const Center(
                          child: Text("No unit data found. Tap + to add."),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.units.length,
                        itemBuilder: (context, index) {
                          final u = controller.units[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                "${u.unitInformation.buildingName} • "
                                    "Unit ${u.unitInformation.unitNumber}",
                              ),
                              subtitle: Text(
                                "Floor: ${u.unitInformation.floor} • "
                                    "${u.unitLocation.areaSectorVillage}, "
                                    "${u.unitLocation.districtCity}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _openEditUnit(u),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => controller.deleteUnit(u),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    })
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _openEditUnit(UnitModel unit) {
    Get.bottomSheet(
      UnitFormSheet(
        isEdit: true,
        initialUnit: unit,
        buildings: controller.buildings,
        onSubmit: (buildingId, updatedUnit) {
          controller.updateUnit(
            buildingId: buildingId,
            unit: updatedUnit,
          );
        },
      ),
      isScrollControlled: true,
    );
  }


  TextStyle _infoStyle() => const TextStyle(fontSize: 18, height: 1.4);
}


