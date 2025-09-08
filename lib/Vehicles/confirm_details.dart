import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/Sidemenu/cancellationPolicyScreen.dart';
import 'package:mana_driver/Vehicles/payment_gateway.dart';
import 'package:mana_driver/Vehicles/vehicle_details.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class ConfirmDetails extends StatefulWidget {
  const ConfirmDetails({super.key});

  @override
  State<ConfirmDetails> createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  @override
  Widget build(BuildContext context) {
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
                      child: Image.asset(
                        "images/swift.png",
                        fit: BoxFit.contain,
                        width: 130,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Maruti Swift Dzire VXI",
                          textcolor: KblackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),

                        CustomText(
                          text: "White.Manual",
                          textcolor: kgreyColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),

                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => VehicleDetailsScreen(
                                      data: '',
                                      docId: '',
                                    ),
                              ),
                            );
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
                          _buildDot(Colors.red),
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
                          text:
                              "Sy.No.98, Main Rd, Near JLN House \nSerilingampally, Kondapur, 500084",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          textcolor: KblackColor,
                        ),
                      ),

                      Row(
                        children: [
                          _buildDot(Colors.green),
                          const SizedBox(width: 8),
                          const CustomText(
                            text: "Drop Location",
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
                          text:
                              "Capital Park , Jain Sadguru’s Building, Madhapur 500081",
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

            const Divider(thickness: 3, color: KlightgreyColor),

            const SizedBox(height: 15),

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
                      const CustomText(
                        text: "28/07/2025",
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
                      const CustomText(
                        text: "03:30 PM",
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
                      const CustomText(
                        text: "Ranjith Kumar",
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
                      const CustomText(
                        text: "+91 9876543210",
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
                      const CustomText(
                        text: "ranjith@example.com",
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
                  const SizedBox(height: 20),

                  const DottedLine(dashColor: kseegreyColor),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CustomText(
                        text: "Total Price",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        textcolor: korangeColor,
                      ),
                      CustomText(
                        text: "₹2,080.00",
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
