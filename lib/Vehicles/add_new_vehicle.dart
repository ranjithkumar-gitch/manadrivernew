import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

class AddNewVehicle extends StatefulWidget {
  const AddNewVehicle({super.key});

  @override
  State<AddNewVehicle> createState() => _AddNewVehicleState();
}

class _AddNewVehicleState extends State<AddNewVehicle> {
  final List<Map<String, String>> vehicleData = [
    {"brand": "Tata", "model": "Ace", "category": "Commercial"},
    {"brand": "Tata", "model": "Intra V30", "category": "Commercial"},
    {"brand": "Tata", "model": "Winger", "category": "Commercial"},
    {"brand": "Tata", "model": "407", "category": "Commercial"},
    {"brand": "Tata", "model": "709", "category": "Commercial"},
    {"brand": "Tata", "model": "Ultra", "category": "Commercial"},
    {"brand": "Tata", "model": "Prima", "category": "Commercial"},
    {"brand": "Tata", "model": "Harrier", "category": "Premium"},
    {"brand": "Tata", "model": "Safari", "category": "Premium"},
    {
      "brand": "Tata",
      "model": "Curvv (upcoming higher variants)",
      "category": "Premium",
    },
    {"brand": "Tata", "model": "Tiago", "category": "Light"},
    {"brand": "Tata", "model": "Tigor", "category": "Light"},
    {"brand": "Tata", "model": "Altroz", "category": "Light"},
    {"brand": "Tata", "model": "Punch", "category": "Light"},
    {"brand": "Tata", "model": "Nexon", "category": "Light"},

    // Mahindra
    {"brand": "Mahindra", "model": "Jeeto", "category": "Commercial"},
    {"brand": "Mahindra", "model": "Supro", "category": "Commercial"},
    {"brand": "Mahindra", "model": "Bolero Pickup", "category": "Commercial"},
    {"brand": "Mahindra", "model": "Furio 7", "category": "Commercial"},
    {"brand": "Mahindra", "model": "Furio 12", "category": "Commercial"},
    {
      "brand": "Mahindra",
      "model": "XUV300 (top variants)",
      "category": "Premium",
    },
    {"brand": "Mahindra", "model": "XUV400", "category": "Premium"},
    {"brand": "Mahindra", "model": "XUV500", "category": "Premium"},
    {"brand": "Mahindra", "model": "XUV700", "category": "Premium"},
    {
      "brand": "Mahindra",
      "model": "Thar (top variants)",
      "category": "Premium",
    },
    {"brand": "Mahindra", "model": "Scorpio-N", "category": "Premium"},

    {"brand": "Ashok Leyland", "model": "Dost", "category": "Commercial"},
    {"brand": "Ashok Leyland", "model": "Partner", "category": "Commercial"},
    {"brand": "Ashok Leyland", "model": "Ecomet", "category": "Commercial"},
    {"brand": "Ashok Leyland", "model": "Boss", "category": "Commercial"},
    {"brand": "Ashok Leyland", "model": "Captain", "category": "Commercial"},
    {"brand": "Ashok Leyland", "model": "Falcon Bus", "category": "Commercial"},

    {"brand": "Maruti Suzuki", "model": "Alto 800", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Alto K10", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Celerio", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "WagonR", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Swift", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Dzire", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Baleno", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Fronx", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Ignis", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Ertiga", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "XL6", "category": "Light"},
    {"brand": "Maruti Suzuki", "model": "Brezza", "category": "Light"},

    {"brand": "Toyota", "model": "Innova Crysta", "category": "Premium"},
    {"brand": "Toyota", "model": "Innova HyCross", "category": "Premium"},
    {"brand": "Toyota", "model": "Fortuner", "category": "Premium"},
    {"brand": "Toyota", "model": "Camry", "category": "Premium"},
    {"brand": "Toyota", "model": "Hilux", "category": "Premium"},
    {"brand": "Toyota", "model": "Vellfire", "category": "Premium"},
    {"brand": "Toyota", "model": "Glanza", "category": "Light"},
    {"brand": "Toyota", "model": "Urban Cruiser Taisor", "category": "Light"},

    {
      "brand": "Hyundai",
      "model": "Creta (top variants)",
      "category": "Premium",
    },
    {"brand": "Hyundai", "model": "Alcazar", "category": "Premium"},
    {"brand": "Hyundai", "model": "Tucson", "category": "Premium"},
    {"brand": "Hyundai", "model": "IONIQ 5", "category": "Premium"},
    {"brand": "Hyundai", "model": "Santro", "category": "Light"},
    {"brand": "Hyundai", "model": "Grand i10 Nios", "category": "Light"},
    {"brand": "Hyundai", "model": "i20", "category": "Light"},
    {"brand": "Hyundai", "model": "i20 N-Line", "category": "Light"},
    {"brand": "Hyundai", "model": "Aura", "category": "Light"},
    {"brand": "Hyundai", "model": "Venue", "category": "Light"},

    {"brand": "Kia", "model": "Seltos (top variants)", "category": "Premium"},
    {"brand": "Kia", "model": "Carens (top variants)", "category": "Premium"},
    {"brand": "Kia", "model": "Carnival", "category": "Premium"},
    {"brand": "Kia", "model": "EV6", "category": "Premium"},
    {"brand": "Kia", "model": "Sonet", "category": "Light"},

    {"brand": "Eicher", "model": "Pro 2049", "category": "Commercial"},
    {"brand": "Eicher", "model": "Pro 3015", "category": "Commercial"},
    {"brand": "Eicher", "model": "Pro 2110", "category": "Commercial"},
    {"brand": "Eicher", "model": "Skyline Bus", "category": "Commercial"},

    {
      "brand": "Force",
      "model": "Traveller 12 Seater",
      "category": "Commercial",
    },
    {
      "brand": "Force",
      "model": "Traveller 17 Seater",
      "category": "Commercial",
    },
    {
      "brand": "Force",
      "model": "Traveller 26 Seater",
      "category": "Commercial",
    },
    {"brand": "Force", "model": "Urbania", "category": "Commercial"},

    {"brand": "Piaggio", "model": "Ape Xtra", "category": "Commercial"},
    {"brand": "Piaggio", "model": "Ape City", "category": "Commercial"},

    {"brand": "Honda", "model": "Amaze", "category": "Light"},
    {"brand": "Honda", "model": "Jazz (legacy)", "category": "Light"},
    {"brand": "Honda", "model": "WR-V (legacy)", "category": "Light"},

    {"brand": "Isuzu", "model": "D-MAX S-Cab", "category": "Commercial"},
    {"brand": "Isuzu", "model": "S-Cab Z", "category": "Commercial"},
    {"brand": "Isuzu", "model": "D-MAX Regular Cab", "category": "Commercial"},

    {"brand": "Volvo", "model": "9400 Bus", "category": "Commercial"},
    {"brand": "Volvo", "model": "9700 Bus", "category": "Commercial"},
    {"brand": "Volvo", "model": "FMX Trucks", "category": "Commercial"},
    {"brand": "Volvo", "model": "XC40", "category": "Premium"},
    {"brand": "Volvo", "model": "XC60", "category": "Premium"},
    {"brand": "Volvo", "model": "XC90", "category": "Premium"},

    {"brand": "Skoda", "model": "Slavia (top variants)", "category": "Premium"},
    {"brand": "Skoda", "model": "Kushaq (top variants)", "category": "Premium"},
    {"brand": "Skoda", "model": "Octavia", "category": "Premium"},
    {"brand": "Skoda", "model": "Superb", "category": "Premium"},
    {"brand": "Skoda", "model": "Kodiaq", "category": "Premium"},
    {"brand": "Skoda", "model": "Fabia (legacy)", "category": "Light"},

    {
      "brand": "Volkswagen",
      "model": "Virtus (top variants)",
      "category": "Premium",
    },
    {
      "brand": "Volkswagen",
      "model": "Taigun (top variants)",
      "category": "Premium",
    },
    {"brand": "Volkswagen", "model": "Tiguan", "category": "Premium"},
    {"brand": "Volkswagen", "model": "Polo (legacy)", "category": "Light"},

    {"brand": "Lexus", "model": "ES", "category": "Premium"},
    {"brand": "Lexus", "model": "NX", "category": "Premium"},
    {"brand": "Lexus", "model": "RX", "category": "Premium"},

    {"brand": "Jaguar", "model": "XE", "category": "Premium"},
    {"brand": "Jaguar", "model": "XF", "category": "Premium"},
    {"brand": "Jaguar", "model": "F-Pace", "category": "Premium"},

    {"brand": "Land Rover", "model": "Discovery Sport", "category": "Premium"},
    {"brand": "Land Rover", "model": "Defender", "category": "Premium"},
    {
      "brand": "Land Rover",
      "model": "Range Rover Evoque",
      "category": "Premium",
    },
    {
      "brand": "Land Rover",
      "model": "Range Rover Sport",
      "category": "Premium",
    },

    {"brand": "MG", "model": "Astor (top variants)", "category": "Premium"},
    {"brand": "MG", "model": "ZS EV", "category": "Premium"},
    {"brand": "MG", "model": "Hector (top variants)", "category": "Premium"},
    {"brand": "MG", "model": "Gloster", "category": "Premium"},

    {"brand": "Jeep", "model": "Compass", "category": "Premium"},
    {"brand": "Jeep", "model": "Meridian", "category": "Premium"},
    {"brand": "Jeep", "model": "Wrangler", "category": "Premium"},

    {"brand": "BMW", "model": "3 Series", "category": "Premium"},
    {"brand": "BMW", "model": "5 Series", "category": "Premium"},
    {"brand": "BMW", "model": "7 Series", "category": "Premium"},
    {"brand": "BMW", "model": "X1", "category": "Premium"},
    {"brand": "BMW", "model": "X3", "category": "Premium"},
    {"brand": "BMW", "model": "X5", "category": "Premium"},

    {
      "brand": "Mercedes-Benz",
      "model": "A-Class Limousine",
      "category": "Premium",
    },
    {"brand": "Mercedes-Benz", "model": "C-Class", "category": "Premium"},
    {"brand": "Mercedes-Benz", "model": "E-Class", "category": "Premium"},
    {"brand": "Mercedes-Benz", "model": "GLA", "category": "Premium"},
    {"brand": "Mercedes-Benz", "model": "GLC", "category": "Premium"},
    {"brand": "Mercedes-Benz", "model": "GLE", "category": "Premium"},
    {"brand": "Mercedes-Benz", "model": "GLS", "category": "Premium"},

    {"brand": "Audi", "model": "A4", "category": "Premium"},
    {"brand": "Audi", "model": "A6", "category": "Premium"},
    {"brand": "Audi", "model": "Q3", "category": "Premium"},
    {"brand": "Audi", "model": "Q5", "category": "Premium"},

    {"brand": "Ford (legacy)", "model": "Figo", "category": "Light"},
    {"brand": "Ford (legacy)", "model": "Aspire", "category": "Light"},
    {"brand": "Ford (legacy)", "model": "Freestyle", "category": "Light"},
    {"brand": "Ford (legacy)", "model": "EcoSport", "category": "Light"},

    {"brand": "Renault", "model": "Kwid", "category": "Light"},
    {"brand": "Renault", "model": "Triber", "category": "Light"},
    {"brand": "Renault", "model": "Kiger", "category": "Light"},

    {"brand": "Nissan", "model": "Magnite", "category": "Light"},

    {"brand": "Citroën", "model": "C3", "category": "Light"},
    {"brand": "Citroën", "model": "eC3", "category": "Light"},

    {"brand": "BharatBenz", "model": "1217", "category": "Commercial"},
    {"brand": "BharatBenz", "model": "1617", "category": "Commercial"},
    {"brand": "BharatBenz", "model": "1923", "category": "Commercial"},
    {"brand": "BharatBenz", "model": "Buses", "category": "Commercial"},
  ];

  String? selectedBrand;
  String? selectedModel;
  String? selectedCategory;
  String? selectedCustomCategory;
  List<String> availableModels = [];
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  List<File?> images = List.generate(4, (_) => null);
  File? image;

  String? selectedFuelType;
  String? selectedTransmission;
  String? selectedAc;
  List<String> selectedFeatures = [];
  final vehicleRegex = RegExp(r'^[A-Z]{2}\s?\d{2}\s?[A-Z]{1,2}\s?\d{1,4}$');

  bool _isLoading = false;

  TextEditingController customModelController = TextEditingController();
  TextEditingController customCategoryController = TextEditingController();

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _pickImage(int index) async {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Center(
              child: CustomText(
                text: localizations.selectImageFrom,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                textcolor: KblackColor,
              ),
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      final pickedImage = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      if (pickedImage != null) {
                        setState(() {
                          images[index] = File(pickedImage.path);
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera, size: 18, color: korangeColor),
                        SizedBox(width: 8),
                        CustomText(
                          text: localizations.camera,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textcolor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      final pickedImage = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedImage != null) {
                        setState(() {
                          images[index] = File(pickedImage.path);
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_library,
                          size: 18,
                          color: korangeColor,
                        ),
                        SizedBox(width: 8),
                        CustomText(
                          text: localizations.gallery,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textcolor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Future<File?> pickImage(BuildContext context) async {
    File? image;
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {}

    return image;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "images/chevronLeft.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: localizations.addNewVehicle,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CustomText(
                  text: localizations.addOnceUseEveryTime,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textcolor: KblackColor,
                ),

                const SizedBox(height: 15),
                CustomText(
                  text: localizations.uploadVehicleImages,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textcolor: KblackColor,
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    2,
                    (index) => Padding(
                      padding: const EdgeInsets.only(left: 7, right: 12),
                      child: GestureDetector(
                        onTap: () => _pickImage(index),
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: const Radius.circular(10),
                            dashPattern: [5, 5],
                            color: kgreyColor,
                            strokeWidth: 2,
                            padding: const EdgeInsets.all(0),
                          ),
                          child: Container(
                            width: 140,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: KdeviderColor,
                            ),
                            child:
                                images[index] == null
                                    ? const Icon(Icons.add, color: kgreyColor)
                                    : Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.file(
                                            images[index]!,
                                            width: 140,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: -5,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                images.removeAt(index);
                                                images.add(null);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: korangeColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(3),
                                              child: const Icon(
                                                Icons.delete,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                buildDropdownField(
                  label: localizations.vehicleBrand,
                  hint: localizations.selectBrand,
                  items:
                      (() {
                        final List<String> brands =
                            vehicleData
                                .map((e) => e['brand'] as String)
                                .toSet()
                                .toList()
                              ..sort(
                                (a, b) =>
                                    a.toLowerCase().compareTo(b.toLowerCase()),
                              );

                        if (!brands.contains("Others")) {
                          brands.add("Others");
                        }
                        return brands;
                      })(),
                  value: selectedBrand,
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value;
                      selectedModel = null;
                      selectedCategory = null;
                      if (value != "Others") {
                        availableModels =
                            vehicleData
                                .where((e) => e['brand'] == value)
                                .map((e) => e['model'] as String)
                                .toList();
                      } else {
                        availableModels = [];
                      }
                    });
                  },
                ),
                if (selectedBrand != null && selectedBrand != "Others") ...[
                  buildDropdownField(
                    label: localizations.vehicleModel,
                    hint: localizations.selectModel,
                    items: availableModels,
                    value: selectedModel,
                    onChanged: (value) {
                      setState(() {
                        selectedModel = value;

                        selectedCategory =
                            vehicleData
                                .firstWhere(
                                  (e) =>
                                      e['brand'] == selectedBrand &&
                                      e['model'] == selectedModel,
                                )['category']
                                .toString();
                      });
                    },
                  ),

                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedCategory ?? "",
                    ),

                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: korangeColor,
                    ),
                    decoration: InputDecoration(
                      labelText: localizations.vehicleCategory,
                      hintText: localizations.vehicleCategory,
                      hintStyle: TextStyle(
                        color: kseegreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      labelStyle: TextStyle(
                        color: kgreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kbordergreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kbordergreyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: kbordergreyColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],

                if (selectedBrand == "Others") ...[
                  TextFormField(
                    controller: customModelController,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: korangeColor,
                    ),
                    decoration: InputDecoration(
                      labelText: localizations.enterVehicleModel,
                      hintText: localizations.enterVehicleModel,
                      hintStyle: TextStyle(
                        color: kseegreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      labelStyle: TextStyle(
                        color: kgreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kbordergreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kbordergreyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: kbordergreyColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    icon: Icon(Icons.keyboard_arrow_down, color: KblackColor),
                    decoration: InputDecoration(
                      labelText: localizations.vehicleCategory,
                      labelStyle: TextStyle(
                        color: kgreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kbordergreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kbordergreyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: kbordergreyColor,
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: CustomText(
                      text: localizations.selectVehicleCategory,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textcolor: kseegreyColor,
                    ),
                    value: selectedCustomCategory,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedCustomCategory = value;
                      });
                    },
                    items:
                        ["Light", "Premium", "Commercial"]
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: CustomText(
                                  text: item,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textcolor: korangeColor,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 15),
                ],

                buildTextField(
                  localizations.enterVehicleNumber,
                  localizations.enterVehicleNumber,
                  vehicleNumberController,
                  textCapitalization: TextCapitalization.characters,
                ),

                buildDropdownFields(
                  localizations.fuelType,
                  localizations.selectFuelType,
                  [
                    localizations.petrol,
                    localizations.diesel,
                    localizations.electric,
                    localizations.cng,
                  ],
                  selectedFuelType,
                  (value) {
                    setState(() {
                      selectedFuelType = value;
                    });
                  },
                ),

                buildDropdownFields(
                  localizations.transmission,
                  localizations.selectTransmission,
                  [
                    localizations.manual,
                    localizations.automatic,
                    localizations.semiAutomatic,
                  ],
                  selectedTransmission,
                  (value) {
                    setState(() {
                      selectedTransmission = value;
                    });
                  },
                ),

                buildDropdownFields(
                  localizations.acAvailable,
                  localizations.isAcAvailable,
                  [localizations.yes, localizations.no],
                  selectedAc,
                  (value) {
                    setState(() {
                      selectedAc = value;
                    });
                  },
                ),

                const SizedBox(height: 35),
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: korangeColor,
                        disabledBackgroundColor: korangeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      ),
                      onPressed: _isLoading ? null : _addVehicle,

                      child:
                          _isLoading
                              ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                              : CustomText(
                                text: localizations.addVehicle,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textcolor: kwhiteColor,
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator(color: korangeColor)),
        ],
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hintText,
    TextEditingController vehicleNumberController, {
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        maxLines: maxLines,
        controller: vehicleNumberController,
        textCapitalization: textCapitalization,
        inputFormatters: [UpperCaseTextFormatter()],
        style: TextStyle(
          color: korangeColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: TextStyle(
            color: kseegreyColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: TextStyle(
            color: kgreyColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField({
    required String label,
    required String hint,
    required List<String> items,
    String? value,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        icon: Icon(Icons.keyboard_arrow_down, color: KblackColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: kgreyColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        hint: CustomText(
          text: hint,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textcolor: kseegreyColor,
        ),
        value: value,
        isExpanded: true,
        onChanged: onChanged,
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: CustomText(
                      text: item,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textcolor: korangeColor,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget buildDropdownFields(
    String label,
    String hint,
    List<String> items,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        icon: Icon(Icons.keyboard_arrow_down, color: KblackColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: kgreyColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbordergreyColor, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        hint: CustomText(
          text: hint,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textcolor: kseegreyColor,
        ),
        value: selectedValue,
        isExpanded: true,
        onChanged: onChanged,
        items:
            items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: CustomText(
                  text: item,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textcolor: korangeColor,
                ),
              );
            }).toList(),
      ),
    );
  }

  Future<void> _addVehicle() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      setState(() {
        _isLoading = true;
      });
      if (selectedBrand == null || selectedBrand!.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.selectBrand)));
        return;
      }

      if (selectedBrand == "Others") {
        if (customModelController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.enterVehicleModel)),
          );
          return;
        }

        if (selectedCustomCategory == null || selectedCustomCategory!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.selectVehicleCategory)),
          );
          return;
        }
      } else {
        if (selectedModel == null || selectedModel!.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(localizations.selectModel)));
          return;
        }

        if (selectedCategory == null || selectedCategory!.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(localizations.selectCategory)));
          return;
        }
      }

      if (vehicleNumberController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.enterVehicleNumber)),
        );
        return;
      }

      String vehicleNumber = vehicleNumberController.text.trim().toUpperCase();

      if (!vehicleRegex.hasMatch(vehicleNumber)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.validVehicleNumber)),
        );
        return;
      }

      if (selectedFuelType == null || selectedFuelType!.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.selectFuelType)));
        return;
      }

      if (selectedTransmission == null || selectedTransmission!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.selectTransmission)),
        );
        return;
      }

      int pickedImagesCount =
          images.where((img) => img != null).toList().length;
      if (pickedImagesCount < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.uploadAtLeastOneImage)),
        );
        return;
      }

      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          String fileName =
              "${SharedPrefServices.getUserId().toString()}_Vehicles/${DateTime.now().millisecondsSinceEpoch}_$i.jpg";

          final ref = FirebaseStorage.instance.ref().child(fileName);
          final uploadTask = ref.putFile(images[i]!);

          final snapshot = await uploadTask.whenComplete(() {});
          final downloadUrl = await snapshot.ref.getDownloadURL();

          imageUrls.add(downloadUrl);
        }
      }

      await FirebaseFirestore.instance.collection("vehicles").add({
        "userId": SharedPrefServices.getUserId().toString(),
        "brand": selectedBrand,
        "model":
            selectedBrand == "Others"
                ? customModelController.text.trim()
                : selectedModel,
        "category":
            selectedBrand == "Others"
                ? selectedCustomCategory
                : selectedCategory,
        "vehicleNumber": vehicleNumberController.text.trim(),
        "fuelType": selectedFuelType,
        "transmission": selectedTransmission,
        "images": imageUrls,
        "acAvailable": selectedAc,
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.vehicleAddedSuccess)),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
