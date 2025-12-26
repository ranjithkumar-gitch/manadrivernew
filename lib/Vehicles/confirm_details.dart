import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/Myrides.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Location/driverAssigned.dart';
import 'package:mana_driver/Login/otpscreen.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Sidemenu/cancellationPolicyScreen.dart';
import 'package:mana_driver/Vehicles/chat.dart';
import 'package:mana_driver/Vehicles/full_image_view.dart';
import 'package:mana_driver/Vehicles/payment_gateway.dart';
import 'package:intl/intl.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:mana_driver/service.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmDetails extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final bool fromHome;

  const ConfirmDetails({
    super.key,
    required this.bookingData,
    required this.fromHome,
  });

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
  String totalPrice = "0";
  final fcmService = FCMService();

  @override
  void initState() {
    super.initState();
    data = widget.bookingData;
    totalPrice = widget.bookingData['fare']?.toString() ?? "0";
    print('printing ${data['bookingId']},$driverData,${data['ownerId']}');
    fetchReviews();
    fetchVehicleData();
    // fetchDriver();
    // _listenAndDeleteCompletedChats();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  List<Map<String, dynamic>> reviewsList = [];

  void fetchReviews() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('reviews')
            .where('bookingId', isEqualTo: widget.bookingData['bookingId'])
            .get();

    setState(() {
      reviewsList =
          snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
    });

    print("Reviews fetched: ${reviewsList.length}");
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
    final lang = AppLocalizations.of(context)!;
    try {
      debugPrint('Payment Successful: ${response.paymentId}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${lang.paymentSuccessful} ${response.paymentId}"),
        ),
      );

      final bookingId = widget.bookingData['bookingId'];

      final liveSnap =
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(bookingId)
              .get();

      String rideStatus = liveSnap['status'] ?? "Unknown";
      debugPrint("LIVE STATUS at payment time = $rideStatus");

      double amount;
      bool isCancelPayment = false;

      if (rideStatus == "Completed") {
        amount = paidAmount;
        // amount = double.tryParse(widget.bookingData['fare'].toString()) ?? 0.0;
      } else {
        isCancelPayment = true;
        amount = 59.0;
      }

      final transactionData = {
        'transactionId': response.paymentId,
        'bookingDocId': bookingId,
        'amount': amount,
        'status': 'Success',
        'paymentMethod': 'Razorpay',
        'timestamp': FieldValue.serverTimestamp(),
        'type': isCancelPayment ? 'Cancel Payment' : 'Ride Payment',
      };

      await FirebaseFirestore.instance
          .collection('transactions')
          .add(transactionData);

      if (bookingId != null && bookingId.toString().isNotEmpty) {
        if (isCancelPayment) {
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(bookingId)
              .update({
                'paymentStatus': 'Success',
                'status': 'Cancelled',
                'statusHistory': FieldValue.arrayUnion([
                  {
                    "status": "Cancelled",
                    "dateTime": DateTime.now().toIso8601String(),
                  },
                ]),
              });
          final driverDoc =
              await FirebaseFirestore.instance
                  .collection('drivers')
                  .doc(widget.bookingData['driverdocId'])
                  .get();

          final driverToken = driverDoc['fcmToken'] ?? "";
          await fcmService.sendNotification(
            recipientFCMToken: driverToken,
            title: "Ride Cancelled",
            body: "Customer cancelled the ride.",
          );
        } else {
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(bookingId)
              .update({
                'paymentStatus': 'Success',
                'fare': ((double.tryParse(totalPrice) ?? 0) - appliedDiscount),
                'couponApplied': isCouponApplied,
                'appliedDiscount': appliedDiscount,
                'appliedCouponCode': appliedCouponCode ?? "",
              });
          final driverDoc =
              await FirebaseFirestore.instance
                  .collection('drivers')
                  .doc(widget.bookingData['driverId'])
                  .get();

          final driverToken = driverDoc['fcmToken'] ?? "";

          await fcmService.sendNotification(
            recipientFCMToken: driverToken,
            title: "💵 Payment Received",
            body: "You have received ₹$amount successfully.",
          );
        }
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PaymentGateway()),
        );
      }
    } catch (e) {
      debugPrint("Error saving transaction: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final lang = AppLocalizations.of(context)!;
    debugPrint(' Failed: ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${lang.paymentFailed} ${response.message}")),
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
    final bookingDocId = widget.bookingData['bookingId'];
    final lang = AppLocalizations.of(context)!;

    if (bookingDocId == null || bookingDocId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.bookingDocumentNotFound)));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Center(
              child: Text(
                lang.cancelRide,
                style: GoogleFonts.poppins(
                  color: korangeColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Text(
              lang.confirmCancelRide,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
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
                    child: Text(lang.no, style: TextStyle(color: korangeColor)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: korangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      lang.yes,
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(lang.rideCancelledSuccessfully)));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${lang.errorCancellingRide} $e')));
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

  double paidAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    final bookingId = widget.bookingData['bookingId'] ?? '';

    final ownerId = widget.bookingData['ownerId'] ?? '';
    final ownerName = SharedPrefServices.getFirstName() ?? 'Owner';
    final ownerProfile = SharedPrefServices.getProfileImage() ?? '';
    final data = widget.bookingData;
    final lang = AppLocalizations.of(context)!;

    print('$bookingId,$driverData,$ownerId');

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

    Future<void> _openMapWithCurrentLocation(
      String pickupLat,
      String pickupLng,
    ) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double currentLat = position.latitude;
        double currentLng = position.longitude;

        final Uri googleMapsUrl = Uri.parse(
          "https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$pickupLat,$pickupLng&travelmode=driving",
        );

        if (await canLaunchUrl(googleMapsUrl)) {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lang.couldNotOpenGoogleMaps),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        print("Error opening map: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.locationPermissionDenied),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    String _calculateETA(String time, String duration) {
      try {
        final pickupTime = DateFormat("h:mm a").parse(time);

        int totalMinutes = 0;

        if (duration.contains("hr")) {
          final hourMatch = RegExp(r'(\d+)\s*hr').firstMatch(duration);
          if (hourMatch != null) {
            totalMinutes += int.parse(hourMatch.group(1)!) * 60;
          }
        }

        if (duration.contains("min")) {
          final minMatch = RegExp(r'(\d+)\s*min').firstMatch(duration);
          if (minMatch != null) {
            totalMinutes += int.parse(minMatch.group(1)!);
          }
        }

        final eta = pickupTime.add(Duration(minutes: totalMinutes));

        final formattedETA = DateFormat("h:mm a").format(eta);

        if (eta.day > pickupTime.day) {
          return "$formattedETA";
        }

        return formattedETA;
      } catch (e) {
        print("ETA calculation error: $e");
        return "--";
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const BottomNavigation(initialIndex: 1),
          ),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey.shade300, height: 1),
          ),
          title: StreamBuilder<DocumentSnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(widget.bookingData['bookingId'])
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text(lang.loading);
              }

              final liveData = snapshot.data!;
              final rideStatus = liveData['status'] ?? "New";

              String appBarTitle = "";

              if (rideStatus == 'New') {
                appBarTitle = lang.driverNotAssigned;
              } else if (rideStatus == 'Accepted') {
                appBarTitle = lang.driverAssigned;
              } else if (rideStatus == 'Completed') {
                appBarTitle = lang.rideCompleted;
              } else {
                appBarTitle = "${lang.ride} $rideStatus";
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const BottomNavigation(initialIndex: 1),
                            ),
                            (route) => false,
                          );
                        },

                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            "images/chevronLeft.png",
                            width: 24,
                            height: 24,
                          ),
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
              );
            },
          ),
        ),

        body: StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(widget.bookingData['bookingId'])
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final liveData = snapshot.data!.data() as Map<String, dynamic>;
            final chatDeleted = liveData['chatDeleted'] ?? false;

            if ((status == 'Completed' || status == 'Cancelled') &&
                chatDeleted == false) {
              ChatCleanupService.deleteChatIfBookingCompleted(
                widget.bookingData['bookingId'],
              );
            }

            final liveDriverId = liveData['driverdocId']?.toString() ?? '';

            final rideStatus = liveData['status'] ?? 'New';

            final paymentStatus = liveData['paymentStatus'] ?? '';

            final ownerOTP = liveData['ownerOTP']?.toString() ?? '';

            DateTime createdAtTime =
                (liveData['createdAt'] as Timestamp).toDate();

            final DateTime now = DateTime.now();
            final int diffSeconds =
                300 - now.difference(createdAtTime).inSeconds;

            final bool isTimerOver = diffSeconds <= 0;

            final drop2Location = liveData['drop2'] ?? '';
            final pickupLocation = liveData['pickup'] ?? '';
            final dropLocation = liveData['drop'] ?? '';
            final pickupLat = liveData['pickupLat'].toString();
            final pickupLng = liveData['pickupLng'].toString();
            final dropLat = liveData['dropLat'].toString();
            final dropLng = liveData['dropLng'].toString();
            final drop2Lat = liveData['drop2Lat'].toString();
            final drop2Lng = liveData['drop2Lng'].toString();
            String tripMode = liveData['tripMode'] ?? '';
            String tripTime = liveData['tripTime'] ?? '';
            String distance = liveData['distance'] ?? '';
            String citylimithours = liveData['cityLimitHours'].toString();
            String date = liveData['date'] ?? 'DD/MM/YYYY';
            String arrivalDate = liveData['arrivalDate'] ?? 'DD/MM/YYYY';
            String arrivalTime = liveData['arrivalTime'] ?? 'DD/MM/YYYY';
            String time = liveData['time'] ?? 'HH:MM';
            String servicePrice = liveData['serviceFare']?.toString() ?? '0.00';
            String convenienceFee =
                liveData['convenienceFee']?.toString() ?? '0.00';
            String duration = liveData['duration'] ?? '';
            String totalPrice = liveData['fare']?.toString() ?? '0.00';
            String convertDate(String date) {
              List<String> parts = date.split("-");
              return "${parts[2]}-${parts[1]}-${parts[0]}";
            }

            final email = SharedPrefServices.getEmail()?.trim() ?? '';
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child:
                        liveDriverId.isEmpty
                            ? Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey,
                                  child: Image.asset(
                                    'images/avathar1.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12),
                                CustomText(
                                  text: lang.driverNotAssigned,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  textcolor: korangeColor,
                                ),
                              ],
                            )
                            : StreamBuilder<DocumentSnapshot>(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('drivers')
                                      .doc(liveDriverId)
                                      .snapshots(),
                              builder: (context, driverSnap) {
                                if (driverSnap.connectionState ==
                                    ConnectionState.waiting) {
                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey,
                                        child: Image.asset(
                                          'images/avathar1.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      CustomText(
                                        text: lang.loadingDriver,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        textcolor: kgreyColor,
                                      ),
                                    ],
                                  );
                                }

                                if (!driverSnap.hasData ||
                                    !driverSnap.data!.exists) {
                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        lang.driverNotAssigned,
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ],
                                  );
                                }

                                final d =
                                    driverSnap.data!.data()
                                        as Map<String, dynamic>;

                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap:
                                          (d['profileUrl'] != null &&
                                                  d['profileUrl']
                                                      .toString()
                                                      .isNotEmpty)
                                              ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) => FullImageView(
                                                          imagePath:
                                                              d['profileUrl'],
                                                          isAsset: false,
                                                        ),
                                                  ),
                                                );
                                              }
                                              : null,
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            (d['profileUrl'] != null &&
                                                    d['profileUrl']
                                                        .toString()
                                                        .isNotEmpty)
                                                ? NetworkImage(d['profileUrl'])
                                                : const AssetImage(
                                                      'images/avathar1.jpeg',
                                                    )
                                                    as ImageProvider,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text:
                                                "${d['firstName'] ?? ''} ${d['lastName'] ?? ''}"
                                                    .trim(),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            textcolor: korangeColor,
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                    if (rideStatus != 'Completed' &&
                                        rideStatus != 'Cancelled') ...[
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
                                                        driverData: d,
                                                        driverId: liveDriverId,
                                                        ownerId: ownerId,
                                                        ownerName: driverName,
                                                        ownerProfile:
                                                            ownerProfile,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              "images/chat.png",
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () async {
                                              final phone = d['phone'] ?? '';
                                              if (phone.isNotEmpty) {
                                                final Uri callUri = Uri(
                                                  scheme: 'tel',
                                                  path: phone,
                                                );
                                                if (await canLaunchUrl(
                                                  callUri,
                                                )) {
                                                  await launchUrl(callUri);
                                                }
                                              }
                                            },
                                            child: Image.asset(
                                              "images/call.png",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                  ),

                  const Divider(thickness: 3, color: KlightgreyColor),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                      left: 15,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kbordergreyColor, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: kbordergreyColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: kbordergreyColor,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  vehicleImage.startsWith('http')
                                      ? Image.network(
                                        vehicleImage,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.asset(
                                        vehicleImage,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 12),
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  if (rideStatus == 'Completed' &&
                      paymentStatus == 'Success' &&
                      reviewsList.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(10),
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
                                  children: [
                                    CustomText(
                                      text: lang.writeReview,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      textcolor: korangeColor,
                                    ),
                                    CustomText(
                                      text: lang.experienceQuestion,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textcolor: kseegreyColor,
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed:
                                    () => _showRatingDialog(context, data),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: korangeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(46),
                                  ),
                                ),
                                child: CustomText(
                                  text: lang.giveRating,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textcolor: kwhiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ] else if (rideStatus == 'Accepted') ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: lang.verificationCodeRide,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: korangeColor,
                            ),
                            const SizedBox(height: 10),

                            CustomText(
                              text: lang.shareOtpDriver,
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
                                      text: lang.fourDigitOtp,
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
                    ),
                    const SizedBox(height: 12),
                  ] else if (rideStatus == 'New') ...[
                    StreamBuilder<int>(
                      stream: Stream.periodic(
                        const Duration(seconds: 1),
                        (i) => i,
                      ),
                      builder: (context, snapshot) {
                        final createdAtTs = liveData['createdAt'];
                        if (createdAtTs == null) return const SizedBox();

                        final createdAt = (createdAtTs as Timestamp).toDate();
                        final now = DateTime.now();

                        final diffSeconds = now.difference(createdAt).inSeconds;
                        final isTimerOver = diffSeconds >= 300;

                        final remainingSeconds = (300 - diffSeconds).clamp(
                          0,
                          300,
                        );
                        final minutes = (remainingSeconds ~/ 60)
                            .toString()
                            .padLeft(2, '0');
                        final seconds = (remainingSeconds % 60)
                            .toString()
                            .padLeft(2, '0');

                        final progress = remainingSeconds / 300;

                        return Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (!isTimerOver)
                                        CircularProgressIndicator(
                                          value: remainingSeconds / 300,
                                          strokeWidth: 4,
                                          backgroundColor: Colors.grey.shade300,
                                          valueColor: AlwaysStoppedAnimation(
                                            korangeColor,
                                          ),
                                        )
                                      else
                                        Icon(
                                          Icons.warning_amber_outlined,
                                          color: korangeColor,
                                          size: 26,
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text:
                                            isTimerOver
                                                ? lang.noCaptainsAvailable
                                                : lang.rideRequestReceived,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        textcolor: korangeColor,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomText(
                                        text:
                                            isTimerOver
                                                ? lang.noCaptainsAccepted
                                                : lang.waitingForCaptains,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        textcolor: kseegreyColor,
                                      ),

                                      if (!isTimerOver) ...[
                                        SizedBox(height: 8),
                                        CustomText(
                                          text:
                                              "${lang.timeLeft} $minutes:$seconds",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          textcolor: korangeColor,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 0,
                      bottom: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: lang.routeInformation,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textcolor: korangeColor,
                          ),
                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildDot(Colors.green),
                                  const SizedBox(width: 10),
                                  CustomText(
                                    text: lang.pickupLocation,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    textcolor: Colors.green,
                                  ),

                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.access_time,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text: time,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    textcolor: Colors.grey,
                                  ),
                                ],
                              ),

                              GestureDetector(
                                onTap: () {
                                  _openMapWithCurrentLocation(
                                    pickupLat,
                                    pickupLng,
                                  );
                                },
                                child: const Icon(
                                  Icons.pin_drop,
                                  size: 22,
                                  color: KredColor,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 0,
                              bottom: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                CustomText(
                                  text: pickupLocation,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildDot(
                                    drop2Location.isEmpty
                                        ? KredColor
                                        : korangeColor,
                                  ),
                                  const SizedBox(width: 10),
                                  CustomText(
                                    text:
                                        drop2Location.isEmpty
                                            ? lang.dropLocation
                                            : lang.dropLocation1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    textcolor:
                                        drop2Location.isEmpty
                                            ? KredColor
                                            : korangeColor,
                                  ),

                                  if (drop2Location.isEmpty) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.access_time,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      text:
                                          "ETA: ${_calculateETA(time, duration)}",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      textcolor: Colors.grey,
                                    ),
                                  ],
                                ],
                              ),

                              GestureDetector(
                                onTap: () {
                                  _openMapWithCurrentLocation(dropLat, dropLng);
                                },
                                child: const Icon(
                                  Icons.pin_drop,
                                  size: 22,
                                  color: KredColor,
                                ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildDot(Colors.red),
                                        const SizedBox(width: 8),
                                        CustomText(
                                          text: lang.dropLocation2,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          textcolor: KredColor,
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.access_time,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        CustomText(
                                          text:
                                              "ETA: ${_calculateETA(time, duration)}",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          textcolor: Colors.grey,
                                        ),
                                      ],
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        _openMapWithCurrentLocation(
                                          drop2Lat,
                                          drop2Lng,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.pin_drop,
                                        size: 22,
                                        color: KredColor,
                                      ),
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

                          const SizedBox(height: 15),
                          DottedLine(
                            dashColor: kbordergreyColor,
                            dashLength: 7,
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  CustomText(
                                    text: lang.distance,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textcolor: kseegreyColor,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: distance,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textcolor: KblackColor,
                                  ),
                                ],
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              Column(
                                children: [
                                  CustomText(
                                    text: lang.duration,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textcolor: kseegreyColor,
                                  ),
                                  SizedBox(height: 4),
                                  CustomText(
                                    text: duration,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textcolor: KblackColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          DottedLine(
                            dashColor: kbordergreyColor,
                            dashLength: 7,
                          ),

                          const SizedBox(height: 15),

                          Center(
                            child: SizedBox(
                              width: 180,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: korangeColor,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),

                                onPressed: () async {
                                  String destinationLat =
                                      drop2Location.isNotEmpty
                                          ? drop2Lat
                                          : dropLat;
                                  String destinationLng =
                                      drop2Location.isNotEmpty
                                          ? drop2Lng
                                          : dropLng;

                                  try {
                                    LocationPermission permission =
                                        await Geolocator.checkPermission();
                                    if (permission ==
                                        LocationPermission.denied) {
                                      permission =
                                          await Geolocator.requestPermission();
                                    }

                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high,
                                        );

                                    double currentLat = position.latitude;
                                    double currentLng = position.longitude;

                                    final Uri googleMapsUrl = Uri.parse(
                                      "https://www.google.com/maps/dir/?api=1"
                                      "&origin=$currentLat,$currentLng"
                                      "&destination=$destinationLat,$destinationLng"
                                      "&travelmode=driving",
                                    );

                                    if (await canLaunchUrl(googleMapsUrl)) {
                                      await launchUrl(
                                        googleMapsUrl,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            lang.unableToOpenGoogleMaps,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print("Error getting directions: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${lang.errorOpeningDirections} ${e.toString()}",
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },

                                child: CustomText(
                                  text: lang.getDirections,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textcolor: kwhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: lang.tripDetails,
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
                              const SizedBox(height: 12),
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
                              if (tripMode == "City Limits" &&
                                  citylimithours.isNotEmpty) ...[
                                const SizedBox(height: 12),
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
                                          '${lang.cityLimit} $citylimithours ${lang.hours}',
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

                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: lang.slotDetails,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                textcolor: korangeColor,
                              ),
                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (tripMode == "Round Trip")
                                        CustomText(
                                          text: lang.departure,
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
                                            text: convertDate(date),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textcolor: KblackColor,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
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
                                    ],
                                  ),
                                  if (tripMode == "Round Trip")
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: lang.arrival,
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
                                              text: convertDate(arrivalDate),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              textcolor: KblackColor,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "images/time.png",
                                              height: 20,
                                              width: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            CustomText(
                                              text: arrivalTime,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              textcolor: KblackColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: lang.contactDetails,
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
                                        ((SharedPrefServices.getFirstName() ??
                                                        '') +
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
                              if (email.isNotEmpty)
                                Column(
                                  children: [
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
                                          text: email,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          textcolor: KblackColor,
                                        ),
                                      ],
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
                                        SharedPrefServices.getNumber()
                                            .toString(),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textcolor: KblackColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (liveData['driverdocId'] != null &&
                            liveData['driverdocId']
                                .toString()
                                .trim()
                                .isNotEmpty)
                          StreamBuilder<DocumentSnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('drivers')
                                    .doc(liveData['driverdocId'])
                                    .snapshots(),
                            builder: (context, driverSnap) {
                              if (driverSnap.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              }

                              if (!driverSnap.hasData ||
                                  !driverSnap.data!.exists) {
                                return const SizedBox();
                              }

                              final driver =
                                  driverSnap.data!.data()
                                      as Map<String, dynamic>;
                              final String driverEmail =
                                  driver['email']?.toString().trim() ?? '';

                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: lang.driverDetails,
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
                                              "${driver['firstName'] ?? ''} ${driver['lastName'] ?? ''}",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          textcolor: KblackColor,
                                        ),
                                      ],
                                    ),

                                    if (driverEmail.isNotEmpty) ...[
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
                                            text: driverEmail,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textcolor: KblackColor,
                                          ),
                                        ],
                                      ),
                                    ],

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
                                          text: driver['phone'] ?? '',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          textcolor: KblackColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: lang.paymentSummary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                textcolor: korangeColor,
                              ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: lang.servicePrice,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textcolor: KblackColor,
                                  ),
                                  CustomText(
                                    text:
                                        "₹${(double.tryParse(servicePrice) ?? 0).toStringAsFixed(2)}",

                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textcolor: KblackColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: lang.convenienceFee,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textcolor: KblackColor,
                                  ),
                                  CustomText(
                                    text:
                                        "₹${(double.tryParse(convenienceFee) ?? 0).toStringAsFixed(2)}",

                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textcolor: KblackColor,
                                  ),
                                ],
                              ),

                              if (isCouponApplied ||
                                  (data['couponApplied'] == true)) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: lang.couponApplied,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      textcolor: Colors.green,
                                    ),
                                    CustomText(
                                      text:
                                          "-₹${(isCouponApplied ? appliedDiscount : (data['appliedDiscount'] ?? 0)).toStringAsFixed(2)}",

                                      // "-₹${appliedDiscount.toStringAsFixed(2)}",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      textcolor: Colors.green,
                                    ),
                                  ],
                                ),
                              ],

                              const SizedBox(height: 10),
                              const DottedLine(dashColor: kseegreyColor),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: lang.totalPrice,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    textcolor: korangeColor,
                                  ),
                                  CustomText(
                                    text:
                                        "₹${((double.tryParse(totalPrice) ?? 0) - appliedDiscount).toStringAsFixed(2)}",
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

                        SizedBox(height: 10),
                        if (reviewsList.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child:
                                reviewsList.isEmpty
                                    ? CustomText(
                                      text: lang.noReviewAvailable,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textcolor: KblackColor,
                                    )
                                    : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: lang.yourReview,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          textcolor: korangeColor,
                                        ),
                                        const SizedBox(height: 12),

                                        Row(
                                          children: [
                                            CustomText(
                                              text: lang.rating,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              textcolor: KblackColor,
                                            ),
                                            SizedBox(width: 4),
                                            Row(
                                              children: List.generate(
                                                reviewsList[0]['rating'],
                                                (i) => const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            CustomText(
                                              text:
                                                  reviewsList[0]['rating']
                                                      .toString(),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              textcolor: KblackColor,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: lang.feedback,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              textcolor: KblackColor,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: CustomText(
                                                text:
                                                    (reviewsList[0]['feedback']
                                                            as List)
                                                        .join(", "),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                textcolor: KblackColor,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: lang.comment,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              textcolor: KblackColor,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: CustomText(
                                                text:
                                                    reviewsList[0]['comment'] ??
                                                    "",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                textcolor: KblackColor,
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

                  if (!(rideStatus == 'Completed' &&
                      paymentStatus == 'Success')) ...[
                    const SizedBox(height: 20),
                  ],
                  if (!(rideStatus == 'Completed' &&
                      paymentStatus == 'Success')) ...[
                    _buildCard(
                      context,
                      imagePath: 'images/copoun_image.png',
                      text: lang.couponsOffers,
                      onTap: () {
                        _showCouponsBottomSheet();
                      },
                    ),
                  ],
                  if (rideStatus == 'New' || rideStatus == 'Accepted') ...[
                    const SizedBox(height: 15),
                    _buildCard(
                      context,
                      imagePath: 'images/cancel_image.png',
                      text: lang.cancellationPolicy,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => const CancellationPolicyScreen(),
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 130),
                ],
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(widget.bookingData['bookingId'])
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final rideStatus = data['status'] ?? '';
            final paymentStatus = data['paymentStatus'] ?? '';
            final lang = AppLocalizations.of(context)!;

            String bottomButtonText = '';
            VoidCallback? bottomButtonAction;
            Color buttonColor = korangeColor;

            if (rideStatus == 'New' || rideStatus == 'Accepted') {
              buttonColor = Colors.red;
              bottomButtonText = lang.cancelRide;
              bottomButtonAction = () => _showCancelRideDialog(data);
            } else if (rideStatus == 'Ongoing') {
              buttonColor = Colors.green;
              bottomButtonText = lang.rideOngoing;
              bottomButtonAction = null;
            } else if (rideStatus == 'Completed' &&
                paymentStatus != 'Success') {
              buttonColor = Colors.orange;
              bottomButtonText = lang.proceedToPayment;
              bottomButtonAction = () {
                double latestTotal =
                    (double.tryParse(totalPrice) ?? 0) - appliedDiscount;
                paidAmount = latestTotal;
                _openCheckout((latestTotal));
              };
            } else if (rideStatus == 'Completed' &&
                paymentStatus == 'Success') {
              buttonColor = Colors.green;
              bottomButtonText = lang.paymentCompleted;
              bottomButtonAction = null;
            } else {
              bottomButtonText = '${lang.ride} $rideStatus';
              bottomButtonAction = null;
            }

            return SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  disabledBackgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                ),
                onPressed: bottomButtonAction,
                child: CustomText(
                  text: bottomButtonText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textcolor: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? appliedCouponCode;
  double appliedDiscount = 0.0;
  String appliedCouponValue = "";
  String finalTotal = "0.00";
  bool isCouponApplied = false;

  void applyCoupon(String code, String value) {
    setState(() {
      isCouponApplied = true;

      appliedCouponCode = code;
      appliedCouponValue = value;

      double total = double.tryParse(totalPrice) ?? 0;

      if (value.contains('%')) {
        double percent = double.parse(value.replaceAll('%', ''));
        appliedDiscount = (total * percent) / 100;
      } else {
        appliedDiscount = double.tryParse(value) ?? 0;
      }

      if (appliedDiscount > total) {
        appliedDiscount = total;
      }

      double result = total - appliedDiscount;
      finalTotal = result.toStringAsFixed(2);
    });
  }

  void _showCouponsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final lang = AppLocalizations.of(context)!;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: CustomText(
                    text: lang.couponsOffers,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textcolor: Colors.black,
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('offers')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: korangeColor),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            lang.noOffersAvailable,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      }

                      return ListView(
                        padding: EdgeInsets.zero,
                        children:
                            snapshot.data!.docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              final title = data['offerCode'] ?? 'No Code';
                              final endDate = data['endDate'] ?? '';
                              final offerValue = data['offerValue'] ?? '';

                              return ticketCoupon(
                                title,
                                endDate,
                                offerValue,
                                () {
                                  applyCoupon(title, offerValue);
                                },
                              );
                            }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDateTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    String date =
        "${dateTime.day.toString().padLeft(2, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.year}";

    int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String amPm = dateTime.hour >= 12 ? "PM" : "AM";

    String time = "${hour.toString().padLeft(2, '0')}:$minute $amPm";

    return "$date, $time";
  }

  Widget ticketCoupon(
    String title,
    String endDate,
    String offerValue,
    Function() onApply,
  ) {
    final lang = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: KgreyorangeColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textcolor: Colors.black,
                  ),

                  const SizedBox(height: 4),

                  CustomText(
                    text: '${lang.validTill} ${formatDateTime(endDate)}',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textcolor: kseegreyColor,
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, korangeresponseColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                CustomText(
                  text:
                      offerValue.contains('%')
                          ? "$offerValue OFF"
                          : "₹$offerValue OFF",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  textcolor: Colors.white,
                ),

                const SizedBox(height: 4),

                InkWell(
                  onTap: () {
                    if (isCouponApplied && appliedCouponCode == title) {
                      removeCoupon();
                    } else {
                      // Normal apply
                      onApply();
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      text:
                          isCouponApplied && appliedCouponCode == title
                              ? lang.applied
                              : lang.applyNow,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textcolor: Colors.orange.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void removeCoupon() {
    setState(() {
      isCouponApplied = false;
      appliedCouponCode = null;
      appliedCouponValue = "";
      appliedDiscount = 0.0;

      finalTotal = totalPrice;
    });
  }

  Future<void> _showCancelRideDialog(Map<String, dynamic> data) async {
    bool isFree = await _isFreeCancellation();
    final lang = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Center(
              child: CustomText(
                text: lang.cancelRide,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textcolor: korangeColor,
              ),
            ),
            content: CustomText(
              text: isFree ? lang.cancelRideFree : lang.cancelRideCharge,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textcolor: KblackColor,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: korangeColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      lang.no,
                      style: TextStyle(
                        color: korangeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: korangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      if (isFree) {
                        await _cancelRideFree();
                      } else {
                        _openCheckout(59.0);
                      }
                    },
                    child: Text(
                      isFree ? lang.yes : lang.pay59,
                      style: TextStyle(
                        color: kwhiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Future<void> _cancelRideFree() async {
    final bookingId = widget.bookingData['bookingId'];
    if (bookingId == null) return;

    await FirebaseFirestore.instance
        .collection("bookings")
        .doc(bookingId)
        .update({
          "status": "Cancelled",
          "paymentStatus": "",
          "statusHistory": FieldValue.arrayUnion([
            {
              "status": "Cancelled",
              "dateTime": DateTime.now().toIso8601String(),
            },
          ]),
        });

    final driverDoc =
        await FirebaseFirestore.instance
            .collection('drivers')
            .doc(widget.bookingData['driverdocId'])
            .get();

    final driverToken = driverDoc['fcmToken'] ?? "";

    await fcmService.sendNotification(
      recipientFCMToken: driverToken,
      title: "Ride Cancelled",
      body: "Customer cancelled the ride. No charges applied.",
    );

    Navigator.pop(context);
  }

  Future<bool> _isFreeCancellation() async {
    final bookingId = widget.bookingData['bookingId'];
    if (bookingId == null) return true;

    final snap =
        await FirebaseFirestore.instance
            .collection("bookings")
            .doc(bookingId)
            .get();

    final data = snap.data()!;
    List history = data['statusHistory'] ?? [];

    DateTime? acceptedTime;

    for (var item in history) {
      if (item['status'] == "Accepted") {
        acceptedTime = DateTime.tryParse(item['dateTime']);
        break;
      }
    }

    if (acceptedTime == null) return true;
    int diffMins = DateTime.now().difference(acceptedTime).inMinutes;

    return diffMins <= 5;
  }
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

Future<void> saveReview({
  required String bookingId,
  required String driverId,
  required String userId,
  required int rating,
  required List<String> feedbackTags,
  required String comment,
}) async {
  await FirebaseFirestore.instance.collection('reviews').add({
    "bookingId": bookingId,
    "driverId": driverId,
    "userId": userId,
    "rating": rating,
    "feedbackTags": feedbackTags,
    "comment": comment,
    "timestamp": FieldValue.serverTimestamp(),
  });
}

bool isLoading = false;

void _showRatingDialog(BuildContext context, data) {
  int selectedStars = 0;
  final TextEditingController commentController = TextEditingController();
  final lang = AppLocalizations.of(context)!;
  final List<FeedbackOption> feedbackOptions = [
    FeedbackOption(
      label: lang.politeDriver,
      imagePath: "images/politeDriver.png",
    ),
    FeedbackOption(label: lang.cleanliness, imagePath: "images/cleanlines.png"),
    FeedbackOption(label: lang.smoothDriving, imagePath: "images/home.png"),
    FeedbackOption(label: lang.onTime, imagePath: "images/onTime.png"),
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
                  CustomText(
                    text: "${lang.howWasYourTrip} ${data['driverName']}?",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textcolor: korangeColor,
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    text: lang.tapToRateDriver,
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
                  CustomText(
                    text: lang.giveFeedback,
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
                                        isSelected ? korangeColor : KblackColor,
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
                      hintText: lang.leaveCommentOptional,
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

                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      )
                      : Center(
                        child: CustomButton(
                          text: lang.submit,
                          onPressed: () async {
                            if (selectedStars == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(lang.pleaseSelectRating),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('reviews')
                                .add({
                                  'bookingId': data['bookingId'],
                                  'driverId': data['driverId'],
                                  'ownerId': data['ownerId'],
                                  'rating': selectedStars,
                                  'feedback': selectedFeedback.toList(),
                                  'comment': commentController.text.trim(),
                                  'createdAt': FieldValue.serverTimestamp(),
                                });

                            final driverRef = FirebaseFirestore.instance
                                .collection('drivers')
                                .doc(data['driverdocId']);

                            FirebaseFirestore.instance.runTransaction((
                              transaction,
                            ) async {
                              final snapshot = await transaction.get(driverRef);

                              int totalReviews =
                                  snapshot.data()?['totalReviews'] ?? 0;
                              int totalRating =
                                  snapshot.data()?['totalRating'] ?? 0;

                              totalReviews += 1;
                              totalRating += selectedStars;

                              double averageRating = totalRating / totalReviews;

                              transaction.update(driverRef, {
                                'totalReviews': totalReviews,
                                'totalRating': totalRating,
                                'averageRating': averageRating,
                              });
                            });
                            final driverSnap =
                                await FirebaseFirestore.instance
                                    .collection('drivers')
                                    .doc(data['driverdocId'])
                                    .get();

                            final driverToken = driverSnap['fcmToken'] ?? "";

                            if (driverToken.isNotEmpty) {
                              await fcmService.sendNotification(
                                recipientFCMToken: driverToken,
                                title: "⭐ New Review Received",
                                body:
                                    "You received a ${selectedStars}★ rating from the customer.",
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BottomNavigation(),
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(lang.thankYouReviewSubmitted),
                              ),
                            );
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
