import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Vehicles/add_new_vehicle.dart';
import 'package:mana_driver/Vehicles/vehicle_details.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class MyVehicle extends StatefulWidget {
  const MyVehicle({super.key});

  @override
  State<MyVehicle> createState() => _MyVehicleState();
}

class _MyVehicleState extends State<MyVehicle> {
  List<Map<String, dynamic>> carList = [];

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("vehicles")
              .where('userId', isEqualTo: SharedPrefServices.getUserId())
              .get();

      List<Map<String, dynamic>> loadedCars =
          snapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

      setState(() {
        carList = loadedCars;
      });
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    }
  }

  Future<void> _deleteCar(String id) async {
    try {
      await FirebaseFirestore.instance.collection("vehicles").doc(id).delete();
      _fetchCars();
    } catch (e) {
      debugPrint("Error deleting car: $e");
    }
  }

  bool isLoading = false;
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
                  text: "My Vehicles",
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : carList.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'No Vehicles Found',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textcolor: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    CustomText(
                      text: 'Recent Added Cars',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      textcolor: KblackColor,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text:
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      textcolor: kgreyColor,
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                        itemCount: carList.length,
                        itemBuilder: (context, index) {
                          final car = carList[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print(car['id']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => VehicleDetailsScreen(
                                            data: car,
                                            docId: car['id'],
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: KdeviderColor,
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            color: Colors.grey.shade100,
                                          ),
                                          child: Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child:
                                                  car['images'].isNotEmpty
                                                      ? Image.network(
                                                        car['images'][0],
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Image.asset(
                                                            "images/car.png",
                                                            height: 100,
                                                            width: 100,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      )
                                                      : Image.asset(
                                                        "images/car.png",
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text:
                                                    '${car['brand']} ${car['model']}',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                textcolor: KblackColor,
                                              ),
                                              const SizedBox(height: 5),
                                              Wrap(
                                                spacing: 6,
                                                children: [
                                                  _infoChip(
                                                    car['transmission'],
                                                  ),
                                                  _infoChip(car['fuelType']),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              _infoChip(car['vehicleNumber']),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _showLogoutDialog(context, car);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (index == carList.length - 1)
                                const SizedBox(height: 100),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 220,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: korangeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNewVehicle()),
            ).then((_) => _fetchCars());
          },
          child: CustomText(
            text: "Add New Vehicle",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textcolor: kwhiteColor,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, Map<String, dynamic> car) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Are you sure you want to delete this vehicle ?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "inter",
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: korangeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: korangeColor, fontFamily: "inter"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteCar(car['id']);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigation(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: korangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white, fontFamily: "inter"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: KdeviderColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: CustomText(
        text: text,
        fontSize: 10,
        fontWeight: FontWeight.w300,
        textcolor: KblackColor,
      ),
    );
  }
}

class CarModel {
  final String id;
  final List<String> images;
  final String model;
  final String brand;
  final String transmission;
  final String fuelType;
  final String category;

  CarModel({
    required this.id,
    required this.images,
    required this.model,
    required this.brand,
    required this.transmission,
    required this.fuelType,
    required this.category,
  });
}



// import 'package:flutter/material.dart';
// import 'package:mana_driver/Vehicles/add_new_vehicle.dart';
// import 'package:mana_driver/Vehicles/vehicle_details.dart';
// import 'package:mana_driver/Widgets/colors.dart';
// import 'package:mana_driver/Widgets/customText.dart';

// class Myvehicle extends StatefulWidget {
//   const Myvehicle({super.key});

//   @override
//   State<Myvehicle> createState() => _MyvehicleState();
// }

// class _MyvehicleState extends State<Myvehicle> {
//   List<CarModel> carList = [
//     CarModel(
//       imagePath: 'images/swift.png',
//       name: 'Maruti Swift Dzire VXI',
//       // kmsDriven: '76,225 km',
//       transmission: 'Manual',
//       fuelType: 'Petrol',
//       // price: '₹7,957',
//     ),
//     CarModel(
//       imagePath: 'images/mahindra.png',
//       name: 'Mahindra MARAZZO M2 7STR',
//       // kmsDriven: '45,120 km',
//       transmission: 'Automatic',
//       fuelType: 'Diesel',
//       // price: '₹9,995',
//     ),
//     CarModel(
//       imagePath: 'images/tata.png',
//       name: 'Tata Nexon XZ+',
//       // kmsDriven: '60,000 km',
//       transmission: 'Manual',
//       fuelType: 'Petrol',
//       // price: '₹9,100',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(color: Colors.grey.shade300, height: 1.0),
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(bottom: 10.0, top: 5),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Image.asset(
//                     "images/chevronLeft.png",
//                     width: 24,
//                     height: 24,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: CustomText(
//                   text: "My Vehicles",
//                   textcolor: KblackColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 22,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             CustomText(
//               text: 'Recent Added Cars',
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               textcolor: KblackColor,
//             ),
//             const SizedBox(height: 5),
//             CustomText(
//               text:
//                   'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
//               fontSize: 12,
//               fontWeight: FontWeight.w300,
//               textcolor: kgreyColor,
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: carList.length,
//                 itemBuilder: (context, index) {
//                   final car = carList[index];
//                   return Column(
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: KdeviderColor, width: 1.2),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 width: 90,
//                                 height: 90,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   color: Colors.grey.shade100,
//                                 ),
//                                 child: Center(
//                                   child: Image.asset(
//                                     car.imagePath,
//                                     height: 100,
//                                     width: 100,
//                                     fit: BoxFit.contain,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     CustomText(
//                                       text: car.name,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       textcolor: KblackColor,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Wrap(
//                                       spacing: 6,
//                                       children: [
//                                         // _infoChip(car.kmsDriven),
//                                         _infoChip(car.transmission),
//                                         _infoChip(car.fuelType),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 15),
//                                     RichText(
//                                       text: TextSpan(
//                                         children: [
//                                           // TextSpan(
//                                           //   text: car.price,
//                                           //   style: TextStyle(
//                                           //     fontWeight: FontWeight.bold,
//                                           //     fontSize: 18,
//                                           //     color: korangeColor,
//                                           //   ),
//                                           // ),
//                                           // const TextSpan(
//                                           //   text: ' /per ride',
//                                           //   style: TextStyle(
//                                           //     fontSize: 14,
//                                           //     color: Colors.black,
//                                           //   ),
//                                           // ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // const Icon(Icons.arrow_forward_ios, size: 18),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       if (index == carList.length - 1)
//                         const SizedBox(height: 100),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: SizedBox(
//         width: 220,
//         height: 50,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: korangeColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(40),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AddNewVehicle()),
//             );
//           },
//           child: CustomText(
//             text: "Add New Vehicle",
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             textcolor: kwhiteColor,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _infoChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//       decoration: BoxDecoration(
//         color: KdeviderColor,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: CustomText(
//         text: text,
//         fontSize: 10,
//         fontWeight: FontWeight.w300,
//         textcolor: KblackColor,
//       ),
//     );
//   }
// }

// class CarModel {
//   final String imagePath;
//   final String name;
//   // final String kmsDriven;
//   final String transmission;
//   final String fuelType;
//   // final String price;

//   CarModel({
//     required this.imagePath,
//     required this.name,
//     // required this.kmsDriven,
//     required this.transmission,
//     required this.fuelType,
//     // required this.price,
//   });
// }