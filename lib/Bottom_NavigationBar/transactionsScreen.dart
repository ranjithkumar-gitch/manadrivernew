import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:mana_driver/AppBar/appBar.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomMainAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Image.asset("images/filter.png"),
                    SizedBox(width: 4),
                    CustomText(
                      text: "Filter",
                      fontSize: 14,
                      textcolor: korangeColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Card(
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
                        const CustomText(
                          text: "#MN782478",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textcolor: KblackColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Image.asset("images/idcard.png", width: 24, height: 24),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: CustomText(
                            text: "Ranjith Kumar",
                            textcolor: kseegreyColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const CustomText(
                          text: "12:30 PM",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textcolor: kseegreyColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Image.asset("images/car.png", width: 24, height: 24),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: CustomText(
                            text: "Swift Dezire XLV - 3940",
                            textcolor: kseegreyColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const CustomText(
                          text: "25 July 2025",
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
                          children: const [
                            CustomText(
                              text: "₹750",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: korangeColor,
                            ),
                            SizedBox(height: 4),
                            CustomText(
                              text: "UPI",
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
                          child: const CustomText(
                            text: "Payment Completed",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textcolor: KgreenColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
