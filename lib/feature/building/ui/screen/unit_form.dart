import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/building_model.dart';
import '../../models/unit_model.dart';

class UnitFormSheet extends StatefulWidget {
  final bool isEdit;
  final UnitModel? initialUnit;
  final List<BuildingModel> buildings;
  final void Function(String buildingId, UnitModel unit) onSubmit;

  const UnitFormSheet({
    super.key,
    required this.isEdit,
    this.initialUnit,
    required this.buildings,
    required this.onSubmit,
  });

  @override
  State<UnitFormSheet> createState() => _UnitFormSheetState();
}

class _UnitFormSheetState extends State<UnitFormSheet> {
  // Text controllers (no building name here now)
  final _unitNameCtrl = TextEditingController();
  final _unitSizeCtrl = TextEditingController();
  final _bedroomsCtrl = TextEditingController();
  final _bathroomsCtrl = TextEditingController();
  final _balconiesCtrl = TextEditingController();
  final _floorCtrl = TextEditingController();
  final _unitOwnershipCtrl = TextEditingController();
  final _unitCategoryCtrl = TextEditingController();
  final _unitStatusCtrl = TextEditingController();
  final _maintenanceByCtrl = TextEditingController();

  final _roadCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _thanaCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();

  final _adminNotesCtrl = TextEditingController();
  final _docsCtrl = TextEditingController();

  // Switches / bools
  bool _electricity = true;
  bool _water = true;
  bool _internet = true;
  bool _gas = true;
  bool _garbage = true;
  bool _solar = false;

  bool _ac = true;
  bool _heater = false;
  bool _fan = true;
  bool _wardrobe = true;
  bool _kitchen = true;
  bool _geyser = true;

  bool _lift = true;
  bool _generator = true;
  bool _parking = true;
  bool _cctv = true;
  bool _fireExit = true;
  bool _securityGuard = true;

  bool _furnishedAllowed = true;
  bool _unfurnishedAllowed = true;

  BuildingModel? _selectedBuilding;

  @override
  void initState() {
    super.initState();
    final d = widget.initialUnit;
    if (d != null) {
      // Try to match building by name (best effort)
      for (final b in widget.buildings) {
        if (b.buildingInformation.buildingName ==
            d.unitInformation.buildingName) {
          _selectedBuilding = b;
          break;
        }
      }

      // ---- unit_information ----
      _unitNameCtrl.text = d.unitInformation.unitNumber;
      _unitSizeCtrl.text = d.unitInformation.unitSizeSqFt.toString();
      _bedroomsCtrl.text = d.unitInformation.bedrooms.toString();
      _bathroomsCtrl.text = d.unitInformation.bathrooms.toString();
      _balconiesCtrl.text = d.unitInformation.balconies.toString();
      _floorCtrl.text = d.unitInformation.floor;
      _unitOwnershipCtrl.text = d.unitInformation.unitOwnership;
      _unitCategoryCtrl.text = d.unitInformation.unitCategory;
      _unitStatusCtrl.text = d.unitInformation.unitStatus;
      _maintenanceByCtrl.text = d.unitInformation.maintenanceBy;

      // ---- unit_location ----
      _roadCtrl.text = d.unitLocation.roadStreetName;
      _areaCtrl.text = d.unitLocation.areaSectorVillage;
      _thanaCtrl.text = d.unitLocation.thanaUpazila;
      _districtCtrl.text = d.unitLocation.districtCity;
      _postalCodeCtrl.text = d.unitLocation.postalCode;
      _countryCtrl.text = d.unitLocation.country;

      // ---- utilities ----
      _electricity = d.utilities.electricity;
      _water      = d.utilities.water;
      _internet   = d.utilities.internet;
      _gas        = d.utilities.gas;
      _garbage    = d.utilities.garbageDisposal;
      _solar      = d.utilities.solarPanel;

      // ---- indoor_amenities ----
      _ac       = d.indoorAmenities.airConditioner;
      _heater   = d.indoorAmenities.heater;
      _fan      = d.indoorAmenities.fan;
      _wardrobe = d.indoorAmenities.wardrobe;
      _kitchen  = d.indoorAmenities.kitchen;
      _geyser   = d.indoorAmenities.geyser;

      // ---- building_amenities ----
      _lift          = d.buildingAmenities.lift;
      _generator     = d.buildingAmenities.generator;
      _parking       = d.buildingAmenities.parking;
      _cctv          = d.buildingAmenities.cctv;
      _fireExit      = d.buildingAmenities.fireExit;
      _securityGuard = d.buildingAmenities.securityGuard;

      // ---- rules_and_policies ----
      _furnishedAllowed   = d.rulesAndPolicies.furnishedAllowed;
      _unfurnishedAllowed = d.rulesAndPolicies.unfurnishedAllowed;

      // ---- notes_and_documents ----
      _adminNotesCtrl.text = d.notesAndDocuments.adminNotes;
      _docsCtrl.text = d.notesAndDocuments.documents
          .map((doc) => doc.name)
          .join(", ");
    }
  }

  @override
  void dispose() {
    _unitNameCtrl.dispose();
    _unitSizeCtrl.dispose();
    _bedroomsCtrl.dispose();
    _bathroomsCtrl.dispose();
    _balconiesCtrl.dispose();
    _floorCtrl.dispose();
    _unitOwnershipCtrl.dispose();
    _unitCategoryCtrl.dispose();
    _unitStatusCtrl.dispose();
    _maintenanceByCtrl.dispose();

    _roadCtrl.dispose();
    _areaCtrl.dispose();
    _thanaCtrl.dispose();
    _districtCtrl.dispose();
    _postalCodeCtrl.dispose();
    _countryCtrl.dispose();

    _adminNotesCtrl.dispose();
    _docsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedBuilding == null) {
      Get.snackbar("Error", "Please select a building");
      return;
    }
    if (_unitNameCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Unit number / name is required");
      return;
    }

    int _parseInt(String s) => int.tryParse(s.trim()) ?? 0;

    final docNames = _docsCtrl.text
        .split(",")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final docs = docNames
        .map((name) => UnitDocument(
      name: name,
      type: "manual",
      url: "",
    ))
        .toList();

    final buildingName =
        _selectedBuilding!.buildingInformation.buildingName;

    final unit = UnitModel(
      id: widget.initialUnit?.id ?? "",
      unitInformation: UnitInformation(
        buildingName: buildingName,
        unitNumber: _unitNameCtrl.text.trim(),
        unitSizeSqFt: _parseInt(_unitSizeCtrl.text),
        bedrooms: _parseInt(_bedroomsCtrl.text),
        bathrooms: _parseInt(_bathroomsCtrl.text),
        balconies: _parseInt(_balconiesCtrl.text),
        floor: _floorCtrl.text.trim(),
        unitOwnership: _unitOwnershipCtrl.text.trim(),
        unitCategory: _unitCategoryCtrl.text.trim(),
        unitStatus: _unitStatusCtrl.text.trim(),
        maintenanceBy: _maintenanceByCtrl.text.trim(),
      ),
      unitLocation: UnitLocation(
        roadStreetName: _roadCtrl.text.trim(),
        areaSectorVillage: _areaCtrl.text.trim(),
        thanaUpazila: _thanaCtrl.text.trim(),
        districtCity: _districtCtrl.text.trim(),
        postalCode: _postalCodeCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
      ),
      utilities: Utilities(
        electricity: _electricity,
        water: _water,
        internet: _internet,
        gas: _gas,
        garbageDisposal: _garbage,
        solarPanel: _solar,
      ),
      indoorAmenities: IndoorAmenities(
        airConditioner: _ac,
        heater: _heater,
        fan: _fan,
        wardrobe: _wardrobe,
        kitchen: _kitchen,
        geyser: _geyser,
      ),
      buildingAmenities: BuildingAmenities(
        lift: _lift,
        generator: _generator,
        parking: _parking,
        cctv: _cctv,
        fireExit: _fireExit,
        securityGuard: _securityGuard,
      ),
      rulesAndPolicies: RulesAndPolicies(
        furnishedAllowed: _furnishedAllowed,
        unfurnishedAllowed: _unfurnishedAllowed,
        otherRules: null,
      ),
      notesAndDocuments: NotesAndDocuments(
        adminNotes: _adminNotesCtrl.text.trim(),
        documents: docs,
        lastMaintenanceDate: null,
      ), buildingId: _selectedBuilding!.id,
    );

    widget.onSubmit(_selectedBuilding!.id, unit);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isEdit ? "Edit Unit" : "Add Unit",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Building & Unit Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 🔽 Building dropdown
                      DropdownButtonFormField<BuildingModel>(
                        value: _selectedBuilding,
                        decoration: const InputDecoration(
                          labelText: "Select Building",
                          border: OutlineInputBorder(),
                        ),
                        items: widget.buildings
                            .map(
                              (b) => DropdownMenuItem<BuildingModel>(
                            value: b,
                            child: Text(
                              b.buildingInformation.buildingName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (b) {
                          setState(() {
                            _selectedBuilding = b;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                      _textField("Unit Number / Name", _unitNameCtrl),
                      _textField("Unit Size (Sq. Ft)", _unitSizeCtrl,
                          keyboardType: TextInputType.number),
                      _textField("Bedrooms", _bedroomsCtrl,
                          keyboardType: TextInputType.number),
                      _textField("Bathrooms", _bathroomsCtrl,
                          keyboardType: TextInputType.number),
                      _textField("Balconies", _balconiesCtrl,
                          keyboardType: TextInputType.number),
                      _textField("Floor", _floorCtrl),
                      _textField("Unit Ownership", _unitOwnershipCtrl,
                          hint: "Owned Property / Rented"),
                      _textField("Unit Category", _unitCategoryCtrl,
                          hint: "Residential / Commercial"),
                      _textField("Unit Status", _unitStatusCtrl,
                          hint: "Vacant / Occupied"),
                      _textField("Maintenance By", _maintenanceByCtrl,
                          hint: "Owner / Developer / Association"),
                      const SizedBox(height: 16),

                      const Text(
                        "Unit Location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _textField("Road / Street Name", _roadCtrl),
                      _textField("Area / Sector / Village", _areaCtrl),
                      _textField("Thana / Upazila", _thanaCtrl),
                      _textField("District / City", _districtCtrl),
                      _textField("Postal Code", _postalCodeCtrl,
                          keyboardType: TextInputType.number),
                      _textField("Country", _countryCtrl),
                      const SizedBox(height: 16),

                      const Text(
                        "Utilities",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SwitchListTile(
                        title: const Text("Electricity"),
                        value: _electricity,
                        onChanged: (v) => setState(() => _electricity = v),
                      ),
                      SwitchListTile(
                        title: const Text("Water"),
                        value: _water,
                        onChanged: (v) => setState(() => _water = v),
                      ),
                      SwitchListTile(
                        title: const Text("Internet"),
                        value: _internet,
                        onChanged: (v) => setState(() => _internet = v),
                      ),
                      SwitchListTile(
                        title: const Text("Gas"),
                        value: _gas,
                        onChanged: (v) => setState(() => _gas = v),
                      ),
                      SwitchListTile(
                        title: const Text("Garbage Disposal"),
                        value: _garbage,
                        onChanged: (v) => setState(() => _garbage = v),
                      ),
                      SwitchListTile(
                        title: const Text("Solar Panel"),
                        value: _solar,
                        onChanged: (v) => setState(() => _solar = v),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        "Indoor Amenities",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SwitchListTile(
                        title: const Text("Air Conditioner"),
                        value: _ac,
                        onChanged: (v) => setState(() => _ac = v),
                      ),
                      SwitchListTile(
                        title: const Text("Heater"),
                        value: _heater,
                        onChanged: (v) => setState(() => _heater = v),
                      ),
                      SwitchListTile(
                        title: const Text("Fan"),
                        value: _fan,
                        onChanged: (v) => setState(() => _fan = v),
                      ),
                      SwitchListTile(
                        title: const Text("Wardrobe"),
                        value: _wardrobe,
                        onChanged: (v) => setState(() => _wardrobe = v),
                      ),
                      SwitchListTile(
                        title: const Text("Kitchen"),
                        value: _kitchen,
                        onChanged: (v) => setState(() => _kitchen = v),
                      ),
                      SwitchListTile(
                        title: const Text("Geyser"),
                        value: _geyser,
                        onChanged: (v) => setState(() => _geyser = v),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        "Building Amenities",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SwitchListTile(
                        title: const Text("Lift"),
                        value: _lift,
                        onChanged: (v) => setState(() => _lift = v),
                      ),
                      SwitchListTile(
                        title: const Text("Generator"),
                        value: _generator,
                        onChanged: (v) => setState(() => _generator = v),
                      ),
                      SwitchListTile(
                        title: const Text("Parking"),
                        value: _parking,
                        onChanged: (v) => setState(() => _parking = v),
                      ),
                      SwitchListTile(
                        title: const Text("CCTV"),
                        value: _cctv,
                        onChanged: (v) => setState(() => _cctv = v),
                      ),
                      SwitchListTile(
                        title: const Text("Fire Exit"),
                        value: _fireExit,
                        onChanged: (v) => setState(() => _fireExit = v),
                      ),
                      SwitchListTile(
                        title: const Text("Security Guard"),
                        value: _securityGuard,
                        onChanged: (v) =>
                            setState(() => _securityGuard = v),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Rules & Policies",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SwitchListTile(
                        title: const Text("Furnished Allowed"),
                        value: _furnishedAllowed,
                        onChanged: (v) =>
                            setState(() => _furnishedAllowed = v),
                      ),
                      SwitchListTile(
                        title: const Text("Unfurnished Allowed"),
                        value: _unfurnishedAllowed,
                        onChanged: (v) =>
                            setState(() => _unfurnishedAllowed = v),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Notes & Documents",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _textField(
                        "Admin / Manager Notes",
                        _adminNotesCtrl,
                        maxLines: 3,
                      ),
                      _textField(
                        "Uploaded Documents (comma separated)",
                        _docsCtrl,
                        hint:
                        "FloorPlan.pdf, Electricity_Bill.pdf, Gas_Bill.pdf",
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(isEdit ? "Update Unit" : "Save Unit"),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _textField(
      String label,
      TextEditingController controller, {
        String? hint,
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}



