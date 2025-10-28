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
        centerTitle: false,
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

      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('transactions')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, txSnapshot) {
          if (txSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: korangeColor),
            );
          }

          if (!txSnapshot.hasData || txSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: CustomText(
                text: "No Transactions Found",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textcolor: KblackColor,
              ),
            );
          }

          final transactions = txSnapshot.data!.docs;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _filterUserTransactions(transactions),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: korangeColor),
                );
              }

              final userTransactions = snapshot.data ?? [];

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
                  final tx = userTransactions[index];
                  return _buildTransactionCard(tx);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _filterUserTransactions(
    List<QueryDocumentSnapshot> transactions,
  ) async {
    List<Map<String, dynamic>> filtered = [];

    for (var txDoc in transactions) {
      final tx = txDoc.data() as Map<String, dynamic>;
      final bookingDocId = tx['bookingDocId'] ?? '';
      if (bookingDocId.isEmpty) continue;

      final bookingSnap =
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(bookingDocId)
              .get();

      if (!bookingSnap.exists) continue;

      final bookingData = bookingSnap.data() as Map<String, dynamic>;
      final driverId = bookingData['driverId'] ?? '';
      final ownerId = bookingData['ownerId'] ?? '';

      if (currentUserId == driverId || currentUserId == ownerId) {
        filtered.add(tx);
      }
    }

    return filtered;
  }

  Widget _buildTransactionCard(Map<String, dynamic> tx) {
    final transactionId = tx['transactionId'] ?? '';
    final amount = tx['amount'] ?? 0.0;
    final status = tx['status'] ?? 'Pending';
    final paymentMethod = tx['paymentMethod'] ?? 'UPI';
    final timestamp =
        tx['timestamp'] != null
            ? (tx['timestamp'] as Timestamp).toDate()
            : DateTime.now();

    final dateString =
        "${timestamp.day} ${_monthName(timestamp.month)} ${timestamp.year}";
    final hour =
        timestamp.hour > 12
            ? timestamp.hour - 12
            : (timestamp.hour == 0 ? 12 : timestamp.hour);
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final ampm = timestamp.hour >= 12 ? 'PM' : 'AM';
    final timeString = "$hour:$minute $ampm";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: KcardborderColor, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      color: kwhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: timeString,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textcolor: kseegreyColor,
                ),
                CustomText(
                  text: dateString,
                  textcolor: kseegreyColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
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
                      text: "₹${amount.toStringAsFixed(2)}",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textcolor: korangeColor,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: paymentMethod,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textcolor: kseegreyColor,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: CustomText(
                    text:
                        status == "Success"
                            ? "Payment Completed"
                            : "Payment Failed",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textcolor: status == "Success" ? KgreenColor : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
