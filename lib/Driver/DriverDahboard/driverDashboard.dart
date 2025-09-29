import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/AppBar/notificationScreen.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Driver/sidemenu/D_Sidemenu.dart';

import 'package:mana_driver/Location/location.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';

import 'package:mana_driver/Vehicles/my_vehicle.dart';

import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/Widgets/customoutlinedbutton.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  bool isOnline = true;
  bool isDropLocation2Visible = false;
  PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  PageController _offerPageController = PageController(viewportFraction: 1);
  int _offerCurrentPage = 0;
  Timer? _offerAutoScrollTimer;

  PageController _watchPageController = PageController(viewportFraction: 1);
  int _watchCurrentPage = 0;
  Timer? _watchAutoScrollTimer;
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController drop2Controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchCars();
    _startAutoScroll();
    // _startWatchAutoScroll();
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
    _offerAutoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_offerPageController.hasClients) {
        if (_offerCurrentPage < offerImages.length - 1) {
          _offerCurrentPage++;
        } else {
          _offerCurrentPage = 0;
        }

        _offerPageController.animateToPage(
          _offerCurrentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

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

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < carList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const D_SideMenu(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Container(color: korangeColor),
                    Container(
                      decoration: BoxDecoration(
                        color: korangeColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16), // adjust radius
                          bottomRight: Radius.circular(16), // adjust radius
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: Container(
                              //     padding: const EdgeInsets.all(10),
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       // color: Colors.white,
                              //       border: Border.all(
                              //         color: kwhiteColor,
                              //         width: 1,
                              //       ),
                              //     ),
                              //     child: Image.asset("images/Menu_D.png"),
                              //     // const Icon(
                              //     //   Icons.menu,
                              //     //   size: 24,
                              //     //   color: Colors.white,
                              //     // ),
                              //   ),
                              // ),
                              Builder(
                                builder:
                                    (context) => GestureDetector(
                                      onTap: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: Image.asset("images/Menu_D.png"),
                                      ),
                                    ),
                              ),

                              const Spacer(),

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isOnline = !isOnline;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 100,
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isOnline
                                            ? Colors.green.shade400
                                            : Colors.red.shade400,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Sliding circle
                                      AnimatedAlign(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                        alignment:
                                            isOnline
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: Container(
                                          width: 30,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          // child: Text(
                                          //   isOnline ? "" : "",
                                          //   style: TextStyle(
                                          //     color:
                                          //         isOnline
                                          //             ? Colors.green.shade600
                                          //             : Colors.red.shade600,
                                          //     fontWeight: FontWeight.bold,
                                          //   ),
                                          // ),
                                        ),
                                      ),

                                      // Background text
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          isOnline ? "Online" : "Offline",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Help Icon
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  border: Border.all(
                                    color: kwhiteColor,
                                    width: 1,
                                  ),
                                ),
                                child: Image.asset("images/contactUs.png"),
                                // child:
                                // const Icon(
                                //   Icons.headphones,
                                //   size: 24,
                                //   color: kwhiteColor,
                                // ),
                              ),
                              const SizedBox(width: 12),
                              // Notification Icon
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
                                    // color: Colors.white,
                                    border: Border.all(
                                      color: KnotificationcircleColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Image.asset(
                                    'images/notification_D.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Namaskaram + Guest
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              CustomText(
                                text: "Namaskaram",
                                textcolor: kseegreyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomText(
                                text: "Guest",
                                textcolor: kwhiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 190,
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: KgreyorangeColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'images/payments.png',
                                      width: 28,
                                      height: 28,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "My Earnings",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        textcolor: kgreyColor,
                                      ),
                                      SizedBox(height: 1),
                                      CustomText(
                                        text: "₹1500.0",
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        textcolor: korangeColor,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'images/backarrow.png',
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),

                            SizedBox(height: 3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                color: kwhiteColor,

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "My Vehicles",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          textcolor: KblackColor,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (_) => MyVehicle()),
                            // );
                          },
                          child: Text(
                            "view vehicles",
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
                    SizedBox(height: 20),

                    SizedBox(
                      height: 200, // increased height to fit buttons
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [_vehicleCard(), _vehicleCard()],
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),

              SizedBox(height: 20),
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
                        Text(
                          localizations.home_viewoffers,
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
                    // CustomText(
                    //   text: localizations.home_watch,
                    //   fontSize: 18,
                    //   fontWeight: FontWeight.bold,
                    //   textcolor: KblackColor,
                    // ),
                    // SizedBox(height: 15),
                    // Container(
                    //   height: 130,
                    //   child: PageView.builder(
                    //     controller: _watchPageController,
                    //     itemCount: watchLearnImages.length,
                    //     itemBuilder: (context, index) {
                    //       return Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 6),
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(12),
                    //           child: Image.asset(
                    //             watchLearnImages[index],
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // SizedBox(height: 12),
                    // Center(
                    //   child: SmoothPageIndicator(
                    //     controller: _watchPageController,
                    //     count: watchLearnImages.length,
                    //     effect: WormEffect(
                    //       dotHeight: 6,
                    //       dotWidth: 40,
                    //       activeDotColor: korangeColor,
                    //       dotColor: Colors.grey.shade300,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 40),
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

  void showBookingBottomSheet(BuildContext context) {
    String selectedTripMode = "Round Trip";
    String selectedTripTime = "Schedule";
    int selectedCityHours = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        DateTime selectedDate = DateTime.now();
        TimeOfDay selectedTime = TimeOfDay.now();
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
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
                                    "City Limits (${selectedCityHours} hr)",
                                    selected: selectedTripMode == "City Limits",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "City Limits";
                                      });
                                      showCityLimitsDialog(
                                        context,
                                        selectedCityHours,
                                        (value) {
                                          setState(() {
                                            selectedCityHours = value;
                                          });
                                        },
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
                                    "One way",
                                    selected: selectedTripMode == "One way",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "One way";
                                      });
                                      print(
                                        "Selected Trip Mode: $selectedTripMode",
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: tripOption(
                                    "Out Station",
                                    selected: selectedTripMode == "Out Station",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "Out Station";
                                      });
                                      print(
                                        "Selected Trip Mode: $selectedTripMode",
                                      );
                                    },
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
                            children: [
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
                                            final now = DateTime.now();
                                            final selectedDateTime = DateTime(
                                              selectedDate.year,
                                              selectedDate.month,
                                              selectedDate.day,
                                              picked.hour,
                                              picked.minute,
                                            );

                                            if (selectedDateTime.isBefore(
                                              now,
                                            )) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Please choose a valid future time.",
                                                  ),
                                                ),
                                              );
                                            } else {
                                              setState(
                                                () => selectedTime = picked,
                                              );
                                            }
                                          }
                                          // if (picked != null) {
                                          //   setState(
                                          //     () => selectedTime = picked,
                                          //   );
                                          // }
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
                                      text: "₹ 0.00",
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      textcolor: korangeColor,
                                    ),

                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showPaymentSheet(context);
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

                                      setState(() => isLoading = true);

                                      try {
                                        final selectedCarId =
                                            carList[selectedCarIndex]['id'];

                                        Map<String, dynamic> bookingData = {
                                          "pickup": pickupController.text,
                                          "drop": dropController.text,
                                          "vehicleId": selectedCarId,
                                          "tripMode": selectedTripMode,
                                          "tripTime": selectedTripTime,
                                          "date":
                                              "${selectedDate.toLocal()}".split(
                                                ' ',
                                              )[0],
                                          "time": selectedTime.format(context),
                                          "status": "New",
                                          "createdAt":
                                              FieldValue.serverTimestamp(),
                                          if (selectedTripMode == "City Limits")
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

  void showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          margin: EdgeInsets.all(10),
          height: 230,
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
                children: const [
                  CustomText(
                    text: "Service Price",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                  CustomText(
                    text: "₹1,799.00",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomText(
                    text: "Add-on’s",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                  CustomText(
                    text: "₹119.00",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomText(
                    text: "Fee & Taxes",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                  CustomText(
                    text: "₹100.00",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomText(
                    text: "Wallet Points",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                  CustomText(
                    text: "₹00.00",
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
                children: const [
                  CustomText(
                    text: "Total Price",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textcolor: korangeColor,
                  ),
                  CustomText(
                    text: "₹2,080.00",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textcolor: korangeColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              const DottedLine(dashColor: kseegreyColor),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _vehicleCard() {
    return Container(
      width: 320, // fixed width for each card
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        border: Border.all(color: kbordergreyColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car details row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade100,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://via.placeholder.com/150",
                        fit: BoxFit.cover,
                        width: 130,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.car_crash),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Toyota Corolla",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textcolor: KblackColor,
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 6,
                        children: [
                          _infoChip("Automatic"),
                          _infoChip("Petrol"),
                          _infoChip("Sedan"),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _infoChip("MH12AB1234"),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.arrow_forward_ios, size: 18),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(), // Divider below content
            const SizedBox(height: 8),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KredColor), // green border
                    ),
                    onPressed: () {
                      // Handle delete action
                    },
                    child: const CustomText(
                      text: "Delete",
                      textcolor: KredColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KbtngreenColor,
                    ),
                    onPressed: () {
                      // Handle accept action
                    },
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: kwhiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

// final List<String> watchLearnImages = [
//   'images/driver.png',
//   'images/driver.png',
//   'images/driver.png',
// ];

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



