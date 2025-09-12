import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future<void> _addAddressDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) async {
    await showDialog(
      context: context,
      builder: (ctx) {
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
            width: MediaQuery.of(context).size.width * 0.9, // wider
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
                    CustomTextField(controller: cityCtrl, labelText: "City"),

                    CustomTextField(controller: stateCtrl, labelText: "State"),
                    CustomTextField(
                      controller: countryCtrl,
                      labelText: "Country",
                    ),
                    CustomTextField(
                      controller: zipCtrl,
                      labelText: "Zipcode",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 45,
              child: CustomButton(
                text: "Add",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance
                        .collection("addresses")
                        .add({
                          "title": titleCtrl.text,
                          "Address": addressCtrl.text,

                          "state": stateCtrl.text,
                          "city": cityCtrl.text,
                          "country": countryCtrl.text,
                          "zipcode": zipCtrl.text,
                          "createdAt": FieldValue.serverTimestamp(),
                        });

                    titleCtrl.clear();
                    addressCtrl.clear();
                    stateCtrl.clear();
                    cityCtrl.clear();
                    countryCtrl.clear();
                    zipCtrl.clear();

                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
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
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return CustomText(
                text: "No addresses added yet",
                textcolor: kseegreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
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
                        onSelected: (value) async {
                          if (value == "delete") {
                            await FirebaseFirestore.instance
                                .collection("addresses")
                                .doc(docs[index].id)
                                .delete();
                          }
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
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
