//
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Sidemenu/cancellationPolicyScreen.dart';
import 'package:mana_driver/Vehicles/payment_gateway.dart';
import 'package:mana_driver/Vehicles/vehicle_details.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class ConfirmDetails extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const ConfirmDetails({super.key, required this.bookingData});

  @override
  State<ConfirmDetails> createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  late Map<String, dynamic> data;
  Map<String, dynamic>? vehicleData;

  Map<String, dynamic>? driverData;

  @override
  void initState() {
    super.initState();
    data = widget.bookingData;
    fetchVehicleData();
    fetchDriver();
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

  void fetchDriver() async {
    String driverId = widget.bookingData['driverdocId'] ?? '';
    print('Driver ID: $driverId'); // Debug print
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
    }
  }

  @override
  Widget build(BuildContext context) {
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
    String driverEmail = data['driverEmail'] ?? 'example@email.com';
    String pickupLocation = data['pickup'] ?? '';
    String tripMode = data['tripMode'] ?? '';
    String tripTime = data['tripTime'] ?? '';
    String citylimithours = data['cityLimitHours'].toString();
    String dropLocation = data['drop'] ?? '';
    String drop2Location = data['drop2'] ?? '';
    String date = data['date'] ?? 'DD/MM/YYYY';
    String time = data['time'] ?? 'HH:MM';
    String servicePrice = data['servicePrice']?.toString() ?? '0.00';
    String addonPrice = data['addonPrice']?.toString() ?? '0.00';
    String taxes = data['taxes']?.toString() ?? '0.00';
    String walletPoints = data['walletPoints']?.toString() ?? '0.00';
    String totalPrice = data['totalPrice']?.toString() ?? '0.00';

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
                  text: "Confirm Details",
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    height: 97,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          vehicleImage.startsWith('http')
                              ? Image.network(vehicleImage, fit: BoxFit.contain)
                              : Image.asset(vehicleImage, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: vehicleName,
                          textcolor: KblackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        Row(
                          children: [
                            CustomText(
                              text: transmission,
                              textcolor: kgreyColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            Text(' | ', style: TextStyle(color: kgreyColor)),
                            CustomText(
                              text: category,
                              textcolor: kgreyColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ],
                        ),

                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder:
                            //         (_) => VehicleDetailsScreen(
                            //           data: vehicleName,
                            //           docId: data['vehicleId'] ?? '',
                            //         ),
                            //   ),
                            // );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "View Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: korangeColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: KlightgreyColor, thickness: 3),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
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
                            drop2Location.isEmpty ? Colors.red : Colors.grey,
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
                      Image.asset("images/time.png", height: 20, width: 20),
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
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset("images/time.png", height: 20, width: 20),
                        const SizedBox(width: 8),
                        CustomText(
                          text: 'City Limit : $citylimithours Hours',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          textcolor: KblackColor,
                        ),
                      ],
                    ),
                  ],

                  //   if (tripTime == "City Limits" &&
                  //       citylimithours.toString().isNotEmpty) ...[
                  //     const SizedBox(height: 15),
                  //     Row(
                  //       children: [
                  //         Image.asset("images/time.png", height: 20, width: 20),
                  //         const SizedBox(width: 8),
                  //         CustomText(
                  //           text: '${citylimithours.toString()} Hours',
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w400,
                  //           textcolor: KblackColor,
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ],
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
                      Image.asset("images/time.png", height: 20, width: 20),
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
                      Image.asset("images/person.png", height: 20, width: 20),
                      const SizedBox(width: 8),
                      CustomText(
                        text:
                            ((SharedPrefServices.getFirstName() ?? '') +
                                        " " +
                                        (SharedPrefServices.getLastName() ??
                                            ''))
                                    .trim()
                                    .isNotEmpty
                                ? ((SharedPrefServices.getFirstName() ?? '') +
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
                        text: SharedPrefServices.getNumber() ?? driverPhone,
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
                        text: SharedPrefServices.getEmail() ?? driverEmail,
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
                        Image.asset("images/person.png", height: 20, width: 20),
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
                        text: "Add-on’s",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textcolor: KblackColor,
                      ),
                      CustomText(
                        text: "₹$addonPrice",
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
                        text: "Fee & Taxes",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textcolor: KblackColor,
                      ),
                      CustomText(
                        text: "₹$taxes",
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
                        text: "Wallet Points",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textcolor: KblackColor,
                      ),
                      CustomText(
                        text: "₹$walletPoints",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textcolor: KblackColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                    builder: (context) => const CancellationPolicyScreen(),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentGateway()),
            );
          },
          child: CustomText(
            text: "Proceed to Pay",
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
}



// static UI //
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:mana_driver/Sidemenu/cancellationPolicyScreen.dart';
// import 'package:mana_driver/Vehicles/payment_gateway.dart';
// import 'package:mana_driver/Vehicles/vehicle_details.dart';
// import 'package:mana_driver/Widgets/colors.dart';
// import 'package:mana_driver/Widgets/customText.dart';

// class ConfirmDetails extends StatefulWidget {
//   const ConfirmDetails({super.key});

//   @override
//   State<ConfirmDetails> createState() => _ConfirmDetailsState();
// }

// class _ConfirmDetailsState extends State<ConfirmDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(color: Colors.grey.shade300, height: 1.0),
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(bottom: 10.0, top: 5),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Image.asset(
//                     "images/chevronLeft.png",
//                     width: 24,
//                     height: 24,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: CustomText(
//                   text: "Confirm Details",
//                   textcolor: KblackColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 22,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.only(right: 15, left: 15),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 130,
//                     height: 97,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.asset(
//                         "images/swift.png",
//                         fit: BoxFit.contain,
//                         width: 130,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text: "Maruti Swift Dzire VXI",
//                           textcolor: KblackColor,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),

//                         CustomText(
//                           text: "White.Manual",
//                           textcolor: kgreyColor,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 12,
//                         ),

//                         SizedBox(height: 8),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (_) => VehicleDetailsScreen(
//                                       data: '',
//                                       docId: '',
//                                     ),
//                               ),
//                             );
//                           },
//                           child: RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "View Details",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                     color: korangeColor,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Divider(color: KlightgreyColor, thickness: 3),

//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CustomText(
//                     text: "Booking Details",
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     textcolor: korangeColor,
//                   ),

//                   const SizedBox(height: 10),

//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           _buildDot(Colors.red),
//                           const SizedBox(width: 8),
//                           const CustomText(
//                             text: "Pickup Location",
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                             textcolor: kseegreyColor,
//                           ),
//                         ],
//                       ),

//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 15,
//                           top: 5,
//                           bottom: 10,
//                         ),
//                         child: CustomText(
//                           text:
//                               "Sy.No.98, Main Rd, Near JLN House \nSerilingampally, Kondapur, 500084",
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           textcolor: KblackColor,
//                         ),
//                       ),

//                       Row(
//                         children: [
//                           _buildDot(Colors.green),
//                           const SizedBox(width: 8),
//                           const CustomText(
//                             text: "Drop Location",
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                             textcolor: kseegreyColor,
//                           ),
//                         ],
//                       ),

//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 15,
//                           top: 5,
//                           bottom: 10,
//                         ),
//                         child: CustomText(
//                           text:
//                               "Capital Park , Jain Sadguru’s Building, Madhapur 500081",
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           textcolor: KblackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const Divider(thickness: 3, color: KlightgreyColor),

//             const SizedBox(height: 15),

//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CustomText(
//                     text: "Slot Details",
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     textcolor: korangeColor,
//                   ),

//                   const SizedBox(height: 12),

//                   Row(
//                     children: [
//                       Image.asset(
//                         "images/calender_drvr.png",
//                         height: 20,
//                         width: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const CustomText(
//                         text: "28/07/2025",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     children: [
//                       Image.asset("images/time.png", height: 20, width: 20),
//                       const SizedBox(width: 8),
//                       const CustomText(
//                         text: "03:30 PM",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 15),
//             const Divider(thickness: 3, color: KlightgreyColor),

//             Padding(
//               padding: const EdgeInsets.only(right: 15, left: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CustomText(
//                     text: "Contact Details",
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     textcolor: korangeColor,
//                   ),
//                   const SizedBox(height: 12),

//                   Row(
//                     children: [
//                       Image.asset("images/person.png", height: 20, width: 20),
//                       const SizedBox(width: 8),
//                       const CustomText(
//                         text: "Ranjith Kumar",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),

//                   Row(
//                     children: [
//                       Image.asset(
//                         "images/call_drvr.png",
//                         height: 20,
//                         width: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const CustomText(
//                         text: "+91 9876543210",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),

//                   Row(
//                     children: [
//                       Image.asset(
//                         "images/email_drvr.png",
//                         height: 20,
//                         width: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const CustomText(
//                         text: "ranjith@example.com",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 15),
//             const Divider(thickness: 3, color: KlightgreyColor),

//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CustomText(
//                     text: "Payment Summary",
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     textcolor: korangeColor,
//                   ),
//                   const SizedBox(height: 12),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       CustomText(
//                         text: "Service Price",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                       CustomText(
//                         text: "₹1,799.00",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       CustomText(
//                         text: "Add-on’s",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                       CustomText(
//                         text: "₹119.00",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       CustomText(
//                         text: "Fee & Taxes",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                       CustomText(
//                         text: "₹100.00",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       CustomText(
//                         text: "Wallet Points",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                       CustomText(
//                         text: "₹00.00",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         textcolor: KblackColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   const DottedLine(dashColor: kseegreyColor),
//                   const SizedBox(height: 10),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       CustomText(
//                         text: "Total Price",
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         textcolor: korangeColor,
//                       ),
//                       CustomText(
//                         text: "₹2,080.00",
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         textcolor: korangeColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),

//                   const DottedLine(dashColor: kseegreyColor),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 15),
//             const Divider(thickness: 3, color: KlightgreyColor),
//             const SizedBox(height: 20),
//             _buildCard(
//               context,
//               imagePath: 'images/copoun_image.png',
//               text: 'Coupons & Offers',
//               onTap: () {},
//             ),
//             const SizedBox(height: 15),
//             _buildCard(
//               context,
//               imagePath: 'images/cancel_image.png',
//               text: 'Cancellation policy',
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const CancellationPolicyScreen(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 130),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: SizedBox(
//         width: 220,
//         height: 50,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: korangeColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(40),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => PaymentGateway()),
//             );
//           },
//           child: CustomText(
//             text: "Proceed to Pay",
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             textcolor: kwhiteColor,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(
//     BuildContext context, {
//     required String imagePath,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.only(right: 15, left: 15),
//         child: Container(
//           height: 54,
//           padding: const EdgeInsets.only(right: 10, left: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: kbordergreyColor),
//           ),
//           child: Row(
//             children: [
//               Image.asset(imagePath, height: 20, width: 20),
//               SizedBox(width: 12),
//               Expanded(
//                 child: CustomText(
//                   text: text,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   textcolor: KblackColor,
//                 ),
//               ),
//               Image.asset('images/chevronRight.png', height: 18, width: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDot(Color color) {
//     return Container(
//       width: 7,
//       height: 7,
//       decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//     );
//   }
// }