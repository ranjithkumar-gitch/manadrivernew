import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:mana_driver/Location/map_screen.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mana_driver/l10n/app_localizations.dart';

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

  String? distanceText;
  String? durationText;

  bool showSecondDrop = false;
  TextEditingController secondDropController = TextEditingController();
  FocusNode secondDropFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    places = FlutterGooglePlacesSdk("AIzaSyDMihIxRDdcdyNby8aKMLIwsBFGLGuhLFI");
  }

  Future<void> _calculateDistance() async {
    if (pickupLat.isEmpty ||
        pickupLng.isEmpty ||
        dropLat.isEmpty ||
        dropLng.isEmpty) {
      print("coordinates missing");
      return;
    }

    const apiKey = "AIzaSyDMihIxRDdcdyNby8aKMLIwsBFGLGuhLFI";

    double totalDistanceMeters = 0;
    double totalDurationSeconds = 0;

    Future<void> fetchAndAddDistance(
      String originLat,
      String originLng,
      String destLat,
      String destLng,
    ) async {
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/distancematrix/json?"
        "origins=$originLat,$originLng&destinations=$destLat,$destLng&mode=driving&key=$apiKey",
      );

      print("Fetching segment: $originLat,$originLng → $destLat,$destLng");
      final response = await http.get(url);
      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["rows"] != null &&
            data["rows"].isNotEmpty &&
            data["rows"][0]["elements"] != null &&
            data["rows"][0]["elements"].isNotEmpty) {
          final element = data["rows"][0]["elements"][0];

          if (element["status"] == "OK") {
            totalDistanceMeters += element["distance"]["value"];
            totalDurationSeconds += element["duration"]["value"];
            print(
              " Distance: ${element["distance"]["text"]} | Duration: ${element["duration"]["text"]}",
            );
          } else {
            print("  status not OK: ${element["status"]}");
          }
        } else {
          print(" No valid elements returned from API");
        }
      } else {
        print(" Request failed with status: ${response.statusCode}");
      }
    }

    await fetchAndAddDistance(pickupLat, pickupLng, dropLat, dropLng);

    if (showSecondDrop && drop2Lat.isNotEmpty && drop2Lng.isNotEmpty) {
      await fetchAndAddDistance(dropLat, dropLng, drop2Lat, drop2Lng);
    }

    final totalKm = (totalDistanceMeters / 1000).toStringAsFixed(1);
    final totalMin = (totalDurationSeconds / 60).toStringAsFixed(0);

    setState(() {
      distanceText = "$totalKm km";
      durationText = "$totalMin mins";
    });

    print("Total Distance: $distanceText & Total Duration: $durationText");
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
      p.placeId,
      fields: [PlaceField.Location, PlaceField.Name],
    );

    final place = response.place;

    setState(() {
      if (isCurrent) {
        currentLocationController.text = p.fullText;
        pickupLat = place?.latLng?.lat.toString() ?? "";
        pickupLng = place?.latLng?.lng.toString() ?? "";
        isPickupSelection = false;
      } else {
        if (showSecondDrop && secondDropFocus.hasFocus) {
          secondDropController.text = p.fullText;
          drop2Lat = place?.latLng?.lat.toString() ?? "";
          drop2Lng = place?.latLng?.lng.toString() ?? "";
        } else {
          dropLocationController.text = p.fullText;
          dropLat = place?.latLng?.lat.toString() ?? "";
          dropLng = place?.latLng?.lng.toString() ?? "";
        }
      }
      // predictions.clear();
      predictions = [];
    });
    if (pickupLat.isNotEmpty && dropLat.isNotEmpty) {
      _calculateDistance();
    }
  }

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
      if (pickupLat.isNotEmpty && dropLat.isNotEmpty) {
        _calculateDistance();
      }
    }
  }

  //
  String convertMinutes(String durationText) {
    final cleaned = durationText.toLowerCase().replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    int minutes = int.tryParse(cleaned) ?? 0;

    if (minutes < 60) return "$minutes mins";

    int hrs = minutes ~/ 60;
    int mins = minutes % 60;

    if (mins == 0) {
      return "$hrs hr";
    } else {
      return "$hrs hr $mins mins";
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "images/chevronLeft.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: localizations.location,
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
                          decoration: InputDecoration(
                            hintText: localizations.pickupLocation,
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
                                // onPressed: () {
                                //   setState(() {
                                //     showSecondDrop = !showSecondDrop;
                                //     if (!showSecondDrop)
                                //       secondDropController.clear();
                                //   });
                                // },
                                onPressed: () async {
                                  setState(() {
                                    showSecondDrop = !showSecondDrop;

                                    if (!showSecondDrop) {
                                      secondDropController.clear();
                                      drop2Lat = "";
                                      drop2Lng = "";
                                    }
                                  });

                                  await _calculateDistance();
                                },

                                child: CustomText(
                                  text:
                                      showSecondDrop
                                          ? localizations.delete
                                          : localizations.add,
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
                          decoration: InputDecoration(
                            hintText:
                                showSecondDrop
                                    ? localizations.dropLocation1
                                    : localizations.dropLocation,
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
                            decoration: InputDecoration(
                              hintText: localizations.dropLocation2,
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
            if (distanceText != null && durationText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "${localizations.distance} $distanceText",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textcolor: Colors.black87,
                    ),
                    CustomText(
                      text:
                          "${localizations.time} ${convertMinutes(durationText!)}",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textcolor: Colors.black87,
                    ),
                  ],
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    bool isPickup = currentFocus.hasFocus;
                    bool isDrop = dropFocus.hasFocus;
                    bool isSecondDrop = secondDropFocus.hasFocus;
                    if (!isPickup && !isDrop && !isSecondDrop) {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              content: Text(
                                localizations.selectPickupOrDrop,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              title: Center(
                                child: Text(
                                  localizations.chooseLocationType,
                                  style: GoogleFonts.poppins(
                                    color: korangeColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    localizations.ok,
                                    style: GoogleFonts.poppins(
                                      color: korangeColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      );
                      return;
                    }

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
                                      ? localizations.selectDrop2OnMap
                                      : localizations.selectOnMap)
                                  : localizations.selectOnMap,
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
                              FocusManager.instance.primaryFocus?.unfocus();
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
                                "distance": distanceText ?? "",
                                "duration": durationText ?? "",
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
                              : Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
                    child: CustomText(
                      text: localizations.done,
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
                              p.fullText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () => _onSuggestionTap(p),
                          );
                        },
                      )
                      : Center(
                        child: Text(localizations.startTypingSuggestions),
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
