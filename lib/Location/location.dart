import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:mana_driver/Location/map_screen.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController currentLocationController =
      TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final FocusNode currentFocus = FocusNode();
  final FocusNode dropFocus = FocusNode();

  late FlutterGooglePlacesSdk places;
  List<AutocompletePrediction> predictions = [];
  bool isCurrent = true;
  bool isPickupSelection = true;
  // Lat/Lng storage
  String pickupLat = "";
  String pickupLng = "";
  String dropLat = "";
  String dropLng = "";
  String drop2Lat = "";
  String drop2Lng = "";

  bool showSecondDrop = false;
  TextEditingController secondDropController = TextEditingController();
  FocusNode secondDropFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    places = FlutterGooglePlacesSdk("AIzaSyDMihIxRDdcdyNby8aKMLIwsBFGLGuhLFI");
  }

  Future<void> _onChanged(
    String value,
    bool current, {
    bool isSecondDrop = false,
  }) async {
    if (value.isNotEmpty) {
      final result = await places.findAutocompletePredictions(value);
      setState(() {
        predictions = result.predictions;
        isCurrent = current;
      });
    } else {
      setState(() => predictions.clear());
    }
  }

  Future<void> _onSuggestionTap(AutocompletePrediction p) async {
    final response = await places.fetchPlace(
      p.placeId!,
      fields: [PlaceField.Location, PlaceField.Name],
    );

    final place = response.place;

    setState(() {
      if (isCurrent) {
        currentLocationController.text = p.fullText ?? "";
        pickupLat = place?.latLng?.lat.toString() ?? "";
        pickupLng = place?.latLng?.lng.toString() ?? "";
        isPickupSelection = false;
      } else {
        if (showSecondDrop && secondDropFocus.hasFocus) {
          secondDropController.text = p.fullText ?? "";
          drop2Lat = place?.latLng?.lat.toString() ?? "";
          drop2Lng = place?.latLng?.lng.toString() ?? "";
        } else {
          dropLocationController.text = p.fullText ?? "";
          dropLat = place?.latLng?.lat.toString() ?? "";
          dropLng = place?.latLng?.lng.toString() ?? "";
        }
      }
      predictions.clear();
    });
  }

  // void _onSuggestionTap(AutocompletePrediction p) {
  //   setState(() {
  //     if (isCurrent) {
  //       currentLocationController.text = p.fullText ?? "";
  //     } else {
  //       if (showSecondDrop && secondDropFocus.hasFocus) {
  //         secondDropController.text = p.fullText ?? "";
  //       } else {
  //         dropLocationController.text = p.fullText ?? "";
  //       }
  //     }
  //     predictions.clear();
  //   });
  // }

  Future<void> _openMap({
    required bool isPickup,
    bool isSecondDrop = false,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MapPickScreen(
              isPickup: isPickup,
              isSecondDrop: isSecondDrop,
              previousLatLng:
                  isPickup && pickupLat.isNotEmpty
                      ? gmaps.LatLng(
                        double.parse(pickupLat),
                        double.parse(pickupLng),
                      )
                      : !isPickup && !isSecondDrop && dropLat.isNotEmpty
                      ? gmaps.LatLng(
                        double.parse(dropLat),
                        double.parse(dropLng),
                      )
                      : isSecondDrop && dropLat.isNotEmpty
                      ? gmaps.LatLng(
                        double.parse(dropLat),
                        double.parse(dropLng),
                      )
                      : null,
              previousLocationName:
                  isPickup
                      ? currentLocationController.text
                      : isSecondDrop
                      ? secondDropController.text
                      : dropLocationController.text,
            ),
      ),
    );

    // if (result != null) {
    //   setState(() {
    //     if (isPickup) {
    //       currentLocationController.text = result['locationName'];
    //       pickupLat = result['latitude'].toString();
    //       pickupLng = result['longitude'].toString();
    //       isPickupSelection = false;
    //     } else if (isSecondDrop) {
    //       secondDropController.text = result['locationName'];
    //     } else {
    //       dropLocationController.text = result['locationName'];
    //       dropLat = result['latitude'].toString();
    //       dropLng = result['longitude'].toString();
    //     }
    //   });
    // }

    if (result != null) {
      setState(() {
        if (isPickup) {
          currentLocationController.text = result['locationName'];
          pickupLat = result['latitude'].toString();
          pickupLng = result['longitude'].toString();
          isPickupSelection = false;
        } else if (isSecondDrop) {
          secondDropController.text = result['locationName'];
          drop2Lat = result['latitude'].toString();
          drop2Lng = result['longitude'].toString(); // <--- And this
        } else {
          dropLocationController.text = result['locationName'];
          dropLat = result['latitude'].toString();
          dropLng = result['longitude'].toString();
        }
      });
    }
  }

  //

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
              const Center(
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

                        _buildVerticalLine(extended: showSecondDrop),

                        if (showSecondDrop)
                          Image.asset("images/redCircle.png")
                        else
                          Image.asset("images/redCircle.png"),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          focusNode: currentFocus,
                          controller: currentLocationController,
                          onChanged: (value) => _onChanged(value, true),
                          textInputAction: TextInputAction.next,
                          onSubmitted:
                              (_) => FocusScope.of(
                                context,
                              ).requestFocus(dropFocus),
                          decoration: const InputDecoration(
                            hintText: "Pickup Location",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: KblackColor,
                            ),
                            border: InputBorder.none,
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: kbordergreyColor,
                                thickness: 1.3,
                              ),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              height: 30,
                              width: 68,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      showSecondDrop
                                          ? Colors.red
                                          : korangeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showSecondDrop = !showSecondDrop;
                                    if (!showSecondDrop)
                                      secondDropController.clear();
                                  });
                                },
                                child: CustomText(
                                  text: showSecondDrop ? 'Delete' : 'Add',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: kwhiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          focusNode: dropFocus,
                          controller: dropLocationController,
                          onChanged: (value) => _onChanged(value, false),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) {
                            Navigator.pop(context, {
                              "current": currentLocationController.text,
                              "drop": dropLocationController.text,
                            });
                          },
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
                        if (showSecondDrop)
                          TextField(
                            focusNode: secondDropFocus,
                            controller: secondDropController,
                            onChanged:
                                (value) => _onChanged(
                                  value,
                                  false,
                                  isSecondDrop: true,
                                ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              Navigator.pop(context, {
                                "current": currentLocationController.text,
                                "drop": dropLocationController.text,
                                "drop2": secondDropController.text,
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Drop Location 2",
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
              children: [
                InkWell(
                  onTap: () {
                    bool isPickup = currentFocus.hasFocus;
                    bool isSecondDrop = secondDropFocus.hasFocus;

                    _openMap(isPickup: isPickup, isSecondDrop: isSecondDrop);
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: korangeColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: korangeColor, size: 18),
                        const SizedBox(width: 3),
                        CustomText(
                          text:
                              showSecondDrop
                                  ? (currentLocationController
                                              .text
                                              .isNotEmpty &&
                                          dropLocationController
                                              .text
                                              .isNotEmpty &&
                                          secondDropController.text.isEmpty
                                      ? "Select drop2 on map"
                                      : "Select on map")
                                  : "Select on map",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textcolor: korangeColor,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 40,
                  width: 100,
                  child: ElevatedButton(
                    onPressed:
                        (currentLocationController.text.isNotEmpty &&
                                dropLocationController.text.isNotEmpty &&
                                (!showSecondDrop ||
                                    secondDropController.text.isNotEmpty))
                            ? () {
                              print(
                                "Pickup: ${currentLocationController.text} | Lat: $pickupLat | Lng: $pickupLng",
                              );
                              print(
                                "Drop1: ${dropLocationController.text} | Lat: $dropLat | Lng: $dropLng",
                              );
                              if (showSecondDrop) {
                                print(
                                  "Drop2: ${secondDropController.text} | Lat: $drop2Lat | Lng: $drop2Lng",
                                );
                              }
                              Navigator.pop(context, {
                                "current": currentLocationController.text,
                                "drop": dropLocationController.text,
                                "drop2": secondDropController.text,
                                "pickupLat": pickupLat,
                                "pickupLng": pickupLng,
                                "dropLat": dropLat,
                                "dropLng": dropLng,
                                "drop2Lat": drop2Lat,
                                "drop2Lng": drop2Lng,
                              });
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          (currentLocationController.text.isNotEmpty &&
                                  dropLocationController.text.isNotEmpty &&
                                  (!showSecondDrop ||
                                      secondDropController.text.isNotEmpty))
                              ? korangeColor
                              : Colors
                                  .grey
                                  .shade600, // grey if fields not filled
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
                    child: const CustomText(
                      text: "Done",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textcolor: kwhiteColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),
            Expanded(
              child:
                  predictions.isNotEmpty
                      ? ListView.builder(
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          var p = predictions[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: korangeColor,
                            ),
                            title: Text(
                              p.fullText ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () => _onSuggestionTap(p),
                          );
                        },
                      )
                      : const Center(
                        child: Text("Start typing to see suggestions..."),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalLine({bool extended = false}) {
    return Container(
      width: 2,
      height: extended ? 100 : 50,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}





//  previous code //
// InkWell(
                //   onTap: () => _openMap(isPickupSelection),

                //   child: Container(
                //     height: 40,
                //     padding: const EdgeInsets.symmetric(
                //       vertical: 8,
                //       horizontal: 12,
                //     ),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       border: Border.all(color: korangeColor),
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(Icons.location_on, color: korangeColor, size: 18),
                //         SizedBox(width: 3),
                //         CustomText(
                //           text:
                //               isPickupSelection
                //                   ? "Select on map"
                //                   : "Select on map",
                //           fontSize: 14,
                //           fontWeight: FontWeight.w500,
                //           textcolor: korangeColor,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // inside your InkWell for "Select on map"
  // InkWell(
                //   onTap: () async {
                //     final result = await Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => MapPickScreen()),
                //     );

                //     if (result != null) {
                //       double latitude = result['latitude'];
                //       double longitude = result['longitude'];
                //       String locationName = result['locationName'];

                //       currentLocationController.text = locationName;

                //       final LatLng latLng = LatLng(
                //         lat: latitude,
                //         lng: longitude,
                //       );

                //       print("Selected Lat: ${latLng.lat}, Lng: ${latLng.lng}");
                //     }
                //   },
                //   child: const CustomText(
                //     text: "Select from map",
                //     fontSize: 14,
                //     fontWeight: FontWeight.w500,
                //     textcolor: korangeColor,
                //     underline: true,
                //     underlineColor: korangeColor,
                //   ),
                // ),

                // previous code//
  // Future<void> _onChanged(String value, bool current) async {
  //   setState(() => isCurrent = current);
  //   if (value.isNotEmpty) {
  //     final result = await places.findAutocompletePredictions(value);
  //     setState(() {
  //       predictions = result.predictions;
  //     });
  //   } else {
  //     setState(() => predictions.clear());
  //   }
  // }

  // void _onSuggestionTap(AutocompletePrediction p) {
  //   setState(() {
  //     if (isCurrent) {
  //       currentLocationController.text = p.fullText ?? "";
  //     } else {
  //       dropLocationController.text = p.fullText ?? "";
  //     }
  //     predictions.clear();
  //   });
  // }

  // Future<void> _openMap(bool isPickup) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder:
  //           (_) => MapPickScreen(
  //             isPickup: isPickup,
  //             previousLatLng:
  //                 isPickup && pickupLat.isNotEmpty
  //                     ? gmaps.LatLng(
  //                       double.parse(pickupLat),
  //                       double.parse(pickupLng),
  //                     )
  //                     : (!isPickup && dropLat.isNotEmpty
  //                         ? gmaps.LatLng(
  //                           double.parse(dropLat),
  //                           double.parse(dropLng),
  //                         )
  //                         : null),
  //             previousLocationName:
  //                 isPickup
  //                     ? currentLocationController.text
  //                     : dropLocationController.text,
  //           ),
  //     ),
  //   );

  //   if (result != null) {
  //     setState(() {
  //       if (isPickup) {
  //         // Pickup selected, store values
  //         currentLocationController.text = result['locationName'];
  //         pickupLat = result['latitude'].toString();
  //         pickupLng = result['longitude'].toString();

  //         // Switch to drop selection next
  //         isPickupSelection = false;
  //       } else {
  //         // Drop selected, store values
  //         dropLocationController.text = result['locationName'];
  //         dropLat = result['latitude'].toString();
  //         dropLng = result['longitude'].toString();

  //         // Optionally, reset to pickup for new selection
  //         isPickupSelection = true;
  //       }
  //     });
  //   }
  // }
