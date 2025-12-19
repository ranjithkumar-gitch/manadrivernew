import 'package:firebase_storage/firebase_storage.dart';
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
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });
    _listenAndDeleteCompletedChats();
  }

  void _listenAndDeleteCompletedChats() {
    FirebaseFirestore.instance.collection('bookings').snapshots().listen((
      snapshot,
    ) async {
      print(" Received ${snapshot.docs.length} bookings from Firestore");

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final bookingId = doc.id;
        final status = data['status'] ?? '';
        final chatDeleted = data['chatDeleted'] ?? false;

        if (status == 'Completed' && chatDeleted == false) {
          await ChatCleanupService.deleteChatIfBookingCompleted(bookingId);
        } else if (status == 'Completed' && chatDeleted == true) {
          print("Booking $bookingId already cleaned up (chatDeleted = true)");
        } else {
          print("Booking $bookingId not completed yet — skipping cleanup.\n");
        }
      }
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
          borderRadius: BorderRadius.circular(30),
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
    String driverRating = "N/A";
    // String price = bookingData['fare'] ?? "";
    double price = double.parse(bookingData['fare']?.toString() ?? '0.00');

    String convertDate(String date) {
      List<String> parts = date.split("-");
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    }

    return FutureBuilder<DocumentSnapshot?>(
      future:
          vehicleId.isNotEmpty
              ? FirebaseFirestore.instance
                  .collection('vehicles')
                  .doc(vehicleId)
                  .get()
              : Future.value(null),
      builder: (context, vehicleSnapshot) {
        String vehicleName = "Vehicle not assigned";
        if (vehicleSnapshot.hasData &&
            vehicleSnapshot.data != null &&
            vehicleSnapshot.data!.exists) {
          final vehicleData =
              vehicleSnapshot.data!.data() as Map<String, dynamic>;
          vehicleName =
              "${vehicleData['brand'] ?? ''} ${vehicleData['model'] ?? ''}";
        }

        return FutureBuilder<DocumentSnapshot?>(
          future:
              driverDocId.isNotEmpty
                  ? FirebaseFirestore.instance
                      .collection('drivers')
                      .doc(driverDocId)
                      .get()
                  : Future.value(null),
          builder: (context, driverSnapshot) {
            String userName = "Driver not assigned";

            String profileUrl = "";
            if (driverSnapshot.hasData &&
                driverSnapshot.data != null &&
                driverSnapshot.data!.exists) {
              final driverData =
                  driverSnapshot.data!.data() as Map<String, dynamic>;
              userName =
                  "${driverData['firstName'] ?? ''} ${driverData['lastName'] ?? ''}"
                      .trim();
              profileUrl = driverData['profileUrl'] ?? "";

              driverRating = driverData['averageRating']?.toString() ?? "N/A";
              double avg = (driverData['averageRating'] ?? 0).toDouble();
              double finalRating = (avg * 2).round() / 2;
              driverRating = finalRating.toString();
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ConfirmDetails(
                          bookingData: bookingData,
                          fromHome: false,
                        ),
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
                                    profileUrl.isNotEmpty
                                        ? NetworkImage(profileUrl)
                                        : AssetImage('images/avathar1.jpeg')
                                            as ImageProvider,
                              ),
                              if (profileUrl.isNotEmpty)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 20,
                                    height: 20,
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
                                    driverRating == 0
                                        ? const SizedBox()
                                        : Row(
                                          children: List.generate(5, (index) {
                                            double rating =
                                                double.tryParse(
                                                  driverRating.toString(),
                                                ) ??
                                                0.0;

                                            if (index < rating.floor()) {
                                              return const Icon(
                                                Icons.star_rounded,
                                                color: Colors.orange,
                                                size: 15,
                                              );
                                            } else if (index ==
                                                    rating.floor() &&
                                                rating % 1 != 0) {
                                              return const Icon(
                                                Icons.star_half_rounded,
                                                color: Colors.orange,
                                                size: 15,
                                              );
                                            } else {
                                              return const Icon(
                                                Icons.star_border_rounded,
                                                color: Colors.orange,
                                                size: 15,
                                              );
                                            }
                                          }),
                                        ),

                                    const SizedBox(width: 4),

                                    CustomText(
                                      text: driverRating.toString(),
                                      textcolor: kseegreyColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
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
                              borderRadius: BorderRadius.circular(30),
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
                          Text(
                            convertDate(date),
                            style: TextStyle(color: kseegreyColor),
                          ),
                          const SizedBox(width: 12),
                          Container(height: 20, width: 1, color: kseegreyColor),
                          const SizedBox(width: 12),
                          Text(time, style: TextStyle(color: kseegreyColor)),
                          Spacer(),
                          CustomText(
                            text: "₹ ${price.toStringAsFixed(2)}/-",
                            textcolor: korangeColor,
                            fontSize: 15,
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
      // appBar: const CustomMainAppBar(),
      appBar: const CustomMainAppBar(title: "My Rides"),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Material(
              color: Colors.white,
              elevation: 0,
              child: TabBar(
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.only(left: 15),
                controller: _tabController,
                isScrollable: true,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                tabs: [
                  buildTab("All", 0),
                  buildTab("New", 1),
                  buildTab("Accepted", 2),
                  buildTab("Ongoing", 3),
                  buildTab("Completed", 4),
                  buildTab("Cancelled", 5),
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
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      data['bookingId'] = doc.id;
                      return data;
                    }).toList();

                List<Map<String, dynamic>> filteredBookings;
                if (selectedTabIndex == 1) {
                  filteredBookings =
                      allBookings.where((b) => b['status'] == 'New').toList();
                } else if (selectedTabIndex == 2) {
                  filteredBookings =
                      allBookings
                          .where((b) => b['status'] == 'Accepted')
                          .toList();
                } else if (selectedTabIndex == 3) {
                  filteredBookings =
                      allBookings
                          .where((b) => b['status'] == 'Ongoing')
                          .toList();
                } else if (selectedTabIndex == 4) {
                  filteredBookings =
                      allBookings
                          .where((b) => b['status'] == 'Completed')
                          .toList();
                } else if (selectedTabIndex == 5) {
                  filteredBookings =
                      allBookings
                          .where((b) => b['status'] == 'Cancelled')
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

class ChatCleanupService {
  static Future<void> deleteChatIfBookingCompleted(String bookingId) async {
    try {
      debugPrint("Checking booking status for $bookingId...");

      final bookingSnapshot =
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(bookingId)
              .get();

      if (!bookingSnapshot.exists) {
        debugPrint(" Booking not found for ID: $bookingId");
        return;
      }

      final bookingData = bookingSnapshot.data()!;
      final status = bookingData['status'] ?? '';

      if (status == 'Completed') {
        debugPrint("🧹 Deleting chats for booking $bookingId...");

        final messagesSnapshot =
            await FirebaseFirestore.instance
                .collection('privateChats')
                .doc(bookingId)
                .collection('messages')
                .get();

        int deletedMessages = 0;
        int deletedImages = 0;

        for (final doc in messagesSnapshot.docs) {
          final data = doc.data();
          final imageUrl = data['imageUrl'] ?? '';

          if (imageUrl.isNotEmpty) {
            try {
              final ref = FirebaseStorage.instance.refFromURL(imageUrl);
              await ref.delete();
              deletedImages++;
            } catch (e) {}
          }

          await doc.reference.delete();
          deletedMessages++;
        }

        await _deleteTypingStatusSubcollection(bookingId);

        await FirebaseFirestore.instance
            .collection('privateChats')
            .doc(bookingId)
            .delete();

        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .update({'chatDeleted': true});

        debugPrint("Entire chat document deleted successfully.");
      } else {
        debugPrint(" not completed. Skipping cleanup.");
      }
    } catch (e) {}
  }

  static Future<void> _deleteTypingStatusSubcollection(String bookingId) async {
    try {
      final typingSnapshot =
          await FirebaseFirestore.instance
              .collection('privateChats')
              .doc(bookingId)
              .collection('typingStatus')
              .get();

      for (final doc in typingSnapshot.docs) {
        await doc.reference.delete();
        debugPrint("Deleted typingStatus/${doc.id}");
      }
    } catch (e) {}
  }
}
