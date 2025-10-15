import 'package:flutter/material.dart';
import 'package:mana_driver/AppBar/notificationScreen.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

// class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CustomMainAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final vm = context.watch<LoginViewModel>();
//     // final userName =
//     //     "${vm.loggedInUser?['firstName'] ?? ''} ${vm.loggedInUser?['lastName'] ?? ''}"
//     //             .trim()
//     //             .isEmpty
//     //         ? "Guest"
//     //         : "${vm.loggedInUser?['firstName'] ?? ''} ${vm.loggedInUser?['lastName'] ?? ''}"
//     //             .trim();
//     final firstName = SharedPrefServices.getFirstName() ?? "";
//     final lastName = SharedPrefServices.getLastName() ?? "";
//     final userName =
//         "$firstName $lastName".trim().isEmpty
//             ? "Guest"
//             : "$firstName $lastName".trim();

//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       automaticallyImplyLeading: false,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1.0),
//         child: Container(color: Colors.grey.shade300, height: 1.0),
//       ),
//       title: Padding(
//         padding: const EdgeInsets.only(bottom: 10.0, top: 5),
//         child: Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const CustomText(
//                   text: "Namaskaram,",
//                   textcolor: kseegreyColor,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 CustomText(
//                   text: userName,
//                   textcolor: korangeColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 20,
//                 ),
//               ],
//             ),
//             const Spacer(),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => NotificationScreen()),
//                 );
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                   border: Border.all(
//                     color: KnotificationcircleColor,
//                     width: 0.5,
//                   ),
//                 ),
//                 child: Image.asset(
//                   'images/notification.png',
//                   width: 24,
//                   height: 24,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // ✅ allow custom title text

  const CustomMainAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      centerTitle: false, // left aligned
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(1.0),
      //   child: Container(color: Colors.grey.shade300, height: 1.0),
      // ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
