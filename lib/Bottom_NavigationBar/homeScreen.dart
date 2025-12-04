import 'dart:async';
import 'dart:math' as math;
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/AppBar/notificationScreen.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';

import 'package:mana_driver/Location/location.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';

import 'package:mana_driver/Vehicles/my_vehicle.dart';

import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/Widgets/customoutlinedbutton.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDropLocation2Visible = false;
  PageController _pageController = PageController(viewportFraction: 1);
  // int _currentPage = 0;

  String pickupLat = "";
  String pickupLng = "";
  String dropLat = "";
  String dropLng = "";
  String drop2Lat = "";
  String drop2Lng = "";
  String distance = "";
  String time = "";

  Timer? _autoScrollTimer;

  PageController _offerPageController = PageController(viewportFraction: 1);
  int _offerCurrentPage = 0;
  Timer? _offerAutoScrollTimer;

  PageController _watchPageController = PageController(viewportFraction: 1);
  // int _watchCurrentPage = 0;
  Timer? _watchAutoScrollTimer;
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController drop2Controller = TextEditingController();
  @override
  void initState() {
    print("Home Scree user id ${SharedPrefServices.getUserId().toString()}");
    super.initState();
    _fetchCars();
    // _startAutoScroll();
    _startOfferAutoScroll();
  }

  Future<void> _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LocationSelectionScreen()),
    );

    if (result != null && result is Map) {
      setState(() {
        pickupController.text = result["current"] ?? "";
        dropController.text = result["drop"] ?? "";

        if (result.containsKey("drop2") &&
            result["drop2"].toString().isNotEmpty) {
          drop2Controller.text = result["drop2"];
          isDropLocation2Visible = true;
        } else {
          drop2Controller.clear();
          isDropLocation2Visible = false;
        }

        pickupLat = result["pickupLat"] ?? "";
        pickupLng = result["pickupLng"] ?? "";
        dropLat = result["dropLat"] ?? "";
        dropLng = result["dropLng"] ?? "";
        drop2Lat = result["drop2Lat"] ?? "";
        drop2Lng = result["drop2Lng"] ?? "";

        distance = result["distance"] ?? "";
        time = result["duration"] ?? "";

        print(
          "Pickup: ${pickupController.text} | Lat: $pickupLat | Lng: $pickupLng",
        );
        print(
          "DropLocation 1: ${dropController.text} | Lat: $dropLat | Lng: $dropLng",
        );
        if (isDropLocation2Visible) {
          print(
            "DropLocation 2: ${drop2Controller.text} | Lat: $drop2Lat | Lng: $drop2Lng",
          );
        }
        print("Distance: $distance");
        print(" Duration: $time");
      });
    }
  }

  List<Map<String, dynamic>> carList = [];
  Future<void> _fetchCars() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("vehicles")
              .where('userId', isEqualTo: SharedPrefServices.getUserId())
              .get();

      List<Map<String, dynamic>> loadedCars =
          snapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

      setState(() {
        carList = loadedCars;
      });
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    }
  }

  void _startOfferAutoScroll() {
    _offerAutoScrollTimer = Timer.periodic(Duration(seconds: 7), (timer) {
      if (_offerPageController.hasClients) {
        if (_offerCurrentPage < offerImages.length - 1) {
          _offerCurrentPage++;
        } else {
          _offerCurrentPage = 0;
        }

        _offerPageController.animateToPage(
          _offerCurrentPage,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // void _startAutoScroll() {
  //   _autoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
  //     if (_pageController.hasClients) {
  //       if (_currentPage < carList.length - 1) {
  //         _currentPage++;
  //       } else {
  //         _currentPage = 0;
  //       }

  //       _pageController.animateToPage(
  //         _currentPage,
  //         duration: Duration(milliseconds: 500),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    _watchPageController.dispose();
    _watchAutoScrollTimer?.cancel();
    _offerPageController.dispose();
    _offerAutoScrollTimer?.cancel();

    super.dispose();
  }

  int selectedCarIndex = -1;
  @override
  Widget build(BuildContext context) {
    final firstName = SharedPrefServices.getFirstName() ?? "";
    final lastName = SharedPrefServices.getLastName() ?? "";
    final userName =
        "$firstName $lastName".trim().isEmpty
            ? "Guest"
            : "$firstName $lastName".trim();
    final localizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: isDropLocation2Visible ? 350 : 300,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'images/map.png',
                      width: double.infinity,
                      height: 252,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 30,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: localizations.greeting,
                                textcolor: kseegreyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomText(
                                text: userName,
                                textcolor: korangeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotificationScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: KnotificationcircleColor,
                                  width: 1,
                                ),
                              ),
                              child: Image.asset(
                                'images/notification.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 160,
                      right: 12,
                      left: 12,
                      child: Container(
                        width: 350,
                        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: kbordergreyColor, blurRadius: 12),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'images/pickupIcon.png',
                                  width: 28,
                                  height: 28,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: localizations.pickupLocation,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        textcolor: kgreyColor,
                                      ),
                                      SizedBox(height: 1),
                                      TextField(
                                        controller: pickupController,
                                        enabled: true,
                                        textInputAction: TextInputAction.next,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: KblackColor,
                                        ),
                                        decoration: InputDecoration(
                                          hintText:
                                              localizations.enterPickupLocation,
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: KblackColor,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 0,
                                          ),
                                          isDense: true,
                                          border: InputBorder.none,
                                        ),
                                        onTap: _selectLocation,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),

                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: kbordergreyColor,
                                    thickness: 1.3,
                                  ),
                                ),
                                // SizedBox(width: 15),

                                // SizedBox(
                                //   height: 30,
                                //   width: 68,
                                //   child: ElevatedButton(
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor:
                                //           isDropLocation2Visible
                                //               ? Colors.red
                                //               : korangeColor,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(22),
                                //       ),
                                //       padding: EdgeInsets.symmetric(
                                //         horizontal: 10,
                                //         vertical: 5,
                                //       ),
                                //     ),
                                //     onPressed: () {
                                //       setState(() {
                                //         isDropLocation2Visible =
                                //             !isDropLocation2Visible;
                                //       });
                                //     },
                                //     child: CustomText(
                                //       text:
                                //           isDropLocation2Visible
                                //               ? 'Delete'
                                //               : 'Add',
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w400,
                                //       textcolor: kwhiteColor,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),

                            SizedBox(height: 3),

                            Row(
                              children: [
                                Image.asset(
                                  'images/dropIcon.png',
                                  width: 28,
                                  height: 28,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: localizations.dropLocation,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        textcolor: kgreyColor,
                                      ),
                                      SizedBox(height: 1),
                                      TextField(
                                        controller: dropController,
                                        enabled: true,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: KblackColor,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText:
                                              localizations.enterDropLocation,
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: KblackColor,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 0,
                                          ),
                                          isDense: true,
                                          border: InputBorder.none,
                                        ),
                                        onTap: _selectLocation,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            if (isDropLocation2Visible) ...[
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Image.asset(
                                    'images/dropIcon.png',
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: localizations.dropLocation2,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          textcolor: kgreyColor,
                                        ),
                                        SizedBox(height: 1),
                                        TextField(
                                          enabled: true,
                                          controller: drop2Controller,
                                          textInputAction: TextInputAction.done,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: KblackColor,
                                          ),
                                          decoration: InputDecoration(
                                            hintText:
                                                localizations
                                                    .enterDropLocation2,
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: KblackColor,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 0,
                                                ),
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                          onTap: () {
                                            print('Drop location 2 tapped');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                color: kwhiteColor,

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: localizations.myVehicles,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          textcolor: KblackColor,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MyVehicle()),
                            );
                          },
                          child: Text(
                            localizations.viewVehicles,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: korangeColor,
                              decoration: TextDecoration.underline,
                              decorationColor: korangeColor,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationThickness: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),

                    if (carList.isNotEmpty) ...[
                      SizedBox(
                        height: 130,
                        child: PageView.builder(
                          itemCount: carList.length,
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            final car = carList[index];
                            final isSelected = selectedCarIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCarIndex =
                                      selectedCarIndex == index ? -1 : index;
                                });
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? korangeColor
                                                : Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: Colors.grey.shade100,
                                            ),
                                            child: Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                child:
                                                    (car['images'] != null &&
                                                            car['images']
                                                                is List &&
                                                            car['images']
                                                                .isNotEmpty)
                                                        ? Image.network(
                                                          car['images'][0],
                                                          fit: BoxFit.cover,
                                                          width: 90,
                                                          height: 86,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) => const Icon(
                                                                Icons.car_crash,
                                                              ),
                                                        )
                                                        : const Icon(
                                                          Icons.directions_car,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text:
                                                      '${car['brand']} ${car['model']}',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  textcolor: KblackColor,
                                                ),
                                                const SizedBox(height: 5),
                                                Wrap(
                                                  spacing: 6,
                                                  children: [
                                                    _infoChip(
                                                      car['transmission'],
                                                    ),
                                                    _infoChip(car['fuelType']),
                                                    // _infoChip(car['category']),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                _infoChip(car['vehicleNumber']),
                                              ],
                                            ),
                                          ),
                                          // const Align(
                                          //   alignment: Alignment.center,
                                          //   child: Icon(
                                          //     Icons.arrow_forward_ios,
                                          //     size: 18,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  if (isSelected)
                                    Positioned(
                                      top: 0,
                                      right: 10,

                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: korangeColor,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          "Vehicle Selected",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: carList.length,
                        effect: WormEffect(
                          dotHeight: 6,
                          dotWidth: 30,
                          activeDotColor: korangeColor,
                          dotColor: Colors.grey.shade300,
                        ),
                      ),
                      SizedBox(height: 25),

                      SizedBox(
                        width: 220,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                (pickupController.text.isEmpty ||
                                        dropController.text.isEmpty ||
                                        selectedCarIndex == -1)
                                    ? Colors.grey
                                    : korangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          onPressed: () {
                            if (pickupController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please pick your pickup location",
                                  ),
                                ),
                              );
                              return;
                            }
                            if (dropController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please pick your drop location",
                                  ),
                                ),
                              );
                              return;
                            }
                            if (selectedCarIndex == -1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a vehicle"),
                                ),
                              );
                              return;
                            }

                            showBookingBottomSheet(context);
                          },
                          child: CustomText(
                            text: localizations.bookADriver,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            textcolor: kwhiteColor,
                          ),
                        ),
                      ),
                    ] else ...[
                      const Center(
                        child: CustomText(
                          text: "No vehicles found",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: Colors.black,
                        ),
                      ),
                    ],
                    SizedBox(height: 15),
                  ],
                ),
              ),

              SizedBox(height: 15),
              Divider(height: 4, color: KdeviderColor, thickness: 5),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                color: kwhiteColor,

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: localizations.menuOffers,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          textcolor: KblackColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 140,
                      child: PageView.builder(
                        controller: _offerPageController,
                        itemCount: offerImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                offerImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _offerPageController,
                        count: offerImages.length,
                        effect: WormEffect(
                          dotHeight: 6,
                          dotWidth: 40,
                          activeDotColor: korangeColor,
                          dotColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                color: kwhiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        localizations.home_prem + ' ✨',
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: KbottomnaviconColor,
                          letterSpacing: -1.0,
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: localizations.home_india,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          textcolor: KbottomnaviconColor,
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          'images/flag.png',
                          width: 21,
                          height: 17,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: KdeviderColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: CustomText(
        text: text,
        fontSize: 10,
        fontWeight: FontWeight.w300,
        textcolor: KblackColor,
      ),
    );
  }

  void showCityLimitsDialog(
    BuildContext context,
    int initialSelected,
    Function(int) onSelected,
  ) {
    int tempSelected = initialSelected;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: 400,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Select Hours",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  textcolor: KblackColor,
                ),

                SizedBox(height: 10),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          int hr = index + 1;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                tempSelected = hr;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      tempSelected == hr
                                          ? korangeColor
                                          : kseegreyColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "$hr hr",
                                style: TextStyle(
                                  fontWeight:
                                      tempSelected == hr
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      tempSelected == hr
                                          ? korangeColor
                                          : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomCancelButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                        height: 46,
                        width: 140,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          onSelected(tempSelected);
                          Navigator.pop(context);
                        },
                        text: 'Confirm',
                        height: 46,
                        width: 140,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _fmt(double v) {
    final f = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return f.format(v);
  }

  Map<String, dynamic> calculateFare(
    String distanceStr, {
    bool isRoundTrip = false,
    bool isHourlyTrip = false,
  }) {
    final cleaned = distanceStr.toLowerCase().replaceAll('km', '').trim();
    double dist = double.tryParse(cleaned) ?? 0.0;

    if (isHourlyTrip) {
      return {
        'distance': dist,
        'rate': 549,
        'total': 549.0,
        'breakup': [
          {'km': dist, 'rate': 549, 'amount': 549},
        ],
      };
    }
    if (isRoundTrip) {
      dist = dist * 2;
    }
    double rate = 0.0;

    if (isRoundTrip) {
      if (dist <= 100) {
        rate = 11.0;
      } else {
        rate = 10.0;
      }
    }

    if (!isRoundTrip) {
      if (dist <= 100) {
        rate = 12.0;
      } else if (dist <= 200) {
        rate = 11.0;
      } else {
        rate = 10.0;
      }
    }

    double total = dist * rate;

    return {
      'distance': dist,
      'rate': rate,
      'total': double.parse(total.toStringAsFixed(2)),
      'breakup': [
        {'km': dist, 'rate': rate, 'amount': total},
      ],
    };
  }

  void showBookingBottomSheet(BuildContext context) {
    String selectedTripMode = "One Way";
    String selectedTripTime = "Schedule";
    int selectedCityHours = 1;
    // final fareMap = calculateFare(distance);
    Map<String, dynamic> fareMap = calculateFare(
      distance,
      isRoundTrip: selectedTripMode == "Round Trip",
      isHourlyTrip: selectedTripMode == 'Hourly Trip',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        DateTime selectedDate = DateTime.now();
        TimeOfDay selectedTime = TimeOfDay.now();

        DateTime? arrivalDate;
        TimeOfDay? arrivalTime;

        bool isLoading = false;

        int calculateConvenienceFee(DateTime depart, DateTime arrival) {
          final d1 = DateTime(depart.year, depart.month, depart.day);
          final d2 = DateTime(arrival.year, arrival.month, arrival.day);

          int days = d2.difference(d1).inDays;

          if (days == 0) {
            return 200;
          } else {
            return days * 500;
          }
        }

        return StatefulBuilder(
          builder: (context, setState) {
            int convenienceFee = 0;

            if (selectedTripMode == "Round Trip" &&
                arrivalDate != null &&
                arrivalTime != null) {
              convenienceFee = calculateConvenienceFee(
                selectedDate,
                arrivalDate!,
              );
            }

            double finalRoundTripFare =
                (fareMap['total'] ?? 0.0) + convenienceFee;

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 550,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            CustomText(
                              text: "Select Trip mode",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: KblackColor,
                            ),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: tripOption(
                                    "One Way",
                                    selected: selectedTripMode == "One Way",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "One Way";
                                        fareMap = calculateFare(
                                          distance,
                                          isRoundTrip: false,
                                        );
                                      });

                                      print(
                                        "Selected Trip Mode: $selectedTripMode",
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: tripOption(
                                    "Round Trip",
                                    selected: selectedTripMode == "Round Trip",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "Round Trip";
                                        fareMap = calculateFare(
                                          distance,
                                          isRoundTrip: true,
                                        );
                                      });
                                      print(
                                        "Selected Trip Mode: $selectedTripMode",
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: tripOption(
                                    selectedTripMode == "Hourly Trip"
                                        ? "Hourly Trip (${selectedCityHours} hr)"
                                        : "Hourly Trip",
                                    selected: selectedTripMode == "Hourly Trip",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "Hourly Trip";
                                        selectedCityHours = 3;
                                      });
                                    },
                                  ),
                                ),

                                if (selectedTripMode == "Hourly Trip")
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        " Every 1 hr ₹ 129/- ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Divider(
                        color: kbordergreyColor,
                        thickness: 4,
                        height: 10,
                      ),

                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Choose Trip Time",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: KblackColor,
                            ),

                            SizedBox(height: 10),
                            tripOption(
                              "Now",
                              selected: selectedTripTime == "Now",
                              onTap: () {
                                setState(() {
                                  selectedTripTime = "Now";
                                  selectedDate = DateTime.now();
                                  selectedTime = TimeOfDay.now();

                                  if (selectedTripMode == "Round Trip") {
                                    arrivalDate = null;
                                    arrivalTime = null;
                                  }
                                });
                                print("Selected Trip Time: $selectedTripTime");
                              },
                            ),
                            tripOption(
                              "Schedule",
                              selected: selectedTripTime == "Schedule",
                              onTap: () {
                                setState(() {
                                  selectedTripTime = "Schedule";
                                });
                                print("Selected Trip Time: $selectedTripTime");
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kbordergreyColor,
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    selectedTripMode == "Round Trip"
                                        ? "Departure Date & Time"
                                        : "Select Date & Time",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textcolor: KblackColor,
                              ),

                              SizedBox(height: 10),

                              GestureDetector(
                                onTap:
                                    selectedTripTime == "Now"
                                        ? null
                                        : () async {
                                          final DateTime?
                                          picked = await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(
                                                  context,
                                                ).copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                        primary: korangeColor,
                                                        onPrimary: Colors.white,
                                                        onSurface:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                      ),
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                        style:
                                                            TextButton.styleFrom(
                                                              foregroundColor:
                                                                  korangeColor,
                                                            ),
                                                      ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          if (picked != null) {
                                            setState(
                                              () => selectedDate = picked,
                                            );
                                          }
                                        },
                                child: dateTimeRow(
                                  Icons.date_range,
                                  "Select Date",
                                  value:
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                ),
                              ),

                              Divider(color: kbordergreyColor),

                              GestureDetector(
                                onTap:
                                    selectedTripTime == "Now"
                                        ? null
                                        : () async {
                                          final TimeOfDay?
                                          picked = await showTimePicker(
                                            context: context,
                                            initialTime: selectedTime,
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(
                                                  context,
                                                ).copyWith(
                                                  timePickerTheme: TimePickerThemeData(
                                                    hourMinuteShape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                    dayPeriodShape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          side: BorderSide(
                                                            color: korangeColor,
                                                            width: 1,
                                                          ),
                                                        ),
                                                    dayPeriodColor:
                                                        korangeColor,
                                                    dayPeriodTextColor:
                                                        MaterialStateColor.resolveWith(
                                                          (states) {
                                                            if (states.contains(
                                                              MaterialState
                                                                  .selected,
                                                            )) {
                                                              return Colors
                                                                  .white;
                                                            }
                                                            return Colors.black;
                                                          },
                                                        ),
                                                    dialBackgroundColor:
                                                        Colors.grey[200],
                                                    dialHandColor: korangeColor,
                                                    hourMinuteTextColor:
                                                        MaterialStateColor.resolveWith(
                                                          (states) {
                                                            if (states.contains(
                                                              MaterialState
                                                                  .selected,
                                                            )) {
                                                              return Colors
                                                                  .white;
                                                            }
                                                            return Colors.black;
                                                          },
                                                        ),
                                                  ),
                                                  colorScheme:
                                                      ColorScheme.light(
                                                        primary: korangeColor,
                                                        onPrimary: Colors.white,
                                                        onSurface:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                      ),
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                        style:
                                                            TextButton.styleFrom(
                                                              foregroundColor:
                                                                  korangeColor,
                                                            ),
                                                      ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (picked != null) {
                                            setState(
                                              () => selectedTime = picked,
                                            );
                                          }
                                        },
                                child: dateTimeRow(
                                  Icons.timer,
                                  "Select Time",
                                  value: selectedTime.format(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (selectedTripMode == "Round Trip")
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kbordergreyColor,
                                width: 1.3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomText(
                                      text: "Arrival Date & Time",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      textcolor: KblackColor,
                                    ),
                                    SizedBox(width: 5),
                                    CustomText(
                                      text: "*",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      textcolor: KredColor,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),

                                GestureDetector(
                                  onTap:
                                      selectedTripTime == "Now"
                                          ? null
                                          : () async {
                                            final DateTime?
                                            picked = await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  arrivalDate ?? selectedDate,
                                              firstDate: selectedDate,
                                              lastDate: DateTime(2101),
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(
                                                    context,
                                                  ).copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                          primary: korangeColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Colors
                                                                  .grey
                                                                  .shade700,
                                                        ),
                                                    textButtonTheme:
                                                        TextButtonThemeData(
                                                          style:
                                                              TextButton.styleFrom(
                                                                foregroundColor:
                                                                    korangeColor,
                                                              ),
                                                        ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );

                                            if (picked != null) {
                                              setState(() {
                                                arrivalDate = picked;

                                                if (selectedTripMode ==
                                                    "Round Trip") {
                                                  convenienceFee =
                                                      calculateConvenienceFee(
                                                        selectedDate,
                                                        arrivalDate!,
                                                      );
                                                  finalRoundTripFare =
                                                      (fareMap['total'] ??
                                                          0.0) +
                                                      convenienceFee;
                                                }
                                              });
                                            }
                                          },
                                  child: dateTimeRow(
                                    Icons.date_range,
                                    "Arrival Date",
                                    value:
                                        arrivalDate == null
                                            ? "---"
                                            : "${arrivalDate!.toLocal()}".split(
                                              ' ',
                                            )[0],
                                  ),
                                ),

                                Divider(color: kbordergreyColor),

                                GestureDetector(
                                  onTap:
                                      selectedTripTime == "Now"
                                          ? null
                                          : () async {
                                            if (arrivalDate == null) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    title: Text(
                                                      "Arrival Date Required",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Please select the arrival date before choosing the arrival time.",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: korangeColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              return;
                                            }
                                            String formatTo12Hour(DateTime dt) {
                                              int hour =
                                                  dt.hour > 12
                                                      ? dt.hour - 12
                                                      : dt.hour == 0
                                                      ? 12
                                                      : dt.hour;
                                              String minute = dt.minute
                                                  .toString()
                                                  .padLeft(2, '0');
                                              String period =
                                                  dt.hour >= 12 ? "PM" : "AM";
                                              return "$hour:$minute $period";
                                            }

                                            final TimeOfDay?
                                            picked = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  arrivalTime ?? selectedTime,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(
                                                    context,
                                                  ).copyWith(
                                                    timePickerTheme:
                                                        TimePickerThemeData(
                                                          hourMinuteShape:
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                          dialBackgroundColor:
                                                              Colors.grey[200],
                                                          dialHandColor:
                                                              korangeColor,
                                                        ),
                                                    colorScheme:
                                                        ColorScheme.light(
                                                          primary: korangeColor,
                                                        ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );

                                            if (picked != null) {
                                              final departDT = DateTime(
                                                selectedDate.year,
                                                selectedDate.month,
                                                selectedDate.day,
                                                selectedTime.hour,
                                                selectedTime.minute,
                                              );

                                              final int etaMinutes =
                                                  int.tryParse(
                                                    time.replaceAll(
                                                      RegExp(r'[^0-9]'),
                                                      '',
                                                    ),
                                                  ) ??
                                                  0;

                                              final minArrivalDT = departDT.add(
                                                Duration(minutes: etaMinutes),
                                              );

                                              final arrivalDT = DateTime(
                                                arrivalDate!.year,
                                                arrivalDate!.month,
                                                arrivalDate!.day,
                                                picked.hour,
                                                picked.minute,
                                              );

                                              if (arrivalDT.isBefore(
                                                minArrivalDT,
                                              )) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      title: Text(
                                                        "Invalid Arrival Time",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      content: Text(
                                                        "Arrival time must be after ETA (${formatTo12Hour(minArrivalDT)}).",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                          child: Text(
                                                            "OK",
                                                            style: TextStyle(
                                                              color:
                                                                  korangeColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                return;
                                              }

                                              setState(() {
                                                arrivalTime = picked;

                                                if (selectedTripMode ==
                                                        "Round Trip" &&
                                                    arrivalDate != null) {
                                                  convenienceFee =
                                                      calculateConvenienceFee(
                                                        selectedDate,
                                                        arrivalDate!,
                                                      );
                                                  finalRoundTripFare =
                                                      (fareMap['total'] ??
                                                          0.0) +
                                                      convenienceFee;

                                                  print(
                                                    " Convenience Fee: $convenienceFee",
                                                  );
                                                  print(
                                                    " Total Fare (Included Convenience): $finalRoundTripFare",
                                                  );
                                                  print(
                                                    " Base Fare: ${fareMap['total']}",
                                                  );
                                                }
                                              });
                                            }
                                          },
                                  child: dateTimeRow(
                                    Icons.timer,
                                    "Arrival Time",
                                    value:
                                        arrivalTime == null
                                            ? "---"
                                            : arrivalTime!.format(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(height: 10),
                      Divider(
                        color: kbordergreyColor,
                        thickness: 4,
                        height: 10,
                      ),

                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Estimated fare",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      textcolor: kgreyColor,
                                    ),

                                    CustomText(
                                      text:
                                          selectedTripMode == "Round Trip"
                                              ? (arrivalDate != null &&
                                                      arrivalTime != null)
                                                  ? "₹${((fareMap['total'] ?? 0.0) + convenienceFee).toStringAsFixed(2)}"
                                                  : "₹0.00"
                                              : selectedTripMode == "One Way"
                                              ? "₹${(fareMap['total'] ?? 0.0).toStringAsFixed(2)}"
                                              : selectedTripMode ==
                                                  "Hourly Trip"
                                              ? "₹549.00"
                                              : "",

                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      textcolor: korangeColor,
                                    ),

                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showPaymentSheet(
                                              context,
                                              fareMap,
                                              selectedTripMode,
                                              finalRoundTripFare,
                                              convenienceFee.toDouble(),
                                              arrivalDate,
                                              arrivalTime,
                                            );
                                          },
                                          child: Text(
                                            'View Breakup',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: kgreyColor,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: kgreyColor,
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
                                              decorationThickness: 1.5,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: kgreyColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 203,
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
                                    onPressed: () async {
                                      if (pickupController.text.isEmpty ||
                                          dropController.text.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Please select pickup & drop location",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      if (selectedCarIndex == -1) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Please select a vehicle",
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (selectedTripMode == "Round Trip") {
                                        if (arrivalDate == null ||
                                            arrivalTime == null) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                title: Text(
                                                  "Arrival Details Required",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Please select both arrival date and arrival time to continue.",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: Text(
                                                      "OK",
                                                      style: TextStyle(
                                                        color: korangeColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          return;
                                        }
                                      }

                                      setState(() => isLoading = true);

                                      try {
                                        final selectedCarId =
                                            carList[selectedCarIndex]['id'];

                                        String arrivalDateStr = "";
                                        String arrivalTimeStr = "";

                                        if (selectedTripMode == "Round Trip") {
                                          arrivalDateStr =
                                              "${arrivalDate!.toLocal()}".split(
                                                ' ',
                                              )[0];
                                          arrivalTimeStr = arrivalTime!.format(
                                            context,
                                          );
                                        }

                                        double finalFare = 0.0;

                                        if (selectedTripMode == "Round Trip") {
                                          finalFare =
                                              finalRoundTripFare.toDouble();
                                        } else if (selectedTripMode ==
                                            "Hourly Trip") {
                                          finalFare = 549.0;
                                        } else {
                                          finalFare =
                                              (fareMap['total'] ?? 0.0)
                                                  .toDouble();
                                        }

                                        String convertMinutes(
                                          String durationText,
                                        ) {
                                          final cleaned = durationText
                                              .toLowerCase()
                                              .replaceAll(
                                                RegExp(r'[^0-9]'),
                                                '',
                                              );
                                          int minutes =
                                              int.tryParse(cleaned) ?? 0;

                                          if (minutes < 60)
                                            return "$minutes mins";

                                          int hrs = minutes ~/ 60;
                                          int mins = minutes % 60;

                                          if (mins == 0) {
                                            return "$hrs hr";
                                          } else {
                                            return "$hrs hr $mins mins";
                                          }
                                        }

                                        Map<String, dynamic> bookingData = {
                                          'ownerdocId':
                                              SharedPrefServices.getDocId()
                                                  .toString(),
                                          'ownerId':
                                              SharedPrefServices.getUserId()
                                                  .toString(),
                                          'driverId': '',
                                          'driverdocId': '',
                                          'driverName': '',
                                          "distance":
                                              selectedTripMode == "Round Trip"
                                                  ? "${(double.tryParse(distance.replaceAll('km', '').trim()) ?? 0.0) * 2} km"
                                                  : distance,

                                          "duration": convertMinutes(time),
                                          "ownerOTP": '',

                                          "pickup": pickupController.text,
                                          "drop": dropController.text,
                                          "drop2":
                                              isDropLocation2Visible
                                                  ? drop2Controller.text
                                                  : '',
                                          "pickupLat": pickupLat,
                                          "paymentStatus": "",
                                          "chatDeleted": false,
                                          "pickupLng": pickupLng,
                                          "dropLat": dropLat,
                                          "dropLng": dropLng,
                                          "drop2Lat": drop2Lat,
                                          "drop2Lng": drop2Lng,
                                          "vehicleId": selectedCarId,
                                          "tripMode": selectedTripMode,
                                          "tripTime": selectedTripTime,
                                          'fare': finalFare,
                                          "serviceFare":
                                              selectedTripMode == "Hourly Trip"
                                                  ? finalFare
                                                  : fareMap['total'],

                                          "date":
                                              "${selectedDate.toLocal()}".split(
                                                ' ',
                                              )[0],
                                          "time": selectedTime.format(context),
                                          "status": "New",
                                          "statusHistory": [
                                            {
                                              "status": "New",

                                              "dateTime": DateTime.now(),
                                            },
                                          ],

                                          if (selectedTripMode ==
                                              "Round Trip") ...{
                                            "arrivalDate": arrivalDateStr,
                                            "arrivalTime": arrivalTimeStr,
                                            "convenienceFee":
                                                convenienceFee.toDouble(),
                                          },
                                          "createdAt":
                                              FieldValue.serverTimestamp(),
                                          if (selectedTripMode == "Hourly Trip")
                                            "cityLimitHours": selectedCityHours,
                                        };

                                        print(
                                          "Booking Data to send: $bookingData",
                                        );

                                        await FirebaseFirestore.instance
                                            .collection('bookings')
                                            .add(bookingData);

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Requested a driver successfully",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        Navigator.pop(context);

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BottomNavigation(),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text("Failed: $e")),
                                        );
                                      } finally {
                                        setState(() => isLoading = false);
                                      }
                                    },

                                    child:
                                        isLoading
                                            ? SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                            : CustomText(
                                              text: "Continue",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              textcolor: kwhiteColor,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showPaymentSheet(
    BuildContext context,
    Map<String, dynamic> fareMap,
    String selectedTripMode,
    double? finalRoundTripFare,
    double convenienceFee,
    DateTime? arrivalDate,
    TimeOfDay? arrivalTime,
  ) {
    final List<Map<String, dynamic>> parts = List<Map<String, dynamic>>.from(
      fareMap['breakup'] ?? [],
    );

    // final bool isOneWay = selectedTripMode == "One Way";

    // final bool isHourly = selectedTripMode == "Hourly Trip";
    double servicePrice = 0.0;
    double convFee = 0.0;

    if (selectedTripMode == "Hourly Trip") {
      servicePrice = 549;
    } else if (selectedTripMode == "One Way") {
      servicePrice = (fareMap['total'] ?? 0.0).toDouble();
    } else if (selectedTripMode == "Round Trip") {
      if (arrivalDate != null && arrivalTime != null) {
        servicePrice = (fareMap['total'] ?? 0.0).toDouble();
        convFee = convenienceFee;
      }
    }

    final double totalPrice = servicePrice + convFee;

    String _rupee(double v) => "₹${v.toStringAsFixed(2)}";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          margin: EdgeInsets.all(10),
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              const CustomText(
                text: "Payment Breakup",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textcolor: KblackColor,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Trip Mode",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                  CustomText(
                    text: selectedTripMode,

                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Distance",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                  CustomText(
                    text:
                        selectedTripMode == "Round Trip"
                            ? "${(double.tryParse(distance.replaceAll('km', '').trim()) ?? 0.0) * 2} km"
                            : distance,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Service Price",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                  CustomText(
                    text: _rupee(servicePrice),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (selectedTripMode == "Round Trip" && convFee > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Convenience Fee",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textcolor: KblackColor,
                    ),
                    CustomText(
                      text: _rupee(convFee),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textcolor: KblackColor,
                    ),
                  ],
                ),

              const SizedBox(height: 15),

              const DottedLine(dashColor: kseegreyColor),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Total Price",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textcolor: korangeColor,
                  ),
                  CustomText(
                    text: _rupee(totalPrice),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textcolor: korangeColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              const DottedLine(dashColor: kseegreyColor),
              SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }
}

Widget tripOption(String label, {bool selected = false, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? korangeColor : kgreyColor,
          ),
          SizedBox(width: 10),
          CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textcolor: KblackColor,
          ),
        ],
      ),
    ),
  );
}

Widget dateTimeRow(IconData icon, String label, {String? value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: korangeColor),
            SizedBox(width: 10),
            CustomText(
              text: label,
              textcolor: KblackColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        Row(
          children: [
            CustomText(
              text: value ?? "",
              textcolor: KblackColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(width: 5),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ],
    ),
  );
}

Widget addressCard(String title, String address) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: kbordergreyColor, width: 1.3),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(Icons.radio_button_checked, color: korangeColor),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                textcolor: korangeColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 5),
              CustomText(
                text: address,
                textcolor: kgreyColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

final List<String> offerImages = [
  'images/offer.png',
  'images/offer.png',
  'images/offer.png',
];

List<CarModel> carList = [
  CarModel(
    imagePath: 'images/swift.png',
    name: 'Maruti Swift Dzire VXI',
    kmsDriven: '76,225 km',
    transmission: 'Manual',
    fuelType: 'Petrol',
    price: '₹7,957',
  ),
  CarModel(
    imagePath: 'images/mahindra.png',
    name: 'Mahindra MARAZZO M2 7STR',
    kmsDriven: '45,120 km',
    transmission: 'Automatic',
    fuelType: 'Diesel',
    price: '₹9,995',
  ),
  CarModel(
    imagePath: 'images/tata.png',
    name: 'Tata Nexon XZ+',
    kmsDriven: '60,000 km',
    transmission: 'Manual',
    fuelType: 'Petrol',
    price: '₹9,100',
  ),
];

class CarModel {
  final String imagePath;
  final String name;
  final String kmsDriven;
  final String transmission;
  final String fuelType;
  final String price;

  CarModel({
    required this.imagePath,
    required this.name,
    required this.kmsDriven,
    required this.transmission,
    required this.fuelType,
    required this.price,
  });
}

 // void showPaymentSheet(BuildContext context, Map<String, dynamic> fareMap) {
  //   final List<Map<String, dynamic>> parts = List<Map<String, dynamic>>.from(
  //     fareMap['breakup'] ?? [],
  //   );
  //   final double total = (fareMap['total'] ?? 0.0) as double;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (_) {
  //       return Container(
  //         margin: EdgeInsets.all(10),
  //         // adjust height if many breakup rows
  //         constraints: BoxConstraints(maxHeight: 420),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(height: 15),
  //             const CustomText(
  //               text: "Payment Breakup",
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //               textcolor: KblackColor,
  //             ),
  //             const SizedBox(height: 12),

  //             // breakup rows
  //             ...parts.map((p) {
  //               final label = p['label'] ?? '';
  //               final km = p['km'] ?? 0.0;
  //               final rate = p['rate'] ?? 0.0;
  //               final amt = p['amount'] ?? 0.0;
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 6.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           CustomText(
  //                             text: label,
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w500,
  //                             textcolor: KblackColor,
  //                           ),
  //                           SizedBox(height: 4),
  //                           Text(
  //                             "${km.toString()} km × ₹${rate.toStringAsFixed(2)} / km",
  //                             style: GoogleFonts.poppins(
  //                               fontSize: 12,
  //                               color: kgreyColor,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     CustomText(
  //                       text: _fmt(amt as double),
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                       textcolor: KblackColor,
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),

  //             const SizedBox(height: 12),
  //             const DottedLine(dashColor: kseegreyColor),
  //             const SizedBox(height: 8),

  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 CustomText(
  //                   text: "Total Price",
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w700,
  //                   textcolor: korangeColor,
  //                 ),
  //                 CustomText(
  //                   text: _fmt(total),
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w700,
  //                   textcolor: korangeColor,
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 8),
  //             const DottedLine(dashColor: kseegreyColor),
  //             SizedBox(height: 10),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

// void _startWatchAutoScroll() {
  //   _watchAutoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
  //     if (_watchPageController.hasClients) {
  //       if (_watchCurrentPage < watchLearnImages.length - 1) {
  //         _watchCurrentPage++;
  //       } else {
  //         _watchCurrentPage = 0;
  //       }

  //       _watchPageController.animateToPage(
  //         _watchCurrentPage,
  //         duration: Duration(milliseconds: 500),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }
// imp //ortant code for car list view in home screen
 // SizedBox(
                      //   height: 130,
                      //   child: PageView.builder(
                      //     itemCount: carList.length,
                      //     controller: _pageController,
                      //     itemBuilder: (context, index) {
                      //       final car = carList[index];
                      //       return Container(
                      //         margin: const EdgeInsets.only(right: 8),
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: korangeColor,
                      //             width: 1.2,
                      //           ),
                      //           borderRadius: BorderRadius.circular(16),
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8),
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Container(
                      //                 width: 90,
                      //                 height: 90,
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(16),
                      //                   color: Colors.grey.shade100,
                      //                 ),
                      //                 child: Center(
                      //                   child: ClipRRect(
                      //                     borderRadius: BorderRadius.circular(
                      //                       12,
                      //                     ),
                      //                     child:
                      //                         (car['images'] != null &&
                      //                                 car['images'] is List &&
                      //                                 car['images'].isNotEmpty)
                      //                             ? Image.network(
                      //                               car['images'][0],
                      //                               fit: BoxFit.cover,
                      //                               width: 130,
                      //                               errorBuilder:
                      //                                   (
                      //                                     context,
                      //                                     error,
                      //                                     stackTrace,
                      //                                   ) => const Icon(
                      //                                     Icons.car_crash,
                      //                                   ),
                      //                             )
                      //                             : const Icon(
                      //                               Icons.directions_car,
                      //                             ),
                      //                   ),
                      //                 ),
                      //               ),
                      //               const SizedBox(width: 10),
                      //               Expanded(
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     CustomText(
                      //                       text:
                      //                           '${car['brand']} ${car['model']}',
                      //                       fontSize: 14,
                      //                       fontWeight: FontWeight.w600,
                      //                       textcolor: KblackColor,
                      //                     ),
                      //                     const SizedBox(height: 5),
                      //                     Wrap(
                      //                       spacing: 6,
                      //                       children: [
                      //                         _infoChip(car['transmission']),
                      //                         _infoChip(car['fuelType']),
                      //                         _infoChip(car['category']),
                      //                       ],
                      //                     ),
                      //                     const SizedBox(height: 5),
                      //                     _infoChip(car['vehicleNumber']),
                      //                   ],
                      //                 ),
                      //               ),
                      //               GestureDetector(
                      //                 onTap: () {
                      //                   Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                       builder:
                      //                           (_) => VehicleDetailsScreen(
                      //                             data: car,
                      //                             docId: car['id'],
                      //                           ),
                      //                     ),
                      //                   );
                      //                 },
                      //                 child: const Align(
                      //                   alignment: Alignment.center,
                      //                   child: Icon(
                      //                     Icons.arrow_forward_ios,
                      //                     size: 18,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),


