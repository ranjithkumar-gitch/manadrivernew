import 'package:flutter/material.dart';
import 'package:mana_driver/Driver/D_Appbar/d_appbar.dart';
import 'package:mana_driver/Driver/sidemenu/D_Sidemenu.dart';
import 'package:mana_driver/Widgets/colors.dart';

class D_Bookings extends StatefulWidget {
  const D_Bookings({super.key});

  @override
  State<D_Bookings> createState() => _D_BookingsState();
}

class _D_BookingsState extends State<D_Bookings> {
  int selectedIndex = 0; // selected button index
  final List<String> buttonLabels = ["Upcoming", "Ongoing", "Completed"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const D_SideMenu(),
      appBar: DAppbar(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Only Appbar row, not scaffold
              // const DAppbar(),
              const SizedBox(height: 16),

              // ✅ 3 buttons (scrollable)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(buttonLabels.length, (index) {
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child:
                          isSelected
                              ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: korangeColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Text(
                                  buttonLabels[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                              : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: korangeColor),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Text(
                                  buttonLabels[index],
                                  style: const TextStyle(color: korangeColor),
                                ),
                              ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Your Bookings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: KblackColor,
                ),
              ),

              const SizedBox(height: 16),

              // ✅ List of cards
              _vehicleCard(),
              const SizedBox(height: 12),
              _vehicleCard(),
              const SizedBox(height: 12),
              _vehicleCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: kbordergreyColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade100,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://via.placeholder.com/150",
                        fit: BoxFit.cover,
                        width: 130,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.car_crash),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Toyota Corolla",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: KblackColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 6,
                        children: [
                          _infoChip("Automatic"),
                          _infoChip("Petrol"),
                          _infoChip("Sedan"),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _infoChip("MH12AB1234"),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KredColor),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 12,
                        color: KredColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KbtngreenColor,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: kwhiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ chip widget
Widget _infoChip(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade200,
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 10, color: Colors.black54),
    ),
  );
}
