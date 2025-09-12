import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Vehicles/my_vehicle.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:dotted_border/dotted_border.dart';

class EditVehicleDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  const EditVehicleDetails({
    super.key,
    required this.data,
    required this.docId,
  });

  @override
  State<EditVehicleDetails> createState() => _EditVehicleDetailsState();
}

class _EditVehicleDetailsState extends State<EditVehicleDetails> {
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

  @override
  void initState() {
    super.initState();

    selectedBrand = widget.data['brand']?.toString() ?? "";
    selectedModel = widget.data['model']?.toString() ?? "";
    selectedCategory = widget.data['category']?.toString() ?? "";
    vehicleNumberController.text =
        widget.data['vehicleNumber']?.toString() ?? "";
    selectedFuelType = widget.data['fuelType']?.toString() ?? "";
    selectedTransmission = widget.data['transmission']?.toString() ?? "";
    selectedAc = widget.data['acAvailable']?.toString() ?? "No"; // default "No"

    availableModels =
        vehicleData
            .where((e) => e['brand'] == selectedBrand)
            .map((e) => e['model']?.toString() ?? "")
            .toList();

    if (widget.data['images'] != null && widget.data['images'] is List) {
      List urls = widget.data['images'];
      for (int i = 0; i < urls.length && i < imageUrls.length; i++) {
        imageUrls[i] = urls[i]?.toString();
      }
    }
  }

  String? selectedBrand;
  String? selectedModel;
  String? selectedCategory;
  List<String> availableModels = [];
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  List<String?> imageUrls = List.filled(4, null); // existing DB images
  List<File?> images = List.filled(4, null); // new picked images
  List<String> imagesToDelete = []; // track images deleted from DB

  File? image;

  String? selectedFuelType;
  String? selectedTransmission;
  String? selectedAc;
  List<String> selectedFeatures = [];
  final vehicleRegex = RegExp(r'^[A-Z]{2}\s?\d{2}\s?[A-Z]{1,2}\s?\d{1,4}$');

  bool _isLoading = false;

  Future<void> _updateVehicle(String vehicleId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Validation checks
      if (selectedBrand == null || selectedBrand!.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please select a brand")));
        return;
      }

      if (selectedModel == null || selectedModel!.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please select a model")));
        return;
      }

      if (selectedCategory == null || selectedCategory!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a category")),
        );
        return;
      }

      if (vehicleNumberController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter vehicle number")),
        );
        return;
      }

      String vehicleNumber = vehicleNumberController.text.trim().toUpperCase();
      if (!vehicleRegex.hasMatch(vehicleNumber)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please enter valid vehicle number (e.g. TS05BY1234)",
            ),
          ),
        );
        return;
      }

      if (selectedFuelType == null || selectedFuelType!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select fuel type")),
        );
        return;
      }

      if (selectedTransmission == null || selectedTransmission!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select transmission")),
        );
        return;
      }

      int pickedImagesCount =
          images.where((img) => img != null).toList().length;
      if (pickedImagesCount + imageUrls.where((u) => u != null).length < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload at least 1 image")),
        );
        return;
      }
      List<String> updatedImageUrls = List.filled(maxImages, "");

      for (String url in imagesToDelete) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(url);
          await ref.delete();
          print("Deleted from Firebase Storage: $url");
        } catch (e) {
          print("Error deleting image from storage: $e");
        }
      }

      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          String fileName =
              "${SharedPrefServices.getUserId()}_Vehicles/${DateTime.now().millisecondsSinceEpoch}_$i.jpg";
          final ref = FirebaseStorage.instance.ref().child(fileName);
          final snapshot = await ref.putFile(images[i]!);
          final downloadUrl = await snapshot.ref.getDownloadURL();
          updatedImageUrls[i] = downloadUrl;
          print("Uploaded new image at index $i: $downloadUrl");
        } else if (imageUrls[i] != null && imageUrls[i]!.isNotEmpty) {
          updatedImageUrls[i] = imageUrls[i]!;
          print("Kept existing image at index $i: ${imageUrls[i]}");
        }
      }

      List<String> finalImageUrls =
          updatedImageUrls.where((url) => url.isNotEmpty).toList();

      print("Updating Vehicle with values:");
      print("Brand: $selectedBrand");
      print("Model: $selectedModel");
      print("Category: $selectedCategory");
      print("Vehicle Number: $vehicleNumber");
      print("Fuel Type: $selectedFuelType");
      print("Transmission: $selectedTransmission");
      print("Images: $updatedImageUrls");
      print("AC Available: $selectedAc");

      await FirebaseFirestore.instance
          .collection("vehicles")
          .doc(vehicleId)
          .update({
            "brand": selectedBrand ?? "",
            "model": selectedModel ?? "",
            "category": selectedCategory ?? "",
            "vehicleNumber": vehicleNumberController.text.trim(),
            "fuelType": selectedFuelType ?? "",
            "transmission": selectedTransmission ?? "",
            "images": finalImageUrls,
            "acAvailable": selectedAc ?? "No",
            "createdAt": FieldValue.serverTimestamp(),
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle updated successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyVehicle()),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack("Error: $e");
      print("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  int maxImages = 4;
  void _pickImage(int index) async {
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Center(
              child: CustomText(
                text: "Select Image From",
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
                          // Replace the image at this index
                          images[index] = File(pickedImage.path);

                          // If there was an existing DB image, mark it for deletion
                          if (imageUrls[index] != null) {
                            imagesToDelete.add(imageUrls[index]!);
                            imageUrls[index] = null;
                          }
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera, size: 18, color: korangeColor),
                        SizedBox(width: 8),
                        CustomText(
                          text: "Camera",
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
                          if (imageUrls[index] != null) {
                            imagesToDelete.add(imageUrls[index]!);
                            imageUrls[index] = null;
                          }
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
                          text: "Gallery",
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
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    "images/chevronLeft.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: "Edit Vehicle",
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
                Builder(
                  builder: (context) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // always 2 per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 70 / 60,
                          ),
                      itemCount: maxImages,
                      itemBuilder: (context, index) {
                        final File? imgFile = images[index];
                        final String? imgUrl = imageUrls[index];
                        final hasImage =
                            imgFile != null ||
                            (imgUrl != null && imgUrl.isNotEmpty);

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            hasImage
                                ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: KdeviderColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                        imgFile != null
                                            ? Image.file(
                                              imgFile,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.network(
                                              imgUrl!,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                )
                                : DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: const Radius.circular(10),
                                    dashPattern: [5, 5],
                                    color: kgreyColor,
                                    strokeWidth: 2,
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: KdeviderColor,
                                    ),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () => _pickImage(index),
                                        child: Icon(
                                          Icons.add,
                                          color: kgreyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                            if (hasImage)
                              Positioned(
                                top: 6,
                                left: 6,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (imgFile != null) {
                                        images[index] = null;
                                      } else if (imgUrl != null &&
                                          imgUrl.isNotEmpty) {
                                        imagesToDelete.add(imgUrl);
                                        print(
                                          "Image marked for deletion: $imgUrl",
                                        );
                                        imageUrls[index] = null;
                                      }
                                    });
                                  },

                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.delete,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                            if (imgUrl != null && imgUrl.isNotEmpty)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: () => _pickImage(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 25),
                buildDropdownField(
                  label: "Vehicle Brand",
                  hint: "Select Brand",
                  items:
                      vehicleData
                          .map((e) => e['brand'] as String)
                          .toSet()
                          .toList(),
                  value: selectedBrand,
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value;
                      selectedModel = null;
                      availableModels =
                          vehicleData
                              .where((e) => e['brand'] == value)
                              .map((e) => e['model'] as String)
                              .toList();
                    });
                  },
                ),

                buildDropdownField(
                  label: "Vehicle Model",
                  hint: "Select Model",
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
                    labelText: 'Vehicle Category',
                    hintText: 'Vehicle Category',
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
                buildTextField(
                  "Enter vehicle Number",
                  "Enter vehicle number",
                  vehicleNumberController,
                ),

                buildDropdownFields(
                  "Fuel Type",
                  "Select Fuel Type",
                  ["Petrol", "Diesel", "Electric", "CNG"],
                  selectedFuelType,
                  (value) {
                    setState(() {
                      selectedFuelType = value;
                    });
                  },
                ),

                buildDropdownFields(
                  "Transmission",
                  "Select Transmission",
                  ["Manual", "Automatic", "Semi-Automatic"],
                  selectedTransmission,
                  (value) {
                    setState(() {
                      selectedTransmission = value;
                    });
                  },
                ),

                buildDropdownFields(
                  "AC Available",
                  "Is AC Available?",
                  ["Yes", "No"],
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      ),
                      onPressed: () {
                        print(widget.docId);
                        print("Updating Vehicle with values:");
                        print("Brand: $selectedBrand");
                        print("Model: $selectedModel");
                        print("Category: $selectedCategory");
                        print(
                          "Vehicle Number: ${vehicleNumberController.text.trim()}",
                        );
                        print("Fuel Type: $selectedFuelType");
                        print("Transmission: $selectedTransmission");
                        print(
                          "Images: ${imageUrls.where((u) => u != null).cast<String>().toList()}",
                        );

                        print("AC Available: $selectedAc");
                        _updateVehicle(widget.docId);
                      },
                      child: CustomText(
                        text: "Update Vehicle Details",
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        maxLines: maxLines,
        controller: vehicleNumberController,
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
}
   // List<String> updatedImageUrls = [];

      // // 1️⃣ Delete marked images from DB (Firestore & optionally Storage)
      // // 1️⃣ Delete marked images from Storage
      // for (String url in imagesToDelete) {
      //   try {
      //     final ref = FirebaseStorage.instance.refFromURL(url);
      //     await ref.delete();
      //     print("Deleted from Firebase Storage: $url"); // ✅ successful delete
      //   } catch (e) {
      //     print("Error deleting image from storage: $e");
      //   }
      // }

      // // 2️⃣ Upload newly picked images
      // for (int i = 0; i < images.length; i++) {
      //   if (images[i] != null) {
      //     String fileName =
      //         "${SharedPrefServices.getUserId()}_Vehicles/${DateTime.now().millisecondsSinceEpoch}_$i.jpg";
      //     final ref = FirebaseStorage.instance.ref().child(fileName);
      //     final snapshot = await ref.putFile(images[i]!);
      //     final downloadUrl = await snapshot.ref.getDownloadURL();
      //     updatedImageUrls.add(downloadUrl);
      //     print("Uploaded new image: $downloadUrl"); // ✅ print uploaded image
      //   }
      // }

      // // 3️⃣ Add remaining existing images that weren’t deleted
      // for (var url in imageUrls) {
      //   if (url != null && url.isNotEmpty) {
      //     updatedImageUrls.add(url);
      //     print("Kept existing image: $url"); // ✅ print kept image
      //   }
      // }