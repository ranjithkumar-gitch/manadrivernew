import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/homeScreen.dart';
import 'package:mana_driver/Vehicles/confirm_details.dart';
import 'package:mana_driver/Vehicles/edit_vehicle_details.dart';
import 'package:mana_driver/Vehicles/my_vehicle.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final data;
  final String docId;
  const VehicleDetailsScreen({
    super.key,
    required this.docId,
    required this.data,
  });

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
                  text: "Vehicle Details",
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'edit') {
                print(docId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EditVehicleDetails(data: data, docId: docId),
                  ),
                );
              } else if (value == 'delete') {
                showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text("Delete Vehicle"),
                        content: const Text(
                          "Are you sure you want to delete this vehicle?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Vehicle deleted"),
                                ),
                              );
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'edit', child: Text("Edit")),
                  const PopupMenuItem(value: 'delete', child: Text("Delete")),
                ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Container(
                //   width: 130,
                //   height: 97,
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade100,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Image.asset("images/swift.png"),
                // ),
                // Container(
                //   width: 130,
                //   height: 97,
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade100,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(12),
                //     child: CarouselSlider(
                //       items: [
                //         Image.asset(
                //           "images/swift.png",
                //           fit: BoxFit.contain,
                //           width: 130,
                //         ),
                //         Image.asset(
                //           "images/swift.png",
                //           fit: BoxFit.contain,
                //           width: 130,
                //         ),
                //         Image.asset(
                //           "images/swift.png",
                //           fit: BoxFit.contain,
                //           width: 130,
                //         ),
                //       ],
                //       options: CarouselOptions(
                //         viewportFraction: 1,
                //         height: 97,
                //         autoPlay: true,
                //         enableInfiniteScroll: true,
                //         autoPlayInterval: Duration(seconds: 3),
                //         scrollDirection: Axis.horizontal,
                //       ),
                //     ),
                //   ),
                // ),
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
                        (data['images'] != null &&
                                data['images'] is List &&
                                data['images'].isNotEmpty)
                            ? CarouselSlider(
                              items:
                                  (data['images'] as List<dynamic>).map((
                                    imgUrl,
                                  ) {
                                    return Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                      width: 130,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.car_crash),
                                    );
                                  }).toList(),
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 97,
                                autoPlay: true,
                                enableInfiniteScroll: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                scrollDirection: Axis.horizontal,
                              ),
                            )
                            : const Icon(Icons.directions_car),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: '${data['brand']} ${data['model']}',
                        textcolor: KblackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),

                      CustomText(
                        text:
                            "Exceptional performance and premium comfort features.",
                        textcolor: kgreyColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),

                      SizedBox(height: 8),
                      // RichText(
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text: "₹7,957",
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 18,
                      //           color: korangeColor,
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: "/per ride",
                      //         style: TextStyle(color: kgreyColor),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionCard(
              title: "Key Specifications",
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // _SpecItem(
                      //   iconPath: 'images/mileage.png',
                      //   label: "Mileage",
                      //   value: "24kmpl",
                      // ),
                      SizedBox(width: 15),
                      _SpecItem(
                        iconPath: 'images/fuel.png',
                        label: "Fuel Type",
                        value: data['fuelType'] ?? "",
                      ),
                      _SpecItem(
                        iconPath: 'images/settings.png',
                        label: "Transmission",
                        value: data['transmission'] ?? "",
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: const [
                  //     _SpecItem(
                  //       iconPath: 'images/peoples.png',
                  //       label: "Seats",
                  //       value: "5",
                  //     ),
                  //     _SpecItem(
                  //       iconPath: 'images/paint.png',
                  //       label: "Color",
                  //       value: "White",
                  //     ),
                  //     _SpecItem(
                  //       iconPath: 'images/date.png',
                  //       label: "Year",
                  //       value: "2024",
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Features & Equipment
            // _section(
            //   title: "Features & Equipment",
            //   child: const Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       CustomText(
            //         text: "• All-Wheel Drive",
            //         textcolor: KblackColor,
            //         fontWeight: FontWeight.w400,
            //         fontSize: 13,
            //       ),
            //       const SizedBox(height: 8),
            //       CustomText(
            //         text: "• Premium Package",
            //         textcolor: KblackColor,
            //         fontWeight: FontWeight.w400,
            //         fontSize: 13,
            //       ),
            //       const SizedBox(height: 8),
            //       CustomText(
            //         text: "• Navigation",
            //         textcolor: KblackColor,
            //         fontWeight: FontWeight.w400,
            //         fontSize: 13,
            //       ),
            //       const SizedBox(height: 8),
            //       CustomText(
            //         text: "• Heated Seats",
            //         textcolor: KblackColor,
            //         fontWeight: FontWeight.w400,
            //         fontSize: 13,
            //       ),
            //     ],
            //   ),
            // ),

            // const SizedBox(height: 16),

            // _section(
            //   title: "About Vehicle",
            //   child: CustomText(
            //     text:
            //         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's "
            //         "standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            //     textcolor: KblackColor,
            //     fontWeight: FontWeight.w400,
            //     fontSize: 13,
            //   ),
            // ),
            const SizedBox(height: 30),

            // Button
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
                    showBookingBottomSheet(context);
                  },
                  child: CustomText(
                    text: "Book a Driver",
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
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kbordergreyColor, width: 1),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CustomText(
                text: title,
                textcolor: korangeColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  void showBookingBottomSheet(BuildContext context) {
    TextEditingController addressTitleController = TextEditingController();
    TextEditingController addressDetailsController = TextEditingController();
    List<Map<String, String>> savedAddresses = [
      {
        "title": "Home",
        "details":
            "Sy.No.98, Main Rd, Near JLN House\nSerilingampally, Kondapur, 500084",
      },
    ];
    int selectedAddressIndex = 0;
    String selectedTripMode = "Round Trip";
    String selectedTripTime = "Schedule";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        DateTime selectedDate = DateTime.now();
        TimeOfDay selectedTime = TimeOfDay.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            CustomText(
                              text: "Select Trip mode",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: KblackColor,
                            ),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: tripOption(
                                    "Hourly",
                                    selected: selectedTripMode == "Hourly",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "Hourly";
                                      });
                                      print(
                                        "Selected Trip Mode: $selectedTripMode",
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: tripOption(
                                    "Round Trip",
                                    selected: selectedTripMode == "Round Trip",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "Round Trip";
                                      });
                                      print(
                                        "Selected Trip Mode: $selectedTripMode",
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: tripOption(
                                    "One way",
                                    selected: selectedTripMode == "One way",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "One way";
                                      });
                                      print(
                                        "Selected Trip Mode: $selectedTripMode",
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: tripOption(
                                    "Out Station",
                                    selected: selectedTripMode == "Out Station",
                                    onTap: () {
                                      setState(() {
                                        selectedTripMode = "Out Station";
                                      });
                                      print(
                                        "Selected Trip Mode: $selectedTripMode",
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Divider(
                        color: kbordergreyColor,
                        thickness: 4,
                        height: 10,
                      ),

                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Choose Trip Time",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: KblackColor,
                            ),

                            SizedBox(height: 10),
                            tripOption(
                              "Now",
                              selected: selectedTripTime == "Now",
                              onTap: () {
                                setState(() {
                                  selectedTripTime = "Now";
                                });
                                print("Selected Trip Time: $selectedTripTime");
                              },
                            ),
                            tripOption(
                              "Schedule",
                              selected: selectedTripTime == "Schedule",
                              onTap: () {
                                setState(() {
                                  selectedTripTime = "Schedule";
                                });
                                print("Selected Trip Time: $selectedTripTime");
                              },
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kbordergreyColor,
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    setState(() => selectedDate = picked);
                                  }
                                },
                                child: dateTimeRow(
                                  Icons.date_range,
                                  "Select Date",
                                  value:
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                ),
                              ),
                              Divider(color: kbordergreyColor),
                              GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                        context: context,
                                        initialTime: selectedTime,
                                      );
                                  if (picked != null) {
                                    setState(() => selectedTime = picked);
                                  }
                                },
                                child: dateTimeRow(
                                  Icons.timer,
                                  "Select Time",
                                  value: selectedTime.format(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: kbordergreyColor,
                        thickness: 4,
                        height: 10,
                      ),

                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "Select Address",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textcolor: KblackColor,
                                ),

                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                MediaQuery.of(
                                                  context,
                                                ).viewInsets.bottom,
                                            top: 20,
                                            left: 20,
                                            right: 20,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                style: GoogleFonts.poppins(
                                                  color: KblackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                controller:
                                                    addressTitleController,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Address Title (e.g. Home, Office)",
                                                  labelStyle: TextStyle(
                                                    color: kgreyColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 16,
                                                        horizontal: 16,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                          color:
                                                              kbordergreyColor,
                                                        ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                          color:
                                                              kbordergreyColor,
                                                        ),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                          color:
                                                              kbordergreyColor,
                                                          width: 2,
                                                        ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 15),

                                              TextFormField(
                                                textInputAction:
                                                    TextInputAction.done,
                                                style: GoogleFonts.poppins(
                                                  color: KblackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                controller:
                                                    addressDetailsController,
                                                maxLines: 2,
                                                decoration: InputDecoration(
                                                  labelText: "Full Address",
                                                  alignLabelWithHint: true,
                                                  labelStyle: TextStyle(
                                                    color: kgreyColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 16,
                                                        horizontal: 16,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                          color:
                                                              kbordergreyColor,
                                                        ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                          color:
                                                              kbordergreyColor,
                                                        ),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                          color:
                                                              kbordergreyColor,
                                                          width: 2,
                                                        ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 20),
                                              SizedBox(
                                                width: 220,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        korangeColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            40,
                                                          ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    if (addressTitleController
                                                            .text
                                                            .isNotEmpty &&
                                                        addressDetailsController
                                                            .text
                                                            .isNotEmpty) {
                                                      setState(() {
                                                        savedAddresses.add({
                                                          "title":
                                                              addressTitleController
                                                                  .text,
                                                          "details":
                                                              addressDetailsController
                                                                  .text,
                                                        });
                                                        selectedAddressIndex =
                                                            savedAddresses
                                                                .length -
                                                            1;
                                                      });

                                                      addressTitleController
                                                          .clear();
                                                      addressDetailsController
                                                          .clear();

                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: CustomText(
                                                    text: "Save",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    textcolor: kwhiteColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Add New Address',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: korangeColor,
                                      decoration: TextDecoration.underline,
                                      decorationColor: korangeColor,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationThickness: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: savedAddresses.length,
                              itemBuilder: (context, index) {
                                final isSelected =
                                    index == selectedAddressIndex;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAddressIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kbordergreyColor,
                                        width: 1.3,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: korangeColor,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text:
                                                    savedAddresses[index]['title'] ??
                                                    '',
                                                textcolor: korangeColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(height: 5),
                                              CustomText(
                                                text:
                                                    savedAddresses[index]['details'] ??
                                                    '',
                                                textcolor: kgreyColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Estimated fare",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      textcolor: kgreyColor,
                                    ),

                                    CustomText(
                                      text: "₹ 2,080",
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      textcolor: korangeColor,
                                    ),

                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showPaymentSheet(context);
                                          },
                                          child: Text(
                                            'View Breakup',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: kgreyColor,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: kgreyColor,
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
                                              decorationThickness: 1.5,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: kgreyColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 203,
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ConfirmDetails(),
                                        ),
                                      );
                                    },
                                    child: CustomText(
                                      text: "Continue",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textcolor: kwhiteColor,
                                    ),
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
              ),
            );
          },
        );
      },
    );
  }

  void showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          margin: EdgeInsets.all(10),
          height: 230,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              const CustomText(
                text: "Payment Breakup",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textcolor: KblackColor,
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
              const SizedBox(height: 15),

              const DottedLine(dashColor: kseegreyColor),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomText(
                    text: "Total Price",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textcolor: korangeColor,
                  ),
                  CustomText(
                    text: "₹2,080.00",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textcolor: korangeColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              const DottedLine(dashColor: kseegreyColor),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

Widget tripOption(String label, {bool selected = false, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? korangeColor : kgreyColor,
          ),
          SizedBox(width: 10),
          CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textcolor: KblackColor,
          ),
        ],
      ),
    ),
  );
}

Widget dateTimeRow(IconData icon, String label, {String? value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: korangeColor),
            SizedBox(width: 10),
            CustomText(
              text: label,
              textcolor: KblackColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        Row(
          children: [
            CustomText(
              text: value ?? "",
              textcolor: KblackColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(width: 5),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ],
    ),
  );
}

Widget addressCard(String title, String address) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: kbordergreyColor, width: 1.3),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(Icons.radio_button_checked, color: korangeColor),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                textcolor: korangeColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 5),
              CustomText(
                text: address,
                textcolor: kgreyColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _section({required String title, required Widget child}) {
  return Container(
    width: double.infinity,

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kbordergreyColor, width: 1),
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: CustomText(
              text: title,
              textcolor: korangeColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),
          Padding(padding: const EdgeInsets.only(left: 10), child: child),
        ],
      ),
    ),
  );
}

class _SpecItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _SpecItem({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 18, width: 18, fit: BoxFit.contain),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: label,
                textcolor: kgreyColor,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              const SizedBox(height: 2),
              CustomText(
                text: value,
                textcolor: KblackColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
