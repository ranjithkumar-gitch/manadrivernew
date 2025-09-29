import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class MapPickScreen extends StatefulWidget {
  final bool isPickup;
  final bool isSecondDrop;

  final String? previousLocationName;
  final LatLng? previousLatLng;

  const MapPickScreen({
    super.key,
    required this.isPickup,
    required this.isSecondDrop,
    this.previousLocationName,
    this.previousLatLng,
  });

  @override
  State<MapPickScreen> createState() => _MapPickScreenState();
}

class _MapPickScreenState extends State<MapPickScreen> {
  LatLng? pickedLocation;
  late GoogleMapController mapController;
  bool isMapReady = false;

  String locationName = "Fetching address...";

  late TextEditingController latLngController;
  late TextEditingController locationNameController;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    latLngController = TextEditingController();
    locationNameController = TextEditingController();
    searchController = TextEditingController();

    if (widget.previousLatLng != null) {
      pickedLocation = widget.previousLatLng;
      latLngController.text =
          "${pickedLocation!.latitude}, ${pickedLocation!.longitude}";
      locationNameController.text = widget.previousLocationName ?? "";
    } else {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    latLngController.dispose();
    locationNameController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        pickedLocation = currentLatLng;
        latLngController.text =
            "${pickedLocation!.latitude}, ${pickedLocation!.longitude}";
      });
      _getAddressFromLatLng(currentLatLng);

      if (isMapReady) {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, 15),
        );
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          locationName =
              "${place.name}, ${place.locality}, ${place.administrativeArea}";
          locationNameController.text = locationName;
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
      setState(() {
        locationName = "Unknown location";
        locationNameController.text = locationName;
      });
    }
  }

  bool isSearched = false;

  Future<void> _searchLocation() async {
    String query = searchController.text.trim();
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        LatLng newLatLng = LatLng(loc.latitude, loc.longitude);

        setState(() {
          pickedLocation = newLatLng;
          latLngController.text =
              "${pickedLocation!.latitude}, ${pickedLocation!.longitude}";
        });

        if (isMapReady) {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(newLatLng, 15),
          );
        }

        _getAddressFromLatLng(newLatLng);
      }
    } catch (e) {
      debugPrint("Search error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Location not found")));
    }
  }

  void _onConfirm() {
    Navigator.pop(context, {
      "latitude": pickedLocation!.latitude,
      "longitude": pickedLocation!.longitude,
      "locationName": locationName,
      "isPickup": widget.isPickup,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          pickedLocation == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: pickedLocation!,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      mapController = controller;
                      isMapReady = true;
                      mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(pickedLocation!, 15),
                      );
                    },
                    onCameraMove: (position) {
                      pickedLocation = position.target;
                      latLngController.text =
                          "${pickedLocation!.latitude}, ${pickedLocation!.longitude}";
                    },
                    onCameraIdle: () {
                      if (pickedLocation != null) {
                        _getAddressFromLatLng(pickedLocation!);
                      }
                    },
                  ),

                  Positioned(
                    top: 70,
                    left: 12,
                    right: 12,
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search location here",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isSearched ? Icons.clear : Icons.search,
                              color: isSearched ? Colors.red : korangeColor,
                            ),
                            onPressed: () {
                              if (isSearched) {
                                searchController.clear();
                                setState(() {
                                  isSearched = false;
                                });
                                _getCurrentLocation();
                              } else {
                                _searchLocation();
                                setState(() {
                                  isSearched = true;
                                });
                              }
                            },
                          ),
                        ),
                        onSubmitted: (val) {
                          _searchLocation();
                          setState(() {
                            isSearched = true;
                          });
                        },
                      ),
                    ),
                  ),

                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: widget.isPickup ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 8,
                            ),
                          ),
                        ),
                        Container(width: 2.5, height: 12, color: Colors.black),
                        Container(
                          width: 15,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Buttons
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 290,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          child: CircleAvatar(
                            backgroundColor: korangeColor,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          child: CircleAvatar(
                            backgroundColor: korangeColor,
                            child: IconButton(
                              icon: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                              onPressed: _getCurrentLocation,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom sheet
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text:
                                widget.isPickup
                                    ? 'Select Pickup Location'
                                    : widget.isSecondDrop
                                    ? 'Select Drop 2 Location'
                                    : 'Select Drop Location',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            textcolor: Colors.black,
                          ),

                          const SizedBox(height: 16),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Location Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: locationNameController,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Latitude, Longitude",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: latLngController,
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: korangeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                              ),
                              child: CustomText(
                                text:
                                    widget.isPickup
                                        ? "Select Pickup"
                                        : widget.isSecondDrop
                                        ? "Select Drop 2"
                                        : "Select Drop",
                                fontSize: 16,
                                textcolor: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
