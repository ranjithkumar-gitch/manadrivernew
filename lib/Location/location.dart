import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class LocationSelectionScreen extends StatelessWidget {
  final TextEditingController currentLocationController =
      TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();

  LocationSelectionScreen({super.key});

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
                  text: "Location",
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: kwhiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kbordergreyColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Image.asset("images/greencircle.png"),

                        _buildVerticalLine(),
                        Image.asset("images/redCircle.png"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: currentLocationController,
                          decoration: const InputDecoration(
                            hintText: "Current Location",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: KblackColor,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(thickness: 1, color: kbordergreyColor),
                        TextField(
                          controller: dropLocationController,
                          decoration: const InputDecoration(
                            hintText: "Drop Location",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: KblackColor,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CustomText(
                  text: "Select from map",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textcolor: korangeColor,
                  underline: true,
                  underlineColor: korangeColor,
                ),
                CustomText(
                  text: "Add Drop",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textcolor: korangeColor,
                  underline: true,
                  underlineColor: korangeColor,
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CustomText(
                  text: "Drop Suggestions",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textcolor: korangeColor,
                ),
                CustomText(
                  text: "Clear All",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textcolor: KredColor,
                  underline: true,
                  underlineColor: KredColor,
                ),
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Image.asset("images/history.png"),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "Durgam Cheruvu Metro Station",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textcolor: KblackColor,
                                ),
                                const SizedBox(height: 4),
                                const CustomText(
                                  text:
                                      "Durgam Cheeruvu Metro Station, Hitech City Road, \nSir Sai Nagar, Madhapur Yderabad",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textcolor: kseegreyColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalLine() {
    return Container(
      width: 2,
      height: 40,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
