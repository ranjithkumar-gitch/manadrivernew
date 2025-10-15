import 'package:flutter/material.dart';

import 'package:mana_driver/Widgets/colors.dart';

import 'package:mana_driver/Widgets/customText.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int selectedAddress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      text: "Notifications",
                      textcolor: KblackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  Icon(Icons.more_vert),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Recent Notifications',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: KaddresscardborderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("images/user.png"),
                        ),
                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: 'Ranjith kumar',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                textcolor: korangeColor,
                              ),
                              const Text(
                                "Accepted your booking",
                                style: TextStyle(color: kseegreyColor),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset('images/calender.png'),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "14/07/2025",
                                    style: TextStyle(color: kseegreyColor),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: kseegreyColor,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    '12:00 PM',
                                    style: TextStyle(color: kseegreyColor),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Icon(Icons.more_vert),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
