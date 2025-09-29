import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchCars();
    _startAutoScroll();

    _startOfferAutoScroll();
  }

  int activeIndex = 0;

  List<Map<String, dynamic>> carList = [];

  Future<void> _fetchCars() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("bookings")
              .where('status', isEqualTo: 'New')
              .get();

      List<Map<String, dynamic>> loadedCars = await Future.wait(
        snapshot.docs.map((doc) async {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;

          if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
            data['createdAt'] =
                (data['createdAt'] as Timestamp).toDate().toString();
          }

          if (data['vehicleId'] != null &&
              data['vehicleId'].toString().isNotEmpty) {
            DocumentSnapshot vehicleDoc =
                await FirebaseFirestore.instance
                    .collection("vehicles")
                    .doc(data['vehicleId'])
                    .get();

            if (vehicleDoc.exists) {
              data['vehicleDetails'] =
                  vehicleDoc.data() as Map<String, dynamic>;
            } else {
              data['vehicleDetails'] = {};
            }
          } else {
            data['vehicleDetails'] = {};
          }

          data['pickup'] = data['pickup'] ?? 'NA';
          data['drop'] = data['drop'] ?? 'NA';
          data['date'] = data['date'] ?? 'NA';
          data['time'] = data['time'] ?? 'NA';
          data['status'] = data['status'] ?? 'NA';
          data['tripMode'] = data['tripMode'] ?? 'NA';
          data['tripTime'] = data['tripTime'] ?? 'NA';

          return data;
        }),
      );

      setState(() {
        carList = loadedCars;
      });

      if (carList.isNotEmpty) {
        var first = carList.first;
        debugPrint("👉 First Booking:");
        debugPrint("Pickup: ${first['pickup']}");
        debugPrint("Drop: ${first['drop']}");
        debugPrint("Date: ${first['date']}");
        debugPrint("Time: ${first['time']}");
        debugPrint("Status: ${first['status']}");
        debugPrint("Trip Mode: ${first['tripMode']}");
        debugPrint("Trip Time: ${first['tripTime']}");
        debugPrint("Vehicle ID: ${first['vehicleId'] ?? 'NA'}");

        var vehicle = first['vehicleDetails'] ?? {};
        debugPrint("Vehicle Brand: ${vehicle['brand'] ?? 'NA'}");
        debugPrint("Vehicle Model: ${vehicle['model'] ?? 'NA'}");
        debugPrint("Vehicle Number: ${vehicle['vehicleNumber'] ?? 'NA'}");
        debugPrint("Fuel Type: ${vehicle['fuelType'] ?? 'NA'}");
        debugPrint("Transmission: ${vehicle['transmission'] ?? 'NA'}");
        debugPrint("Category: ${vehicle['category'] ?? 'NA'}");

        if (vehicle['images'] != null &&
            vehicle['images'] is List &&
            vehicle['images'].isNotEmpty) {
          debugPrint("Vehicle Image: ${vehicle['images'][0]}");
        } else {
          debugPrint("Vehicle Image: NA");
        }
      } else {
        debugPrint("No bookings found.");
      }
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
  bool isLoading = false;
  Future<void> _updateBookingStatus(String bookingId, String newStatus) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("bookings")
          .doc(bookingId)
          .update({'status': newStatus});

      setState(() {
        final index = carList.indexWhere((car) => car['id'] == bookingId);
        if (index != -1) carList[index]['status'] = newStatus;

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error updating status: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const D_SideMenu(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                                            child: Image.asset(
                                              "images/Menu_D.png",
                                            ),
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
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
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              alignment: Alignment.center,
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
                                BoxShadow(
                                  color: kbordergreyColor,
                                  blurRadius: 12,
                                ),
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
                                            text: "₹0.0",
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
                              text: "My Bookings",
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
                                "View All",
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
                        if (carList.isNotEmpty) ...[
                          SizedBox(
                            height: 160,
                            child: PageView.builder(
                              itemCount: carList.length,
                              controller: _pageController,
                              itemBuilder: (context, index) {
                                final car = carList[index];
                                // final isSelected = selectedCarIndex == index;

                                final vehicle = car['vehicleDetails'] ?? {};

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCarIndex = index;
                                    });
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      color:
                                                          Colors.grey.shade100,
                                                    ),
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        child:
                                                            (vehicle['images'] !=
                                                                        null &&
                                                                    vehicle['images']
                                                                        is List &&
                                                                    vehicle['images']
                                                                        .isNotEmpty)
                                                                ? Image.network(
                                                                  vehicle['images'][0] ??
                                                                      '',
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                  width: 130,
                                                                  errorBuilder:
                                                                      (
                                                                        context,
                                                                        error,
                                                                        stackTrace,
                                                                      ) => const Icon(
                                                                        Icons
                                                                            .car_crash,
                                                                      ),
                                                                )
                                                                : const Icon(
                                                                  Icons
                                                                      .directions_car,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        CustomText(
                                                          text:
                                                              '${vehicle['brand'] ?? 'NA'} ${vehicle['model'] ?? 'NA'}',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textcolor:
                                                              KblackColor,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Wrap(
                                                          spacing: 6,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Image.asset(
                                                                  'images/onTime.png',
                                                                  width: 14,
                                                                  height: 14,
                                                                  fit:
                                                                      BoxFit
                                                                          .contain,
                                                                ),
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                CustomText(
                                                                  text:
                                                                      car['time'] ??
                                                                      'NA',
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  textcolor:
                                                                      kseegreyColor,
                                                                ),
                                                                CustomText(
                                                                  text:
                                                                      '  . 45 Km',
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  textcolor:
                                                                      kseegreyColor,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        // vehicle number safe
                                                      ],
                                                    ),
                                                  ),
                                                  const Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              DottedLine(
                                                dashColor: kbordergreyColor,
                                                dashLength: 10,
                                                dashGapLength: 6,
                                              ),

                                              const SizedBox(height: 10),

                                              // Buttons row
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      style: OutlinedButton.styleFrom(
                                                        side: const BorderSide(
                                                          color:
                                                              KorangeColorNew,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _updateBookingStatus(
                                                          car['id'],
                                                          'Declined',
                                                        );
                                                      },
                                                      child: const CustomText(
                                                        text: "Decline",
                                                        textcolor:
                                                            KorangeColorNew,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                KbtngreenColor,
                                                          ),
                                                      onPressed: () {
                                                        _updateBookingStatus(
                                                          car['id'],
                                                          'Accepted',
                                                        );
                                                        // Handle accept action
                                                      },
                                                      child: const Text(
                                                        "Accept",
                                                        style: TextStyle(
                                                          color: kwhiteColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                        ] else ...[
                          Center(
                            child: Text(
                              "No bookings available",
                              style: TextStyle(fontSize: 16, color: kgreyColor),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
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
            if (isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: korangeColor),
                ),
              ),
          ],
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
                  width: 70,
                  height: 70,
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

            const SizedBox(height: 5),
            const Divider(), // Divider below content
            const SizedBox(height: 5),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: KorangeColorNew,
                      ), // green border
                    ),
                    onPressed: () {},
                    child: const CustomText(
                      text: "Decline",
                      textcolor: KorangeColorNew,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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



