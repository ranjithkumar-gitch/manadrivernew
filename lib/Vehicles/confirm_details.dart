import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/Bottom_NavigationBar/Myrides.dart';
import 'package:mana_driver/Location/driverAssigned.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Sidemenu/cancellationPolicyScreen.dart';
import 'package:mana_driver/Vehicles/chat.dart';
import 'package:mana_driver/Vehicles/payment_gateway.dart';

import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmDetails extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const ConfirmDetails({super.key, required this.bookingData});

  @override
  State<ConfirmDetails> createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  late Map<String, dynamic> data;
  bool driverAssigned = false;
  Map<String, dynamic>? vehicleData;
  bool hasShownReviewCard = false;
  String status = "";
  Map<String, dynamic>? driverData;
  bool isLoading = false;
  late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    data = widget.bookingData;
    fetchVehicleData();
    fetchDriver();
    _listenAndDeleteCompletedChats();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _listenAndDeleteCompletedChats() {
    print("Listening for booking status changes...");

    FirebaseFirestore.instance.collection('bookings').snapshots().listen((
      snapshot,
    ) async {
      print(" Received ${snapshot.docs.length} bookings from Firestore");

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final bookingId = doc.id;
        final status = data['status'] ?? '';
        final chatDeleted = data['chatDeleted'] ?? false;

        print(
          " Booking ID: $bookingId | Status: $status | chatDeleted: $chatDeleted",
        );

        if (status == 'Completed' && chatDeleted == false) {
          await ChatCleanupService.deleteChatIfBookingCompleted(bookingId);
        } else if (status == 'Completed' && chatDeleted == true) {
        } else {}
      }
    });
  }

  void _openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_RZa3mGbco9w4Ms',
      'amount': (amount * 100).toInt(),
      'name': 'Rydyn',
      'description': 'Ride Payment',
      'prefill': {'contact': '9999999999', 'email': 'test@rydyn.com'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      debugPrint('Payment Successful: ${response.paymentId}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
      );

      double amount = double.tryParse(data['fare'].toString()) ?? 0.0;

      final transactionData = {
        'transactionId': response.paymentId,
        'bookingDocId': widget.bookingData['bookingId'] ?? 'Unknown',
        'amount': amount,
        'status': 'Success',
        'paymentMethod': 'Razorpay',
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('transactions')
          .add(transactionData);

      debugPrint("Transaction saved in Firestore: $transactionData");

      final bookingId = widget.bookingData['bookingId'];
      if (bookingId != null && bookingId.toString().isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .update({'paymentStatus': 'Success'});

        debugPrint(" Booking $bookingId paymentStatus updated to 'Success'");
      } else {
        debugPrint(" Booking ID missing — paymentStatus not updated");
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PaymentGateway()),
        );
      }
    } catch (e) {
      debugPrint("Error saving transaction: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving transaction details")),
      );

      final bookingId = widget.bookingData['bookingId'];
      if (bookingId != null && bookingId.toString().isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .update({'paymentStatus': 'Failure'});

        debugPrint(" Booking $bookingId paymentStatus updated to 'Failure'");
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint(' Failed: ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint(' External Wallet Selected: ${response.walletName}');
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void fetchVehicleData() async {
    String vehicleId = widget.bookingData['vehicleId'] ?? '';
    if (vehicleId.isNotEmpty) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('vehicles')
              .doc(vehicleId)
              .get();

      if (snapshot.exists) {
        setState(() {
          vehicleData = snapshot.data() as Map<String, dynamic>;
        });
      }
    }
  }

  Future<void> cancelRide(BuildContext context) async {
    final bookingDocId = widget.bookingData['ownerdocId'];

    if (bookingDocId == null || bookingDocId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking document ID not found')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Ride?'),
            content: const Text(
              'Are you sure you want to cancel this ride? This action cannot be undone.',
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: korangeColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(color: korangeColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: korangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingDocId)
          .update({
            'status': 'Cancelled',
            'cancelledAt': FieldValue.serverTimestamp(),
          });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride cancelled successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error cancelling ride: $e')));
    }
  }

  void fetchDriver() async {
    String driverId = widget.bookingData['driverdocId'] ?? '';
    print('Driver ID: $driverId');
    if (driverId.isNotEmpty) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('drivers')
              .doc(driverId)
              .get();

      if (snapshot.exists) {
        setState(() {
          driverData = snapshot.data() as Map<String, dynamic>;
        });
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingId = widget.bookingData['bookingId'] ?? '';
    final driverId = widget.bookingData['driverdocId'] ?? '';
    final ownerId = widget.bookingData['ownerId'] ?? '';
    final ownerName = SharedPrefServices.getFirstName() ?? 'Owner';
    final ownerProfile = SharedPrefServices.getProfileImage() ?? '';
    final data = widget.bookingData;
    final bookingStatus = data['status'] ?? 'New';
    final driverAssigned = driverData != null && driverData!.isNotEmpty;
    print('$bookingId,$driverData,$ownerId');
    // final appBarTitle =
    //     driverAssigned ? "Driver Assigned" : "Driver not assigned";
    final rideStatus = widget.bookingData['status'] ?? '';

    String appBarTitle = '';
    if (rideStatus == 'New') {
      appBarTitle = "Driver Not Assigned";
    } else if (rideStatus == 'Accepted') {
      appBarTitle = "Driver Assigned";
    } else if (rideStatus == 'Completed') {
      appBarTitle = "Ride Completed";
    } else {
      appBarTitle = "Ride $rideStatus";
    }

    String paymentStatus = data['paymentStatus'] ?? '';
    String bottomButtonText = '';
    VoidCallback? bottomButtonAction;

    if (rideStatus == 'New') {
      bottomButtonText = 'Cancel Ride';
      bottomButtonAction = () => cancelRide(context);
    } else if (rideStatus == 'Completed' && paymentStatus != 'Success') {
      bottomButtonText = 'Proceed to Payment';
      bottomButtonAction = () {
        _openCheckout(double.parse(data['fare']?.toString() ?? '0.00'));
      };
    } else if (rideStatus == 'Completed' && paymentStatus == 'Success') {
      bottomButtonText = 'Payment Completed';
      bottomButtonAction = null;
    } else {
      bottomButtonText = 'Ride $rideStatus';
      bottomButtonAction = null;
    }
    String driverFullName =
        (driverData != null
                ? "${driverData!['firstName'] ?? ''} ${driverData!['lastName'] ?? ''}"
                : 'Driver Name')
            .trim();
    String driverEmail =
        driverData != null ? "${driverData!['email'] ?? ''}" : 'Driver Email';

    String driverContact =
        driverData != null ? "${driverData!['phone'] ?? ''}" : 'Driver Phone';

    String vehicleName =
        vehicleData != null
            ? "${vehicleData!['brand'] ?? ''} ${vehicleData!['model'] ?? ''}"
            : 'Vehicle Name';
    String transmission =
        vehicleData != null
            ? "${vehicleData!['transmission'] ?? ''}"
            : 'Transmission';
    String category =
        vehicleData != null ? "${vehicleData!['category'] ?? ''}" : 'Category';
    String vehicleImage =
        vehicleData != null &&
                vehicleData!['images'] != null &&
                vehicleData!['images'].isNotEmpty
            ? vehicleData!['images'][0]
            : 'images/swift.png';
    String driverName = data['driverName'] ?? 'Driver not assigned';
    String driverPhone = data['driverPhone'] ?? '+91 XXXXX XXXXX';
    // String driverEmail = data['driverEmail'] ?? 'example@email.com';
    String pickupLocation = data['pickup'] ?? '';
    String tripMode = data['tripMode'] ?? '';
    String tripTime = data['tripTime'] ?? '';
    String distance = data['distance'] ?? '';
    String ownerOTP = data['ownerOTP'].toString();
    String citylimithours = data['cityLimitHours'].toString();
    String dropLocation = data['drop'] ?? '';
    String drop2Location = data['drop2'] ?? '';
    String date = data['date'] ?? 'DD/MM/YYYY';
    String arrivalDate = data['arrivalDate'] ?? 'DD/MM/YYYY';
    String arrivalTime = data['arrivalTime'] ?? 'DD/MM/YYYY';
    String time = data['time'] ?? 'HH:MM';
    String servicePrice = data['serviceFare']?.toString() ?? '0.00';
    String convenienceFee = data['convenienceFee']?.toString() ?? '0.00';
    String taxes = data['taxes']?.toString() ?? '0.00';
    String walletPoints = data['walletPoints']?.toString() ?? '0.00';
    String totalPrice = data['fare']?.toString() ?? '0.00';

    return Scaffold(
      backgroundColor: Colors.white,
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
                  text: appBarTitle,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                driverAssigned &&
                                        driverData!['profileUrl'] != null &&
                                        driverData!['profileUrl']
                                            .toString()
                                            .isNotEmpty
                                    ? NetworkImage(driverData!['profileUrl'])
                                    : const AssetImage('images/avathar1.jpeg')
                                        as ImageProvider,
                          ),

                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:
                                      driverAssigned
                                          ? "${driverData!['firstName'] ?? ''} ${driverData!['lastName'] ?? ''}"
                                              .trim()
                                          : "Driver not assigned",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  textcolor: korangeColor,
                                ),

                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                          if (driverAssigned && rideStatus != 'Completed') ...[
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 12),

                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ChatScreen(
                                              bookingId: bookingId,
                                              driverData: driverData,
                                              driverId: driverId,
                                              ownerId: ownerId,
                                              ownerName: ownerName,
                                              ownerProfile: ownerProfile,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Image.asset("images/chat.png"),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () async {
                                    final driverPhone =
                                        driverData?['phone'] ?? '';
                                    if (driverPhone.isNotEmpty) {
                                      final Uri callUri = Uri(
                                        scheme: 'tel',
                                        path: driverPhone,
                                      );
                                      if (await canLaunchUrl(callUri)) {
                                        await launchUrl(callUri);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Unable to open dialer.",
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Owner phone number not available.",
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  },
                                  child: Image.asset("images/call.png"),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Divider(thickness: 3, color: KlightgreyColor),

                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  vehicleImage.startsWith('http')
                                      ? Image.network(
                                        vehicleImage,
                                        fit: BoxFit.contain,
                                      )
                                      : Image.asset(
                                        vehicleImage,
                                        fit: BoxFit.contain,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: vehicleName,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textcolor: KblackColor,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    CustomText(
                                      text: transmission,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textcolor: kseegreyColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      height: 20,
                                      width: 1,
                                      color: kseegreyColor,
                                    ),
                                    SizedBox(width: 8),
                                    CustomText(
                                      text: category,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textcolor: kseegreyColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Image.asset("images/chevronRight.png"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Divider(thickness: 3, color: KlightgreyColor),

                    if (rideStatus == 'Completed') ...[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/review.png",
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    CustomText(
                                      text: "Write a review?",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      textcolor: korangeColor,
                                    ),
                                    CustomText(
                                      text: "How was your experience?",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textcolor: kseegreyColor,
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _showRatingDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: korangeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(46),
                                  ),
                                ),
                                child: const CustomText(
                                  text: "Give a rate",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textcolor: kwhiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else if (rideStatus == 'Accepted') ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Verification code to start the ride",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: korangeColor,
                            ),
                            const SizedBox(height: 10),

                            CustomText(
                              text:
                                  "Share this OTP with your driver to start the ride.",
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor.withOpacity(0.6),
                            ),

                            const SizedBox(height: 20),

                            Center(
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                  right: 20,
                                  left: 20,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 40,
                                ),
                                decoration: BoxDecoration(
                                  color: korangeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: korangeColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      text: "4-Digit OTP",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textcolor: KblackColor.withOpacity(0.7),
                                    ),
                                    const SizedBox(height: 6),
                                    CustomText(
                                      text: ownerOTP,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      textcolor: korangeColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(thickness: 3, color: KlightgreyColor),
                    ],

                    // const SizedBox(height: 6),
                    // const Divider(thickness: 3, color: KlightgreyColor),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Booking Details",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textcolor: korangeColor,
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildDot(Colors.green),
                                  const SizedBox(width: 8),
                                  const CustomText(
                                    text: "Pickup Location",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textcolor: kseegreyColor,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  top: 5,
                                  bottom: 10,
                                ),
                                child: CustomText(
                                  text: pickupLocation,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),

                              Row(
                                children: [
                                  _buildDot(
                                    drop2Location.isEmpty
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  CustomText(
                                    text:
                                        drop2Location.isEmpty
                                            ? "Drop Location"
                                            : "Drop Location 1",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textcolor: kseegreyColor,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  top: 5,
                                  bottom: 10,
                                ),
                                child: CustomText(
                                  text: dropLocation,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),

                              if (drop2Location.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        _buildDot(Colors.red),
                                        const SizedBox(width: 8),
                                        const CustomText(
                                          text: "Drop Location 2",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textcolor: kseegreyColor,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                        bottom: 10,
                                      ),
                                      child: CustomText(
                                        text: drop2Location,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        textcolor: KblackColor,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 3, color: KlightgreyColor),
                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Trip Details",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textcolor: korangeColor,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Image.asset(
                                "images/calender_drvr.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: tripMode,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Image.asset(
                                "images/time.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: tripTime,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                          if (tripMode == "Hourly Trip" &&
                              citylimithours.isNotEmpty) ...[
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Image.asset(
                                  "images/time.png",
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                CustomText(
                                  text: 'Hourly Trip : $citylimithours Hours',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(thickness: 3, color: KlightgreyColor),

                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Slot Details",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textcolor: korangeColor,
                          ),
                          const SizedBox(height: 10),
                          if (tripMode == "Round Trip")
                            CustomText(
                              text: "Depature",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              textcolor: Colors.grey.shade700,
                            ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                "images/calender_drvr.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: date,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Image.asset(
                                "images/time.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: time,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                          if (tripMode == "Round Trip") ...[
                            const SizedBox(height: 15),
                            CustomText(
                              text: "Arrival",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              textcolor: Colors.grey.shade700,
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Image.asset(
                                  "images/calender_drvr.png",
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                CustomText(
                                  text:
                                      arrivalDate != null
                                          ? "${arrivalDate}".split(' ')[0]
                                          : "---",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Image.asset(
                                  "images/time.png",
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                CustomText(
                                  text:
                                      arrivalTime != null ? arrivalTime : "---",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(thickness: 3, color: KlightgreyColor),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Contact Details",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textcolor: korangeColor,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Image.asset(
                                "images/person.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text:
                                    ((SharedPrefServices.getFirstName() ?? '') +
                                                " " +
                                                (SharedPrefServices.getLastName() ??
                                                    ''))
                                            .trim()
                                            .isNotEmpty
                                        ? ((SharedPrefServices.getFirstName() ??
                                                    '') +
                                                " " +
                                                (SharedPrefServices.getLastName() ??
                                                    ''))
                                            .trim()
                                        : driverName,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                "images/call_drvr.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text:
                                    SharedPrefServices.getNumber() ??
                                    driverPhone,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                "images/email_drvr.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text:
                                    SharedPrefServices.getEmail() ??
                                    driverEmail,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(thickness: 3, color: KlightgreyColor),
                    if (driverData != null && driverData!.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Driver Details",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: korangeColor,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Image.asset(
                                  "images/person.png",
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                CustomText(
                                  text:
                                      driverData != null
                                          ? "${driverData!['firstName'] ?? ''} ${driverData!['lastName'] ?? ''}"
                                          : driverName,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Image.asset(
                                  "images/call_drvr.png",
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                CustomText(
                                  text:
                                      driverData != null
                                          ? driverData!['phone'] ?? ''
                                          : '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Image.asset(
                                  "images/email_drvr.png",
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                CustomText(
                                  text:
                                      driverData != null
                                          ? driverData!['email'] ?? ''
                                          : '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(thickness: 3, color: KlightgreyColor),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Payment Summary",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textcolor: korangeColor,
                          ),
                          const SizedBox(height: 12),

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
                                text: "$distance",
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
                                text: "₹$servicePrice",
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
                                text: "Convenience Fee",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                              CustomText(
                                text: "₹$convenienceFee",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                          // const SizedBox(height: 8),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     const CustomText(
                          //       text: "Fee & Taxes",
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //       textcolor: KblackColor,
                          //     ),
                          //     CustomText(
                          //       text: "₹$taxes",
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //       textcolor: KblackColor,
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 8),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     const CustomText(
                          //       text: "Wallet Points",
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //       textcolor: KblackColor,
                          //     ),
                          //     CustomText(
                          //       text: "₹$walletPoints",
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //       textcolor: KblackColor,
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 10),
                          const DottedLine(dashColor: kseegreyColor),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: "Total Price",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                textcolor: korangeColor,
                              ),
                              CustomText(
                                text: "₹$totalPrice",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                textcolor: korangeColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const DottedLine(dashColor: kseegreyColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(thickness: 3, color: KlightgreyColor),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      imagePath: 'images/copoun_image.png',
                      text: 'Coupons & Offers',
                      onTap: () {},
                    ),
                    const SizedBox(height: 15),
                    _buildCard(
                      context,
                      imagePath: 'images/cancel_image.png',
                      text: 'Cancellation policy',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => const CancellationPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 130),
                  ],
                ),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 220,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: korangeColor,
            disabledBackgroundColor:
                rideStatus == 'Ongoing' ? Colors.green.shade500 : korangeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          onPressed: bottomButtonAction,
          // () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => PaymentGateway()),
          //   );
          // },
          child: CustomText(
            text: bottomButtonText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textcolor: kwhiteColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String imagePath,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Container(
          height: 54,
          padding: const EdgeInsets.only(right: 10, left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kbordergreyColor),
          ),
          child: Row(
            children: [
              Image.asset(imagePath, height: 20, width: 20),
              SizedBox(width: 12),
              Expanded(
                child: CustomText(
                  text: text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textcolor: KblackColor,
                ),
              ),
              Image.asset('images/chevronRight.png', height: 18, width: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  void _showRatingDialog(BuildContext context) {
    int selectedStars = 0;
    final TextEditingController commentController = TextEditingController();
    final List<FeedbackOption> feedbackOptions = [
      FeedbackOption(
        label: "Polite Driver",
        imagePath: "images/politeDriver.png",
      ),
      FeedbackOption(label: "Cleanliness", imagePath: "images/cleanlines.png"),
      FeedbackOption(label: "Smooth Driving", imagePath: "images/home.png"),
      FeedbackOption(label: "On Time", imagePath: "images/onTime.png"),
    ];

    final Set<String> selectedFeedback = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kwhiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "How was your trip with\nRamesh Kumar",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      textcolor: korangeColor,
                    ),
                    const SizedBox(height: 12),
                    const CustomText(
                      text: "Tap to rate your driver",
                      textcolor: KblackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < selectedStars
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.orange,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedStars = index + 1;
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 16),
                    const CustomText(
                      text: "Give Feedback",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textcolor: KblackColor,
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          feedbackOptions.map((option) {
                            final isSelected = selectedFeedback.contains(
                              option.label,
                            );
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedFeedback.remove(option.label);
                                  } else {
                                    selectedFeedback.add(option.label);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? korangeColor
                                            : kbordergreyColor,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      isSelected ? Colors.orange.shade50 : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      option.imagePath,
                                      height: 20,
                                      width: 20,
                                      color:
                                          isSelected
                                              ? korangeColor
                                              : kseegreyColor,
                                    ),
                                    const SizedBox(width: 6),
                                    CustomText(
                                      text: option.label,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textcolor:
                                          isSelected
                                              ? korangeColor
                                              : KblackColor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Leave a comment (optional)",
                        hintStyle: TextStyle(
                          color: kseegreyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: kbordergreyColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: kbordergreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: kbordergreyColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: CustomButton(
                        text: 'Submit',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 220,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// class FeedbackOption {
//   final String label;
//   final String imagePath;

//   FeedbackOption({required this.label, required this.imagePath});
// }
