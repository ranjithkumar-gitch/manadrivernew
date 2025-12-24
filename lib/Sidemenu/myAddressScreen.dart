import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';

import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/Widgets/customTextField.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  int selectedAddress = 0;
  String? formError;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController();
  final TextEditingController zipCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  String capitalizeFirst(String value) {
    if (value.trim().isEmpty) return value;
    return value.trim()[0].toUpperCase() +
        value.trim().substring(1).toLowerCase();
  }

  String capitalizeEachWord(String value) {
    return value
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  Future<void> _addAddressDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              backgroundColor: kwhiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: CustomText(
                text: localizations.add_new_Address,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textcolor: KblackColor,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: titleCtrl,
                          labelText: "Address Title",
                        ),
                        CustomTextField(
                          controller: addressCtrl,
                          labelText: "Address",
                        ),
                        CustomTextField(
                          controller: cityCtrl,
                          labelText: "City",
                        ),
                        CustomTextField(
                          controller: zipCtrl,
                          labelText: "Zipcode",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        CustomTextField(
                          controller: stateCtrl,
                          labelText: "State",
                        ),
                        CustomTextField(
                          controller: countryCtrl,
                          labelText: "Country",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                isLoading
                    ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(color: korangeColor),
                      ),
                    )
                    : SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: CustomButton(
                        text: "Add",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await FirebaseFirestore.instance
                                  .collection("addresses")
                                  .add({
                                    'userId':
                                        SharedPrefServices.getUserId()
                                            .toString(),

                                    "title": capitalizeEachWord(titleCtrl.text),
                                    "Address": capitalizeFirst(
                                      addressCtrl.text.trim(),
                                    ),

                                    "state": capitalizeFirst(stateCtrl.text),
                                    "city": capitalizeFirst(cityCtrl.text),
                                    "country": capitalizeFirst(
                                      countryCtrl.text,
                                    ),

                                    "zipcode": zipCtrl.text.trim(),
                                    "createdAt": FieldValue.serverTimestamp(),
                                  });

                              titleCtrl.clear();
                              addressCtrl.clear();
                              stateCtrl.clear();
                              cityCtrl.clear();
                              countryCtrl.clear();
                              zipCtrl.clear();

                              Navigator.pop(context);
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          }
                        },

                        // onPressed: () async {
                        //   if (_formKey.currentState!.validate()) {
                        //     setState(() {
                        //       isLoading = true;
                        //     });

                        //     try {
                        //       await FirebaseFirestore.instance
                        //           .collection("addresses")
                        //           .add({
                        //             'userId':
                        //                 SharedPrefServices.getUserId()
                        //                     .toString(),
                        //             "title": titleCtrl.text,
                        //             "Address": addressCtrl.text,
                        //             "state": stateCtrl.text,
                        //             "city": cityCtrl.text,
                        //             "country": countryCtrl.text,
                        //             "zipcode": zipCtrl.text,
                        //             "createdAt": FieldValue.serverTimestamp(),
                        //           });

                        //       titleCtrl.clear();
                        //       addressCtrl.clear();
                        //       stateCtrl.clear();
                        //       cityCtrl.clear();
                        //       countryCtrl.clear();
                        //       zipCtrl.clear();

                        //       Navigator.pop(context);
                        //     } catch (e) {
                        //       setState(() {
                        //         isLoading = false;
                        //       });
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(content: Text("Error: $e")),
                        //       );
                        //     }
                        //   }
                        // },
                      ),
                    ),
              ],
            );
          },
        );
      },
    );
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
                  text: localizations.menumyAddress,
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
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection("addresses")
                  .where(
                    'userId',
                    isEqualTo: SharedPrefServices.getUserId().toString(),
                  )
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(
                child: CustomText(
                  text: "No address added yet",
                  textcolor: kseegreyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: KaddresscardborderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: selectedAddress,
                        activeColor: korangeColor,
                        onChanged: (value) {
                          setState(() {
                            selectedAddress = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: data["title"] ?? "Address",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textcolor: korangeColor,
                            ),
                            CustomText(
                              text:
                                  "${data["Address"]},${data["city"]},${data["state"]},${data["country"]} - ${data["zipcode"]}",
                              textcolor: kseegreyColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),

                      PopupMenuButton<String>(
                        color: kwhiteColor,
                        onSelected: (value) {
                          if (value == "delete") {
                            deleteDialog(context, docs[index].id);
                          }
                        },
                        itemBuilder:
                            (context) => const [
                              PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              ),
                            ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: CustomButton(
            onPressed: () => _addAddressDialog(context, localizations),
            text: localizations.add_new_Address,
          ),
        ),
      ),
    );
  }
}

void deleteDialog(BuildContext context, String docId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Are you sure you want to delete this address?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: "inter",
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
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("addresses")
                      .doc(docId)
                      .delete();

                  Navigator.pop(context); // close dialog
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
