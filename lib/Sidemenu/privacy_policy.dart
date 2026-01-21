import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
                  text: 'Privacy Policy',
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: localizations.privacyPolicyTitle,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 10),

            CustomText(
              text: localizations.lastUpdated,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            CustomText(
              text: localizations.privacyIntro,

              fontWeight: FontWeight.w400,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 10),

            CustomText(
              text: localizations.privacyPolicyExplanation,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 25),

            sectionTitle(localizations.informationWeCollect),
            const SizedBox(height: 15),

            CustomText(
              text: localizations.personalInformation,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: localizations.weMayCollectFollowing,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet(localizations.fullName),
            bullet(localizations.mobileNumber),
            bullet(localizations.emailOptional),
            bullet(localizations.profilePhotoOptional),
            bullet(localizations.governmentIdDetails),
            bullet(localizations.vehicleDetails),

            const SizedBox(height: 15),

            CustomText(
              text: localizations.locationInformation,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet(localizations.realTimeLocation),
            bullet(localizations.pickupDropLocations),
            bullet(localizations.tripRoutesDistance),

            const SizedBox(height: 8),
            CustomText(
              text: localizations.locationCollectionNote,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            CustomText(
              text: localizations.usageDeviceInformation,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet(localizations.deviceModel),
            bullet(localizations.osVersion),
            bullet(localizations.appUsageData),
            bullet(localizations.ipAddress),
            bullet(localizations.crashLogs),

            const SizedBox(height: 20),

            CustomText(
              text: localizations.paymentInformation,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet(localizations.paymentStatus),
            bullet(localizations.transactionId),
            bullet(localizations.paymentMethodNote),

            const SizedBox(height: 20),

            sectionTitle(localizations.howWeUseInformation),
            const SizedBox(height: 5),
            CustomText(
              text: localizations.weUseYourInformationTo,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 5),
            bullet(localizations.connectOwnersDrivers),
            bullet(localizations.enableBookingsTrips),
            bullet(localizations.verifyDriverIdentity),
            bullet(localizations.processPaymentsRefunds),
            bullet(localizations.improveAppPerformance),
            bullet(localizations.communicateUpdatesAlerts),
            bullet(localizations.preventFraudMisuse),
            bullet(localizations.complyLegalObligations),

            const SizedBox(height: 20),

            sectionTitle(localizations.informationSharing),
            const SizedBox(height: 5),
            CustomText(
              text: localizations.noSellRentData,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 5),
            CustomText(
              text: localizations.weMayShareLimitedInfo,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 5),
            bullet(localizations.shareDriversOwners),
            bullet(localizations.sharePaymentGateways),
            bullet(localizations.shareCloudPartners),
            bullet(localizations.shareLawAuthorities),

            const SizedBox(height: 20),

            sectionTitle(localizations.dataStorageSecurity),
            const SizedBox(height: 10),
            bullet(localizations.dataStoredSecureServers),
            bullet(localizations.industryEncryptionUsed),
            bullet(localizations.accessLimitedAuthorized),
            bullet(localizations.regularSecurityAudits),
            CustomText(
              text: localizations.noSystemFullySecure,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            sectionTitle(localizations.userRights),
            const SizedBox(height: 10),
            CustomText(
              text: localizations.youHaveTheRightTo,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet(localizations.accessPersonalData),
            bullet(localizations.updateInformation),
            bullet(localizations.requestAccountDeletion),
            bullet(localizations.withdrawConsent),
            CustomText(
              text: localizations.accountDeletionNote,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            sectionTitle(localizations.dataRetention),
            const SizedBox(height: 10),
            bullet(localizations.dataRetainedAsNecessary),
            bullet(localizations.tripTransactionRetention),
            bullet(localizations.inactiveAccountsDeleted),

            const SizedBox(height: 20),

            sectionTitle(localizations.childrensPrivacy),
            const SizedBox(height: 10),
            bullet(localizations.notForUnder18),
            bullet(localizations.noMinorDataCollection),

            const SizedBox(height: 20),

            sectionTitle(localizations.thirdPartyServices),
            const SizedBox(height: 10),
            bullet(localizations.mayContainThirdPartyLinks),
            bullet(localizations.notResponsibleThirdPartyPrivacy),

            const SizedBox(height: 20),

            sectionTitle(localizations.platformDisclaimer),
            const SizedBox(height: 10),
            CustomText(
              text: localizations.platformOnly,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet(localizations.notTransportOperator),
            bullet(localizations.doesNotOwnVehicles),
            bullet(localizations.doesNotEmployDrivers),
            bullet(localizations.independentProviders),

            const SizedBox(height: 20),

            sectionTitle(localizations.policyChanges),
            const SizedBox(height: 10),
            bullet(localizations.policyMayUpdate),
            bullet(localizations.policyUpdatedVersions),
            bullet(localizations.policyContinuedUse),

            const SizedBox(height: 20),

            sectionTitle(localizations.contactUs),
            const SizedBox(height: 10),
            CustomText(
              text: localizations.privacyConcernsContact,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 10),
            CustomText(
              text: localizations.nyzoRideSupport,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _sendEmail(localizations.nyzoRideEmail),
              child: support(localizations.nyzoRideEmail, "Email:"),
            ),
            GestureDetector(
              onTap: () => _callNumber(localizations.nyzoRidePhone),
              child: support(localizations.nyzoRidePhone, "Phone:"),
            ),

            // GestureDetector(
            //   onTap: () => _sendEmail("hello@nyzoride.com"),
            //   child: support("hello@nyzoride.com", "Email:"),
            // ),
            // GestureDetector(
            //   onTap: () => _callNumber("9000464851"),
            //   child: support("9000464851", "Phone:"),
            // ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textcolor: KblackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget support(String text, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textcolor: Colors.black,
          ),
          const Text(" ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w600,
      fontSize: 15,
      textcolor: KblackColor,
    );
  }

  void _callNumber(String phone) async {
    phone = phone.replaceAll("+91", "").trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number not available.")),
      );
      return;
    }

    if (phone.length != 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid phone number.")));
      return;
    }

    final Uri callUri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unable to open dialer.")));
    }
  }

  void _sendEmail(String email) async {
    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid email address."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final Uri mailUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(mailUri)) {
      await launchUrl(mailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open email app.")),
      );
    }
  }
}
