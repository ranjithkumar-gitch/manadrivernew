import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/AppBar/notificationScreen.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customoutlinedbutton.dart';

class DAppbar extends StatefulWidget implements PreferredSizeWidget {
  const DAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  State<DAppbar> createState() => _DAppbarState();
}

class _DAppbarState extends State<DAppbar> {
  bool isOnline = false;
  void _loadOnlineStatus() async {
    final status = await SharedPrefServices.getisOnline();
    setState(() {
      isOnline = status;
    });
  }

  void _showOnlineDialog() {
    final nextStatus = isOnline ? "Offline" : "Online";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              'Are you sure you want to be   $nextStatus?',
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
                CustomCancelButton(
                  text: 'No',
                  onPressed: () => Navigator.pop(context),
                ),

                CustomButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    setState(() {
                      isOnline = !isOnline;
                    });

                    await SharedPrefServices.setisOnline(isOnline);

                    await _updateOnlineStatusOnServer(isOnline);
                  },

                  text: 'Yes',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateOnlineStatusOnServer(bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(SharedPrefServices.getDocId())
          .update({'isOnline': status});
    } catch (e) {
      print("Failed to update server: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadOnlineStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: kwhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Builder(
                builder:
                    (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: KblackColor, width: 1),
                        ),
                        child: Image.asset(
                          "images/Menu_D.png",
                          color: KblackColor,
                        ),
                      ),
                    ),
              ),

              const Spacer(),

              // Online/Offline Switch
              GestureDetector(
                onTap: () {
                  _showOnlineDialog();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 100,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        isOnline ? Colors.green.shade400 : Colors.red.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment:
                            isOnline
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          width: 30,
                          height: 32,
                          decoration: BoxDecoration(
                            color: kwhiteColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          isOnline ? "Online" : "Offline",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Help Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: KblackColor, width: 1),
                ),
                child: Image.asset("images/contactUs.png", color: KblackColor),
              ),

              const SizedBox(width: 12),

              // Notification Icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: KblackColor, width: 1),
                  ),
                  child: Image.asset(
                    'images/notification_D.png',
                    color: KblackColor,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          const Divider(),
        ],
      ),
    );
  }
}
