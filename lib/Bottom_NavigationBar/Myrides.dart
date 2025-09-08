import 'package:flutter/material.dart';
import 'package:mana_driver/AppBar/appBar.dart';
import 'package:mana_driver/Widgets/colors.dart';

import 'package:mana_driver/Widgets/customText.dart';

class MyRidesScreen extends StatefulWidget {
  @override
  _MyRidesScreenState createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });
  }

  Widget buildTab(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Tab(
      child: Container(
        width: 134,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFF6B00) : Color(0xFFF3F4F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textcolor: isSelected ? Color(0xFFFFFFFF) : Color(0xFF9AA9BA),
          ),
        ),
      ),
    );
  }

  Widget buildCard(String status, String date, String time, String price) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      color: kwhiteColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: KcardborderColor, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('images/user.png'),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.asset(
                            'images/verified.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Rajesh Kumar",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textcolor: korangeColor,
                      ),
                      Row(
                        children: [
                          Image.asset('images/star.png'),
                          SizedBox(width: 3),

                          CustomText(
                            text: "4.8",
                            textcolor: kseegreyColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      CustomText(
                        text: "Maruti Suzuki Swift-3940",
                        textcolor: kseegreyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        status == "Completed"
                            ? Color(0xFFB9FFD6)
                            : Color(0xFFC9DFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color:
                          status == "Completed"
                              ? Color(0xFF00D458)
                              : Color(0xFF1D9BF0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: KdeviderColor),
            const SizedBox(height: 8),

            Row(
              children: [
                Image.asset('images/calender.png'),
                const SizedBox(width: 5),
                Text(date, style: TextStyle(color: kseegreyColor)),
                const SizedBox(width: 12),
                Container(height: 20, width: 1, color: kseegreyColor),
                const SizedBox(width: 12),
                Text(time, style: TextStyle(color: kseegreyColor)),
                Spacer(),
                CustomText(
                  text: price,
                  textcolor: korangeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  //
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomMainAppBar(),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Material(
                color: Colors.white,
                elevation: 0,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  tabs: [
                    buildTab("All", 0),
                    buildTab("Upcoming", 1),
                    buildTab("Completed", 2),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: [
                    buildCard("Upcoming", "July 25, 2025", "3:00 PM", "₹500/-"),
                    buildCard(
                      "Completed",
                      "July 22, 2025",
                      "5:30 PM",
                      "₹750/-",
                    ),
                  ],
                ),
                ListView(
                  children: [
                    buildCard("Upcoming", "28 July 2025", "11:00 AM", "₹600"),
                  ],
                ),
                ListView(
                  children: [
                    buildCard("Completed", "20 July 2025", "1:45 PM", "₹400"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
