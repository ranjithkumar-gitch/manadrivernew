import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/Myrides.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';

class DriverAssignedScreen extends StatelessWidget {
  const DriverAssignedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController currentLocationController =
        TextEditingController();
    final TextEditingController dropLocationController =
        TextEditingController();
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
                  text: "Driver Assigned",
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Image.asset("images/fav_img.png"),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("images/user.png"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Ranjth Kumar",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      textcolor: korangeColor,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset("images/rating.png"),
                        const SizedBox(width: 4),
                        const Text("4.8"),
                        const SizedBox(width: 16),
                        Image.asset("images/rides.png"),

                        const SizedBox(width: 4),
                        const Text("Rides"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(height: 50, width: 1, color: Colors.grey.shade300),
              const SizedBox(width: 12),
              Row(
                children: [
                  Image.asset("images/chat.png"),
                  const SizedBox(width: 5),

                  Image.asset("images/call.png"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(thickness: 3, color: KlightgreyColor),

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Image.asset("images/car2.png", height: 24, width: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "White Maruti Suzuki Swift",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textcolor: KblackColor,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          CustomText(
                            text: "TG 05 MN 3940",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textcolor: kseegreyColor,
                          ),
                          const SizedBox(width: 12),
                          Container(height: 20, width: 1, color: kseegreyColor),
                          SizedBox(width: 12),
                          CustomText(
                            text: "Hatchback",
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

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Image.asset("images/review.png", height: 50, width: 50),
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

          const SizedBox(height: 6),
          const Divider(thickness: 3, color: KlightgreyColor),

          const CustomText(
            text: "Address Details",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textcolor: korangeColor,
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildDot(Colors.red),
                    const SizedBox(width: 8),
                    const CustomText(
                      text: "Current Location",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textcolor: kseegreyColor,
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: currentLocationController,
                    decoration: const InputDecoration(
                      hintText:
                          "Sy.No.98, Main Rd, Near JLN House \nSerilingampally, Kondapur, 500084",
                      hintStyle: TextStyle(color: KblackColor),
                      border: InputBorder.none,
                    ),
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
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: dropLocationController,
                    decoration: const InputDecoration(
                      hintText:
                          "Capital Park , Jain Sadguru’s Building, Madhapur 500081",
                      hintStyle: TextStyle(color: KblackColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 3, color: KlightgreyColor),

          const SizedBox(height: 16),
          const CustomText(
            text: "Slot Details",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textcolor: korangeColor,
          ),
          const SizedBox(height: 12),

          Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "images/calender_drvr.png",
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(width: 8),
                  const CustomText(
                    text: "26 July 2025",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
          const SizedBox(height: 16),
          const Divider(thickness: 3, color: KlightgreyColor),

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
          const SizedBox(height: 8),

          Row(
            children: [
              Image.asset("images/call_drvr.png", height: 20, width: 20),
              const SizedBox(width: 8),
              const CustomText(
                text: "+91 9876543210",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textcolor: KblackColor,
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Image.asset("images/email_drvr.png", height: 20, width: 20),
              const SizedBox(width: 8),
              const CustomText(
                text: "ranjith@example.com",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textcolor: KblackColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 3, color: KlightgreyColor),

          // Payment Summary
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
          const SizedBox(height: 20),

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
          const SizedBox(height: 20),

          const DottedLine(dashColor: kseegreyColor),
          const SizedBox(height: 50),

          Center(
            child: SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: korangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                ),
                onPressed: () {
                  showCancelReasonBottomSheet(context);
                },
                child: CustomText(
                  text: "Cancel Ride",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textcolor: kwhiteColor,
                ),
              ),
            ),
          ),

          // CustomButton(
          //   text: 'Cancel Ride',
          //   onPressed: () {
          //     showCancelReasonBottomSheet(context);
          //   },
          //   width: 220,
          //   height: 50,
          // ),
          const SizedBox(height: 20),
        ],
      ),
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
                        onPressed: () {},
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

void _showCanceldailog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,

    barrierLabel: "Driver Dialog",
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => BottomNavigation()));
      });
      return Center(
        child: Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Image.asset(
                'images/cancellationdailog.png',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 10),

              CustomText(
                text: 'Cancellation Successful',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textcolor: KblackColor,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: Text(
                  "Your request has been processed.We're sorry to see you go!",

                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kgreyColor,
                    decoration: TextDecoration.none,
                  ),

                  textAlign: TextAlign.center,
                ),
              ),
              // SizedBox(
              //   width: 250,
              //   child: Center(
              //     child: CustomText(
              //       text:
              //           "Your request has been processed.We're sorry to see you go!",

              //       fontSize: 14,
              //       fontWeight: FontWeight.w400,
              //       textcolor: kgreyColor,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    },
  );
}

void showCancelReasonBottomSheet(BuildContext context) {
  String? selectedReason;
  final reasons = [
    "Booked by Mistake",
    "Found an Alternative Option",
    "Pricing / Cost Issue",
    "Personal Reasons",
    "Emergency Situation",
    "Dissatisfied with Previous Experience",
    "Technical Issues / App Glitch",
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Cancel reason",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textcolor: KblackColor,
                ),

                SizedBox(height: 0),
                ...reasons.map((reason) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedReason = reason;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                      ), // control vertical space here
                      child: Row(
                        children: [
                          Radio<String>(
                            value: reason,
                            groupValue: selectedReason,
                            activeColor: korangeColor,
                            onChanged: (value) {
                              setState(() {
                                selectedReason = value;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: CustomText(
                              text: reason,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              textcolor: KblackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: korangeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      ),
                      onPressed:
                          selectedReason == null
                              ? null
                              : () async {
                                Navigator.pop(context);
                                _showCanceldailog(context);
                              },

                      child: CustomText(
                        text: "Cancel Ride",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textcolor: kwhiteColor,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildDot(Color color) {
  return Container(
    width: 12,
    height: 12,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class FeedbackOption {
  final String label;
  final String imagePath;

  FeedbackOption({required this.label, required this.imagePath});
}

class CancelRideBottomSheet {
  static Future<void> show(BuildContext context) async {
    String? selectedReason;

    final reasons = [
      "Booked by Mistake",
      "Found an Alternative Option",
      "Pricing / Cost Issue",
      "Personal Reasons",
      "Emergency Situation",
      "Dissatisfied with Previous Experience",
      "Technical Issues / App Glitch",
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cancel reason",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ...reasons.map((reason) {
                    return RadioListTile<String>(
                      value: reason,
                      groupValue: selectedReason,
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.orange,
                      title: Text(reason),
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        CancelRideBottomSheet.show(context);
                      },
                      child: Text(
                        "Cancel Ride",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
