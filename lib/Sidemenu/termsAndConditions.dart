import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

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
                  text: 'Terms & Conditions',
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
            sectionTitle(localizations.termsConditionsTitle),

            const SizedBox(height: 20),

            sectionTitle(localizations.platformPurpose),
            const SizedBox(height: 10),
            bullet(localizations.platformPurposeDesc1),
            bullet(localizations.platformPurposeDesc2),

            const SizedBox(height: 20),

            sectionTitle(localizations.eligibility),
            const SizedBox(height: 10),
            bullet(localizations.eligibilityDesc1),
            bullet(localizations.eligibilityDesc2),
            bullet(localizations.eligibilityDesc3),

            const SizedBox(height: 20),

            sectionTitle(localizations.vehicleResponsibility),
            const SizedBox(height: 10),
            bullet(localizations.vehicleResponsibilityDesc1),
            bullet(localizations.vehicleResponsibilityDesc2),
            bullet(localizations.vehicleResponsibilityPoint1),
            bullet(localizations.vehicleResponsibilityPoint2),
            bullet(localizations.vehicleResponsibilityPoint3),

            const SizedBox(height: 20),

            sectionTitle(localizations.driverRelationship),
            const SizedBox(height: 10),
            bullet(localizations.driversIndependent),
            bullet(localizations.platformNotResponsibleDrivers),
            bullet(localizations.ownersFreeAcceptReject),

            const SizedBox(height: 20),

            sectionTitle(localizations.bookingTripDetails),
            const SizedBox(height: 10),
            bullet(localizations.ownersSelectTripType),
            bullet(localizations.pickupDropDurationInstructions),
            bullet(localizations.tripChangesAgreement),

            const SizedBox(height: 20),

            sectionTitle(localizations.payments),
            const SizedBox(height: 10),
            bullet(localizations.paymentDetailsShown),
            bullet(localizations.platformFacilitatesPayments),
            bullet(localizations.additionalChargesSettlement),

            const SizedBox(height: 20),

            sectionTitle(localizations.cancellations),
            const SizedBox(height: 10),
            bullet(localizations.repeatedCancellationsSuspension),
            bullet(localizations.cancellationChargesDisplayed),

            const SizedBox(height: 20),

            sectionTitle(localizations.safetyLiability),
            const SizedBox(height: 10),
            bullet(localizations.platformNotResponsibleSafety),
            bullet(localizations.insuranceClaimsHandledDirectly),
            bullet(localizations.ownersEnsureInsurance),

            const SizedBox(height: 20),

            sectionTitle(localizations.postTripInspection),
            const SizedBox(height: 10),
            bullet(localizations.ownerInspectVehicle),
            bullet(localizations.platformNotResponsible),
            bullet(localizations.notResponsibleBelongings),
            bullet(localizations.notResponsibleDamages),
            bullet(localizations.raiseIssueImmediately),
            bullet(localizations.complaintsNotEntertained),

            const SizedBox(height: 20),

            sectionTitle(localizations.prohibitedActivities),
            const SizedBox(height: 10),
            bullet(localizations.falseInformation),
            bullet(localizations.illegalActivities),
            bullet(localizations.misbehaveDrivers),
            bullet(localizations.violationAccountTermination),

            const SizedBox(height: 20),

            sectionTitle(localizations.ratingsFeedback),
            const SizedBox(height: 10),
            bullet(localizations.ownersProvideFeedback),
            bullet(localizations.fakeReviewsRestriction),

            const SizedBox(height: 20),

            sectionTitle(localizations.accountSuspensionTermination),
            const SizedBox(height: 10),
            bullet(localizations.platformSuspendTerminate),
            bullet(localizations.termsViolated),
            bullet(localizations.fraudulentActivityDetected),
            bullet(localizations.repeatedComplaintsReceived),

            const SizedBox(height: 20),

            sectionTitle(localizations.dataUsagePrivacy),
            const SizedBox(height: 10),
            bullet(localizations.ownerDataServicePurpose),
            bullet(localizations.personalInfoSharedLaw),

            const SizedBox(height: 20),

            sectionTitle(localizations.changesToTerms),
            const SizedBox(height: 10),
            bullet(localizations.platformModifyTerms),
            bullet(localizations.continuedUseAcceptance),

            const SizedBox(height: 20),

            sectionTitle(localizations.acceptance),
            const SizedBox(height: 10),
            bullet(localizations.ownerAcceptance),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
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

Widget sectionTitle(String text) {
  return CustomText(
    text: text,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    textcolor: KblackColor,
  );
}
