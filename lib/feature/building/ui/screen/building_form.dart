import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../models/building_model.dart';

class BuildingFormSheet extends StatefulWidget {
  final bool isEdit;
  final BuildingInformation? info;
  final BuildingLocation? location;
  final String? note;

  final Function(
      BuildingInformation info,
      BuildingLocation location,
      String note,
      ) onSubmit;

  const BuildingFormSheet({
    super.key,
    required this.isEdit,
    this.info,
    this.location,
    this.note,
    required this.onSubmit,
  });

  @override
  State<BuildingFormSheet> createState() => _BuildingFormSheetState();
}

class _BuildingFormSheetState extends State<BuildingFormSheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final name = TextEditingController();
  final holding = TextEditingController();
  final loc = TextEditingController();
  final road = TextEditingController();
  final thana = TextEditingController();
  final postal = TextEditingController();
  final area = TextEditingController();
  final district = TextEditingController();
  final country = TextEditingController();
  final note = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      name.text = widget.info?.buildingName ?? "";
      holding.text = widget.info?.holdingNumber ?? "";
      loc.text = widget.location?.location ?? "";
      road.text = widget.location?.road ?? "";
      thana.text = widget.location?.thana ?? "";
      postal.text = widget.location?.postalCode ?? "";
      area.text = widget.location?.area ?? "";
      district.text = widget.location?.district ?? "";
      country.text = widget.location?.country ?? "";
      note.text = widget.note ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEdit ? "Update Building" : "Add Building",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // SECTION: BUILDING INFO
              _sectionTitle("Building Information"),
              _field(name, "Building Name", required: true),
              _field(holding, "Holding Number", required: true),

              // SECTION: LOCATION
              _sectionTitle("Building Location"),
              _field(loc, "Location", required: true),
              _field(road, "Road / Street Name"),
              _field(thana, "Thana / Upazila"),
              _field(
                postal,
                "Postal Code",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return "Postal code must contain digits only";
                  }
                  return null;
                },
              ),
              _field(area, "Area / Sector / Village"),
              _field(district, "District / City"),
              _field(country, "Country", required: true),

              // SECTION: NOTE
              _sectionTitle("Additional Information"),
              _field(note, "Note / Comment", maxLines: 2),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    widget.isEdit ? "Update" : "Save",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ Helper Widgets ------------------

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
    );
  }

  Widget _field(
      TextEditingController controller,
      String label, {
        bool required = false,
        int maxLines = 1,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: validator ??
            (required
                ? (value) {
              if (value == null || value.trim().isEmpty) {
                return "$label is required";
              }
              return null;
            }
                : null),
      ),
    );
  }

  // ------------------ Submit Handler ------------------

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final info = BuildingInformation(
      buildingName: name.text.trim(),
      holdingNumber: holding.text.trim(),
    );

    final locationObj = BuildingLocation(
      location: loc.text.trim(),
      road: road.text.trim(),
      thana: thana.text.trim(),
      postalCode: postal.text.trim(),
      area: area.text.trim(),
      district: district.text.trim(),
      country: country.text.trim(),
    );

    widget.onSubmit(info, locationObj, note.text.trim());
    Get.back();
  }
}
