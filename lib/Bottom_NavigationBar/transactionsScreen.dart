import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final userId = await SharedPrefServices.getUserId();
    setState(() {
      currentUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: korangeColor)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Row(
            children: [
              Image.asset("images/filter.png"),
              const SizedBox(width: 4),
              const CustomText(
                text: "Filter",
                fontSize: 14,
                textcolor: korangeColor,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          const SizedBox(width: 15),
        ],
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _transactionsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: korangeColor),
            );
          }

          final userTransactions = snapshot.data!;

          if (userTransactions.isEmpty) {
            return const Center(
              child: CustomText(
                text: "No Transactions Found",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textcolor: KblackColor,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: userTransactions.length,
            itemBuilder: (context, index) {
              return _buildTransactionCard(userTransactions[index]);
            },
          );
        },
      ),
    );
  }

  /// 🔥 PURE STREAM PIPELINE (NO FUTUREBUILDER)
  Stream<List<Map<String, dynamic>>> _transactionsStream() {
    return FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> filtered = [];

          for (var txDoc in snapshot.docs) {
            final tx = txDoc.data();
            final bookingDocId = tx['bookingDocId'] ?? '';

            if (bookingDocId.isEmpty) continue;

            final bookingSnap =
                await FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(bookingDocId)
                    .get();

            if (!bookingSnap.exists) continue;

            final bookingData = bookingSnap.data()!;
            final driverId = bookingData['driverId'] ?? '';
            final ownerId = bookingData['ownerId'] ?? '';
            final vehicleId = bookingData['vehicleId'] ?? '';
            final driverDocId = bookingData['driverdocId'] ?? '';

            /// --- DRIVER NAME ---
            String driverName = 'NA';
            if (driverDocId.isNotEmpty) {
              final driverSnap =
                  await FirebaseFirestore.instance
                      .collection('drivers')
                      .doc(driverDocId)
                      .get();
              if (driverSnap.exists) {
                final d = driverSnap.data()!;
                driverName = '${d['firstName']} ${d['lastName']}';
              }
            }

            /// --- VEHICLE NAME ---
            String vehicleName = 'NA';
            if (vehicleId.isNotEmpty) {
              final vehicleSnap =
                  await FirebaseFirestore.instance
                      .collection('vehicles')
                      .doc(vehicleId)
                      .get();
              if (vehicleSnap.exists) {
                final v = vehicleSnap.data()!;
                vehicleName = '${v['brand']} ${v['model']}';
              }
            }

            /// --- ONLY ADD IF MATCHES CURRENT USER ---
            if (currentUserId == driverId || currentUserId == ownerId) {
              tx['driverName'] = driverName;
              tx['vehicleName'] = vehicleName;
              filtered.add(tx);
            }
          }

          return filtered;
        });
  }

  /// --- UI CARD ---
  Widget _buildTransactionCard(Map<String, dynamic> tx) {
    final transactionId = tx['transactionId'] ?? '';
    final amount = tx['amount'] ?? 0.0;
    final status = tx['status'] ?? 'Pending';
    final paymentMethod = tx['paymentMethod'] ?? 'UPI';
    final timestamp =
        tx['timestamp'] != null
            ? (tx['timestamp'] as Timestamp).toDate()
            : DateTime.now();
    final driverName = tx['driverName'];
    final vehicleName = tx['vehicleName'];

    final dateString =
        "${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}";
    final hour =
        timestamp.hour > 12
            ? timestamp.hour - 12
            : (timestamp.hour == 0 ? 12 : timestamp.hour);
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final ampm = timestamp.hour >= 12 ? 'PM' : 'AM';
    final timeString = "$hour:$minute $ampm";

    return Card(
      color: kwhiteColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: KcardborderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
                    color: korangeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                CustomText(
                  text: "#$transactionId",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textcolor: KblackColor,
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('images/idcard.png'),
                        const SizedBox(width: 8),
                        CustomText(
                          text: driverName,
                          fontSize: 13,
                          textcolor: kseegreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset('images/car.png'),
                        const SizedBox(width: 8),
                        CustomText(
                          text: vehicleName,
                          fontSize: 13,
                          textcolor: kseegreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: timeString,
                      fontSize: 13,
                      textcolor: kseegreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 3),
                    CustomText(
                      text: dateString,
                      fontSize: 13,
                      textcolor: kseegreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const DottedLine(dashColor: kseegreyColor),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "₹${amount.toStringAsFixed(2)}/-",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textcolor: korangeColor,
                    ),
                    const SizedBox(height: 3),
                    CustomText(
                      text: paymentMethod,
                      fontSize: 12,
                      textcolor: kseegreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                CustomText(
                  text:
                      status == "Success"
                          ? "Payment Completed"
                          : "Payment Failed",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textcolor: status == "Success" ? KgreenColor : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
