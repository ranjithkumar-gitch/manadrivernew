import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mana_driver/AppBar/appBar.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Vehicles/confirm_details.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class MyRidesScreen extends StatefulWidget {
  @override
  _MyRidesScreenState createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });
  }

  Widget buildTab(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Tab(
      child: Container(
        width: 134,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFF6B00) : Color(0xFFF3F4F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textcolor: isSelected ? Color(0xFFFFFFFF) : Color(0xFF9AA9BA),
          ),
        ),
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> bookingData) {
    String status = bookingData['status'] ?? "Upcoming";
    String date = bookingData['date'] ?? "";
    String time = bookingData['time'] ?? "";
    String vehicleId = bookingData['vehicleId'] ?? "";
    String driverDocId = bookingData['driverdocId'] ?? "";
    print(driverDocId);

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('vehicles')
              .doc(vehicleId)
              .get(),
      builder: (context, vehicleSnapshot) {
        String vehicleName = "Vehicle";
        if (vehicleSnapshot.hasData && vehicleSnapshot.data!.exists) {
          final vehicleData =
              vehicleSnapshot.data!.data() as Map<String, dynamic>;
          vehicleName =
              "${vehicleData['brand'] ?? ''} ${vehicleData['model'] ?? ''}";
        }

        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('drivers')
                  .doc(driverDocId)
                  .get(),
          builder: (context, driverSnapshot) {
            String userName = "Driver not assigned";
            String driverRating =
                bookingData['driverRating']?.toString() ?? "N/A";

            if (driverSnapshot.hasData && driverSnapshot.data!.exists) {
              final driverData =
                  driverSnapshot.data!.data() as Map<String, dynamic>;
              print("Driver Data: $driverData");

              userName =
                  "${driverData['firstName'] ?? ''} ${driverData['lastName'] ?? ''}"
                      .trim();
            }

            print(userName);

            String price = "₹ 0.00";

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ConfirmDetails(bookingData: bookingData),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: kwhiteColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: KcardborderColor, width: 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    driverSnapshot.hasData &&
                                            driverSnapshot.data!.exists &&
                                            (driverSnapshot.data!.data()
                                                    as Map<
                                                      String,
                                                      dynamic
                                                    >)['profileUrl'] !=
                                                null &&
                                            ((driverSnapshot.data!.data()
                                                        as Map<
                                                          String,
                                                          dynamic
                                                        >)['profileUrl']
                                                    as String)
                                                .isNotEmpty
                                        ? NetworkImage(
                                          (driverSnapshot.data!.data()
                                              as Map<
                                                String,
                                                dynamic
                                              >)['profileUrl'],
                                        )
                                        : AssetImage('images/user.png')
                                            as ImageProvider,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/verified.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: userName,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  textcolor: korangeColor,
                                ),
                                Row(
                                  children: [
                                    Image.asset('images/star.png'),
                                    SizedBox(width: 3),
                                    CustomText(
                                      text: driverRating,
                                      textcolor: kseegreyColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                CustomText(
                                  text: vehicleName,
                                  textcolor: kseegreyColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  status == "Completed"
                                      ? Color(0xFFB9FFD6)
                                      : Color(0xFFC9DFFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color:
                                    status == "Completed"
                                        ? Color(0xFF00D458)
                                        : Color(0xFF1D9BF0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: KdeviderColor),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset('images/calender.png'),
                          const SizedBox(width: 5),
                          Text(date, style: TextStyle(color: kseegreyColor)),
                          const SizedBox(width: 12),
                          Container(height: 20, width: 1, color: kseegreyColor),
                          const SizedBox(width: 12),
                          Text(time, style: TextStyle(color: kseegreyColor)),
                          Spacer(),
                          CustomText(
                            text: price,
                            textcolor: korangeColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
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

  final currentUserId = SharedPrefServices.getUserId().toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomMainAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Material(
              color: Colors.white,
              elevation: 0,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                tabs: [
                  buildTab("All", 0),
                  buildTab("New", 1),
                  buildTab("Accepted", 2),
                  buildTab("Completed", 3),
                ],
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('bookings')
                      .where('ownerId', isEqualTo: currentUserId)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final allBookings =
                    snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();

                List<Map<String, dynamic>> filteredBookings;
                if (selectedTabIndex == 1) {
                  filteredBookings =
                      allBookings.where((b) => b['status'] == 'New').toList();
                } else if (selectedTabIndex == 2) {
                  filteredBookings =
                      allBookings
                          .where(
                            (b) =>
                                b['status'] != 'Completed' &&
                                b['status'] != 'New',
                          )
                          .toList();
                } else if (selectedTabIndex == 3) {
                  filteredBookings =
                      allBookings
                          .where((b) => b['status'] == 'Completed')
                          .toList();
                } else {
                  filteredBookings = allBookings;
                }

                if (filteredBookings.isEmpty) {
                  return Center(child: Text("No rides available"));
                }

                return ListView.builder(
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    return buildCard(filteredBookings[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
