import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/Myrides.dart';
import 'package:mana_driver/Bottom_NavigationBar/homeScreen.dart';
import 'package:mana_driver/Bottom_NavigationBar/menuScreen.dart';
import 'package:mana_driver/Bottom_NavigationBar/transactionsScreen.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

class BottomNavigation extends StatefulWidget {
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MyRidesScreen(),
    TransactionsScreen(),
    MenuScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem(
    String label,
    String imagePath,
    int index,
  ) {
    final isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 32,
            height: 32,
            color: isSelected ? korangeColor : KbottomnaviconColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? korangeColor : KbottomnaviconColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          height: 95,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            items: [
              _buildNavItem(localizations.bottomNavHome, 'images/home.png', 0),
              _buildNavItem(
                localizations.bottomNavMyRides,
                'images/my_rides.png',
                1,
              ),
              _buildNavItem(
                localizations.bottomNavTransactions,
                'images/transactions.png',
                2,
              ),
              _buildNavItem(localizations.bottomNavMenu, 'images/menu.png', 3),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  'Do you want to exit the app ?',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: korangeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      exit(0);
                    },
                    child: Text(
                      'Exit',
                      style: GoogleFonts.poppins(
                        color: korangeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
        )) ??
        false;
  }
}
