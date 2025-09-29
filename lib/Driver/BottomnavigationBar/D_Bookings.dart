import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/Driver/D_Appbar/d_appbar.dart';
import 'package:mana_driver/Driver/sidemenu/D_Sidemenu.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class D_Bookings extends StatefulWidget {
  const D_Bookings({super.key});

  @override
  State<D_Bookings> createState() => _D_BookingsState();
}

class _D_BookingsState extends State<D_Bookings> {
  int selectedIndex = 0;
  final List<String> buttonLabels = [
    "Upcoming",
    "Accepted",
    "Ongoing",
    "Completed",
  ];
  List<Map<String, dynamic>> carList = [];

  Future<void> _updateBookingStatus(String bookingId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': newStatus});

      setState(() {
        final index = carList.indexWhere((car) => car['id'] == bookingId);
        if (index != -1) {
          carList[index]['status'] = newStatus;
        }
      });
    } catch (e) {
      debugPrint('Error updating booking status: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update status')));
    }
  }

  Future<void> _fetchCars() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("bookings").get();

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

      // print first booking + vehicle details safely
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

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  List<Map<String, dynamic>> get filteredCars {
    String status = '';
    switch (selectedIndex) {
      case 0:
        status = 'New'; // Upcoming
        break;
      case 1:
        status = 'Accepted';
        break;
      case 2:
        status = 'Ongoing';
        break;
      case 3:
        status = 'Completed';
        break;
    }
    return carList.where((car) => car['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const D_SideMenu(),
      appBar: DAppbar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(buttonLabels.length, (index) {
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child:
                          isSelected
                              ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: korangeColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed:
                                    () => setState(() => selectedIndex = index),
                                child: Text(
                                  buttonLabels[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                              : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: korangeColor),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed:
                                    () => setState(() => selectedIndex = index),
                                child: Text(
                                  buttonLabels[index],
                                  style: const TextStyle(color: korangeColor),
                                ),
                              ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your Bookings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: KblackColor,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    filteredCars.isEmpty
                        ? Center(
                          child: Text(
                            "No bookings available",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                        : ListView.separated(
                          itemCount: filteredCars.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final car = filteredCars[index];
                            final vehicle = car['vehicleDetails'] ?? {};

                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: Colors.grey.shade100,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child:
                                                  (vehicle['images'] != null &&
                                                          vehicle['images']
                                                              is List &&
                                                          vehicle['images']
                                                              .isNotEmpty)
                                                      ? Image.network(
                                                        vehicle['images'][0] ??
                                                            '',
                                                        fit: BoxFit.cover,
                                                        width: 130,
                                                        errorBuilder:
                                                            (
                                                              _,
                                                              __,
                                                              ___,
                                                            ) => const Icon(
                                                              Icons.car_crash,
                                                            ),
                                                      )
                                                      : const Icon(
                                                        Icons.directions_car,
                                                      ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text:
                                                      '${vehicle['brand'] ?? 'NA'} ${vehicle['model'] ?? 'NA'}',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  textcolor: KblackColor,
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'images/onTime.png',
                                                      width: 14,
                                                      height: 14,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    CustomText(
                                                      text: car['time'] ?? 'NA',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      textcolor: kseegreyColor,
                                                    ),
                                                    CustomText(
                                                      text:
                                                          '  . ${car['distance'] ?? '45'} Km',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      textcolor: kseegreyColor,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      DottedLine(
                                        dashColor: kbordergreyColor,
                                        dashLength: 10,
                                        dashGapLength: 6,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  color: KorangeColorNew,
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
                                                _updateBookingStatus(
                                                  car['id'],
                                                  'Accepted',
                                                );
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
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ chip widget
Widget _infoChip(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade200,
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 10, color: Colors.black54),
    ),
  );
}
