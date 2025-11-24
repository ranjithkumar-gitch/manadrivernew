import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

class PhoneNumberInputField extends StatelessWidget {
  final TextEditingController controller;
  final Country selectedCountry;
  final Function(Country) onCountryChanged;

  const PhoneNumberInputField({
    super.key,
    required this.controller,
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],

      style: GoogleFonts.poppins(
        color: KblackColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText:
            AppLocalizations.of(context)?.mobileNumber ?? 'Mobile Number',
        labelStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
        prefixIcon: GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: onCountryChanged,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${selectedCountry.flagEmoji} ",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 4),
                Text(
                  "+${selectedCountry.phoneCode}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: KblackColor,
                  ),
                ),
                const SizedBox(width: 8),
                Container(height: 30, width: 1, color: const Color(0xFFBDBDBD)),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD5D7DA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD5D7DA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 2),
        ),
      ),
    );
  }
}
