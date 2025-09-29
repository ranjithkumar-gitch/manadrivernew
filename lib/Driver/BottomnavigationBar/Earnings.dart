import 'package:flutter/material.dart';

import 'package:mana_driver/Driver/D_Appbar/d_appbar.dart';
import 'package:mana_driver/Driver/sidemenu/D_Sidemenu.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class MyEarnings extends StatelessWidget {
  const MyEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const D_SideMenu(),
      appBar: DAppbar(),

      body: Column(
        children: [
          ClipPath(
            clipper: VShapeClipper(),
            child: Container(
              width: double.infinity,
              color: klightorangecolor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CustomText(
                    text: "Total earnings",
                    textcolor: korangeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    text: "₹1500.0",
                    textcolor: korangeColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomText(
                      text:
                          "The ride payment will be auto-debited to your account once the customer pays for the booking in cash.",
                      textcolor: korangeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Heading with filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.filter_list),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Card(
                  color: kwhiteColor,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: kcirclegrey,
                          child: Image.asset("images/download.png"),
                        ),
                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Ranjith",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: korangeColor,
                                fontSize: 14,
                              ),
                            ),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Text(
                                    "Sent by UPI",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),

                                  VerticalDivider(
                                    color: kgreyColor,
                                    thickness: 1,
                                    width: 16,
                                  ),
                                  Text(
                                    "12 Sep 2025",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              "₹500",
                              style: TextStyle(
                                color: korangeColor,

                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Credited",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
