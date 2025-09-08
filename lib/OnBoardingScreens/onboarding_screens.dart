import 'package:flutter/material.dart';
import 'package:mana_driver/Login/selectLanguage.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Verified Drivers.\nSafe Journeys\nwith Mana Driver.",
      "subtitle":
          "All drivers on Mana Driver are background-verified for your peace of mind.",
    },
    {
      "title": "Hourly, One-Way\n& Round Trips\nwith Mana Driver.",
      "subtitle":
          "Book a Mana Driver as per your travel need—any time, any trip type.",
    },
    {
      "title": "Your Vehicle.\nOur Driver.\nMana Driver.",
      "subtitle": "A reliable Mana Driver is just a tap away.",
    },
  ];

  String selectedValue = 'English';
  List<String> languageOptions = ['English', 'Telugu'];
  @override
  // void dispose() {
  //   FocusScope.of(context).unfocus();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: korangeColor,
      body: Stack(
        children: [
          Positioned(
            top: -10,
            left: -70,
            child: Image.asset(
              'images/onboard.png',
              width: 500,
              height: 430,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            top: 70,
            right: 10,
            child: Container(
              width: 120,
              height: 38,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: KorangeLightColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: kwhiteColor,
                  ),
                  style: TextStyle(color: Colors.white),
                  dropdownColor: KorangeLightColor,
                  items:
                      languageOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: CustomText(
                            text: value,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            textcolor: kwhiteColor,
                          ),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingData.length,
                  onPageChanged:
                      (index) => setState(() => currentIndex = index),
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 343,
                        left: 15,
                        right: 15,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          CustomText(
                            text: data['title']!,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            textcolor: kwhiteColor,
                          ),

                          SizedBox(height: 6),
                          CustomText(
                            text: data['subtitle']!,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            textcolor: kwhiteColor,
                          ),

                          SizedBox(height: 32),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    currentIndex == 0
                        ? SizedBox(width: 44)
                        : Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: KorangeLightColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: kwhiteColor,
                              size: 32,
                            ),
                            onPressed:
                                () => _controller.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                ),
                          ),
                        ),

                    SmoothPageIndicator(
                      controller: _controller,
                      count: onboardingData.length,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.white54,
                        activeDotColor: Colors.white,
                        dotHeight: 9,
                        dotWidth: 9,
                        expansionFactor: 5,
                        spacing: 5,
                      ),
                    ),

                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: KorangeLightColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: kwhiteColor,
                          size: 32,
                        ),
                        onPressed: () {
                          if (currentIndex < onboardingData.length - 1) {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LanguageSelectionScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
