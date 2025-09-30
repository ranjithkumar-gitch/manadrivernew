import 'package:flutter/material.dart';

class D_Settinds extends StatefulWidget {
  const D_Settinds({super.key});

  @override
  State<D_Settinds> createState() => _D_SettindsState();
}

class _D_SettindsState extends State<D_Settinds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // disable default back button
        title: Stack(
          alignment: Alignment.center,
          children: [
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: InkWell(
            //     onTap: () => Navigator.pop(context),
            //     child: Image.asset(
            //       "images/chevronLeft.png",
            //       width: 24,
            //       height: 24,
            //     ),
            //   ),
            // ),
            Center(
              child: Text(
                "Settings",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(child: Text("Work in progress")),
    );
  }
}
