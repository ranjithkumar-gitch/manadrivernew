// import 'package:flutter/material.dart';
// import 'package:mana_driver/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';

// import 'package:mana_driver/SharedPreferences/shared_preferences.dart';

// import 'package:mana_driver/Widgets/colors.dart';
// import 'package:mana_driver/Widgets/customButton.dart';
// import 'package:mana_driver/Widgets/customText.dart';
// import 'package:mana_driver/Widgets/customTextField.dart';
// import 'package:mana_driver/l10n/app_localizations.dart';

// class AddBankAccount extends StatefulWidget {
//   const AddBankAccount({super.key});

//   @override
//   State<AddBankAccount> createState() => _AddBankAccountState();
// }

// class _AddBankAccountState extends State<AddBankAccount> {
//   bool isAgreed = false;
//   final TextEditingController firstnameController = TextEditingController();
//   final TextEditingController lastnameController = TextEditingController();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadUserFromPrefs();
//   }

//   Future<void> _loadUserFromPrefs() async {
//     firstnameController.text = await SharedPrefServices.getFirstName() ?? '';
//     lastnameController.text = await SharedPrefServices.getLastName() ?? '';
//     emailController.text = await SharedPrefServices.getEmail() ?? '';
//     phoneController.text = await SharedPrefServices.getNumber() ?? '';

//     setState(() {}); // update UI after assigning
//   }

//   String _getUserInitials() {
//     final first = SharedPrefServices.getFirstName();
//     final last = SharedPrefServices.getLastName();

//     String firstInitial = first!.isNotEmpty ? first[0].toUpperCase() : '';
//     String lastInitial = last!.isNotEmpty ? last[0].toUpperCase() : '';

//     return firstInitial + lastInitial;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;
//     return Scaffold(
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
//                   text: "Add Bank Account",
//                   textcolor: KblackColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 22,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),

//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               CustomTextField(
//                 controller: firstnameController,
//                 readOnly: false,
//                 labelText: "Account Holder Name",
//               ),

//               const SizedBox(height: 10),
//               CustomTextField(
//                 controller: lastnameController,
//                 readOnly: false,
//                 labelText: "Account number",
//               ),

//               const SizedBox(height: 10),

//               CustomTextField(
//                 controller: emailController,
//                 labelText: "IFSC code",
//                 readOnly: false,
//               ),

//               const SizedBox(height: 10),

//               CustomTextField(
//                 controller: phoneController,
//                 labelText: "Bank Name",
//                 readOnly: false,
//               ),
//               const SizedBox(height: 10),

//               CustomTextField(
//                 controller: phoneController,
//                 labelText: "Branch Name",
//                 readOnly: false,
//               ),
//               const SizedBox(height: 10),

//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Checkbox(
//                     value: isAgreed,
//                     onChanged: (value) {
//                       setState(() {
//                         isAgreed = value ?? false;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       "I agree to the collection and use of my information as described in the Privacy Policy.",
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 50),
//               Center(
//                 child: CustomButton(
//                   text: "Continue",
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => D_BottomNavigation()),
//                     );
//                   },
//                   width: 220,
//                   height: 53,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:mana_driver/Driver/D_Models/Driver_Model.dart';
import 'package:mana_driver/Driver/D_Models/Driver_ViewModel.dart';
import 'package:mana_driver/Driver/Widgets/D_customTextfield.dart';
import 'package:mana_driver/Login/loginScreen.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/Widgets/customTextField.dart';
import 'package:provider/provider.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({super.key});

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  bool isAgreed = false;
  final TextEditingController holderController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: const Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 5),
          child: CustomText(
            text: "Add Bank Account",
            textcolor: KblackColor,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              D_CustomTextField(
                controller: holderController,
                labelText: "Account Holder Name",
              ),
              const SizedBox(height: 10),
              D_CustomTextField(
                controller: accountController,
                labelText: "Account Number",
              ),
              const SizedBox(height: 10),
              D_CustomTextField(
                controller: ifscController,
                labelText: "IFSC Code",
              ),
              const SizedBox(height: 10),
              D_CustomTextField(
                controller: bankController,
                labelText: "Bank Name",
              ),
              const SizedBox(height: 10),
              D_CustomTextField(
                controller: branchController,
                labelText: "Branch Name",
              ),

              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isAgreed,
                    onChanged:
                        (value) => setState(() => isAgreed = value ?? false),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "I agree to the collection and use of my information as described in the Privacy Policy.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Center(
              //   child: CustomButton(
              //     text: "Submit",
              //     onPressed: () async {
              //       if (!isAgreed) {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(
              //             content: Text("Please accept privacy policy"),
              //           ),
              //         );
              //         return;
              //       }

              //       vm.driver.bankAccount = BankAccount(
              //         holderName: holderController.text,
              //         accountNumber: accountController.text,
              //         ifsc: ifscController.text,
              //         bankName: bankController.text,
              //         branch: branchController.text,
              //       );

              //       await vm.saveDriver();

              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(builder: (_) => D_BottomNavigation()),
              //       );
              //     },
              //     width: 220,
              //     height: 53,
              //   ),
              // ),
              Center(
                child: SizedBox(
                  width: 220,
                  height: 53,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!isAgreed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please accept privacy policy"),
                          ),
                        );
                        return;
                      }

                      // Save bank account info in DriverViewModel
                      vm.driver.bankAccount = BankAccount(
                        holderName: holderController.text,
                        accountNumber: accountController.text,
                        ifsc: ifscController.text,
                        bankName: bankController.text,
                        branch: branchController.text,
                      );

                      await vm.saveDriver();

                      // Navigate to bottom navigation
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: korangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70),
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              if (vm.isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
