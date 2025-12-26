import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mana Driver'**
  String get appTitle;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language.'**
  String get selectLanguageTitle;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue in your chosen language.'**
  String get selectLanguageSubtitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Mobile Number'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to get started we\'ll send you an OTP for verification.'**
  String get loginSubtitle;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'You don’t have an account? '**
  String get noAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOtp;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your OTP'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to '**
  String get otpSentTo;

  /// No description provided for @otpAutoFill.
  ///
  /// In en, this message translates to:
  /// **' this OTP will get auto entering'**
  String get otpAutoFill;

  /// No description provided for @didNotReceiveOtp.
  ///
  /// In en, this message translates to:
  /// **'You didn’t receive OTP? '**
  String get didNotReceiveOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @bottomNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavHome;

  /// No description provided for @bottomNavMyRides.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get bottomNavMyRides;

  /// No description provided for @bottomNavTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get bottomNavTransactions;

  /// No description provided for @bottomNavMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get bottomNavMenu;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Namaskaram'**
  String get greeting;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @enterPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter pickup location'**
  String get enterPickupLocation;

  /// No description provided for @dropLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop Location'**
  String get dropLocation;

  /// No description provided for @enterDropLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter drop location'**
  String get enterDropLocation;

  /// No description provided for @dropLocation2.
  ///
  /// In en, this message translates to:
  /// **'Drop Location 2'**
  String get dropLocation2;

  /// No description provided for @enterDropLocation2.
  ///
  /// In en, this message translates to:
  /// **'Enter drop location 2'**
  String get enterDropLocation2;

  /// No description provided for @bookADriver.
  ///
  /// In en, this message translates to:
  /// **'Book A Driver'**
  String get bookADriver;

  /// No description provided for @myVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehicles;

  /// No description provided for @viewVehicles.
  ///
  /// In en, this message translates to:
  /// **'View Vehicles'**
  String get viewVehicles;

  /// No description provided for @menumyAddress.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get menumyAddress;

  /// No description provided for @menuFavDrivers.
  ///
  /// In en, this message translates to:
  /// **'Favourite Drivers'**
  String get menuFavDrivers;

  /// No description provided for @menuUpdateMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Update Mobile Number'**
  String get menuUpdateMobileNumber;

  /// No description provided for @menuAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get menuAppLanguage;

  /// No description provided for @menuOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get menuOffers;

  /// No description provided for @menuReferaFriend.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend'**
  String get menuReferaFriend;

  /// No description provided for @menuTC.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get menuTC;

  /// No description provided for @menuHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get menuHelpSupport;

  /// No description provided for @menuCancelPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get menuCancelPolicy;

  /// No description provided for @menuAbtMD.
  ///
  /// In en, this message translates to:
  /// **'About Rydyn'**
  String get menuAbtMD;

  /// No description provided for @menuDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get menuDeleteAccount;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// No description provided for @menuEnterMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile'**
  String get menuEnterMobile;

  /// No description provided for @menuEnterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get menuEnterOTP;

  /// No description provided for @menuDontRecieved.
  ///
  /// In en, this message translates to:
  /// **'Don’t Received? '**
  String get menuDontRecieved;

  /// No description provided for @menuResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get menuResend;

  /// No description provided for @menuCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get menuCancel;

  /// No description provided for @menuUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get menuUpdate;

  /// No description provided for @menuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get menuDelete;

  /// No description provided for @menuSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get menuSave;

  /// No description provided for @menuSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get menuSaving;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address,'**
  String get address;

  /// No description provided for @dummy_adres.
  ///
  /// In en, this message translates to:
  /// **'St.No.98, Main Rd, Near JLN House Serilingampally, Kondapur,  500084'**
  String get dummy_adres;

  /// No description provided for @add_new_Address.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get add_new_Address;

  /// No description provided for @fav_dummy_text.
  ///
  /// In en, this message translates to:
  /// **'You don’t Favourite Drivers at the moment please try after sometime.'**
  String get fav_dummy_text;

  /// No description provided for @offer_dummy_text.
  ///
  /// In en, this message translates to:
  /// **'You don’t have offers at the moment. Please try again later.'**
  String get offer_dummy_text;

  /// No description provided for @rat_Txt1.
  ///
  /// In en, this message translates to:
  /// **'Refer to your friend and get Rewards of 100/-'**
  String get rat_Txt1;

  /// No description provided for @rat_Txt2.
  ///
  /// In en, this message translates to:
  /// **'Send an invitation to a friend'**
  String get rat_Txt2;

  /// No description provided for @rat_Txt3.
  ///
  /// In en, this message translates to:
  /// **'Your friend signup'**
  String get rat_Txt3;

  /// No description provided for @rat_Txt4.
  ///
  /// In en, this message translates to:
  /// **'You’ll both get cash when your friend first book a ride'**
  String get rat_Txt4;

  /// No description provided for @rat_Txt5.
  ///
  /// In en, this message translates to:
  /// **'Send a Invitation'**
  String get rat_Txt5;

  /// No description provided for @tDt1.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get tDt1;

  /// No description provided for @tD_D1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our app. By using this application, you agree to the following terms and conditions.'**
  String get tD_D1;

  /// No description provided for @tDt2.
  ///
  /// In en, this message translates to:
  /// **'2. User Obligations'**
  String get tDt2;

  /// No description provided for @tD_D2.
  ///
  /// In en, this message translates to:
  /// **'Users must ensure all information provided is accurate and must not misuse the service.'**
  String get tD_D2;

  /// No description provided for @tDt3.
  ///
  /// In en, this message translates to:
  /// **'3. Account Security'**
  String get tDt3;

  /// No description provided for @tD_D3.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account credentials.'**
  String get tD_D3;

  /// No description provided for @tDt4.
  ///
  /// In en, this message translates to:
  /// **'4. Data Privacy'**
  String get tDt4;

  /// No description provided for @tD_D4.
  ///
  /// In en, this message translates to:
  /// **'We value your privacy. Your data is stored securely and handled as per our privacy policy.'**
  String get tD_D4;

  /// No description provided for @tDt5.
  ///
  /// In en, this message translates to:
  /// **'5. Intellectual Property'**
  String get tDt5;

  /// No description provided for @tD_D5.
  ///
  /// In en, this message translates to:
  /// **'All content in the app is protected by copyright and may not be reused without permission.'**
  String get tD_D5;

  /// No description provided for @tDt6.
  ///
  /// In en, this message translates to:
  /// **'6. Service Changes'**
  String get tDt6;

  /// No description provided for @tD_D6.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify or discontinue the service without notice.'**
  String get tD_D6;

  /// No description provided for @tDt7.
  ///
  /// In en, this message translates to:
  /// **'7. Termination'**
  String get tDt7;

  /// No description provided for @tD_D7.
  ///
  /// In en, this message translates to:
  /// **'We may suspend or terminate your access if you violate any terms outlined here.'**
  String get tD_D7;

  /// No description provided for @tDt8.
  ///
  /// In en, this message translates to:
  /// **'8. Third-party Links'**
  String get tDt8;

  /// No description provided for @tD_D8.
  ///
  /// In en, this message translates to:
  /// **'We may include links to third-party sites. We are not responsible for their content.'**
  String get tD_D8;

  /// No description provided for @tDt9.
  ///
  /// In en, this message translates to:
  /// **'9. Governing Law'**
  String get tDt9;

  /// No description provided for @tD_D9.
  ///
  /// In en, this message translates to:
  /// **'These terms shall be governed in accordance with the laws of your country or region.'**
  String get tD_D9;

  /// No description provided for @hS_t1.
  ///
  /// In en, this message translates to:
  /// **'How can I help you today?'**
  String get hS_t1;

  /// No description provided for @hS_t2.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get hS_t2;

  /// No description provided for @hS_t3.
  ///
  /// In en, this message translates to:
  /// **'For call'**
  String get hS_t3;

  /// No description provided for @hS_t4.
  ///
  /// In en, this message translates to:
  /// **'Send a mail'**
  String get hS_t4;

  /// No description provided for @cP_q1.
  ///
  /// In en, this message translates to:
  /// **'1. Free Cancellation Window'**
  String get cP_q1;

  /// No description provided for @cP_a1.
  ///
  /// In en, this message translates to:
  /// **'You can cancel your booking within 5 minutes of confirmation without any charges.'**
  String get cP_a1;

  /// No description provided for @cP_q2.
  ///
  /// In en, this message translates to:
  /// **'2. Cancellation After 5 Minutes'**
  String get cP_q2;

  /// No description provided for @cP_a2.
  ///
  /// In en, this message translates to:
  /// **'• 59 cancellation fee will be charged if:'**
  String get cP_a2;

  /// No description provided for @cP_a22.
  ///
  /// In en, this message translates to:
  /// **'• Driver already started the trip.'**
  String get cP_a22;

  /// No description provided for @cP_a23.
  ///
  /// In en, this message translates to:
  /// **'• Driver waited at your location for more than 10'**
  String get cP_a23;

  /// No description provided for @cP_q3.
  ///
  /// In en, this message translates to:
  /// **'3. No-Show Policy (Customer absent)'**
  String get cP_q3;

  /// No description provided for @cP_a3.
  ///
  /// In en, this message translates to:
  /// **'If customer is not available at pickup point even after 15 minutes, trip will be auto-cancelled. #100 will be charged as no-show'**
  String get cP_a3;

  /// No description provided for @cP_q4.
  ///
  /// In en, this message translates to:
  /// **'4. Driver Cancellation'**
  String get cP_q4;

  /// No description provided for @cP_a4.
  ///
  /// In en, this message translates to:
  /// **'If a driver cancels after accepting, we will reassign another driver. Repeated cancellations by drivers will lead to penalties and suspension.'**
  String get cP_a4;

  /// No description provided for @cP_q5.
  ///
  /// In en, this message translates to:
  /// **'5. Refund Timeline'**
  String get cP_q5;

  /// No description provided for @cP_a5.
  ///
  /// In en, this message translates to:
  /// **'If you paid online, eligible refunds will be processed within 3-5 business days.'**
  String get cP_a5;

  /// No description provided for @mDdisk.
  ///
  /// In en, this message translates to:
  /// **'Mana Driver - Mee Vahanam, Maa Driver!\nMana Driver is your trusted platform to book professional, verified drivers anytime you need. Whether it\'s a one-way ride, round trip, hourly booking, or outstation travel - we\'ve got you covered.'**
  String get mDdisk;

  /// No description provided for @dA_t1.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get dA_t1;

  /// No description provided for @dA_t2.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete your account?'**
  String get dA_t2;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @p_firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get p_firstName;

  /// No description provided for @p_lastName.
  ///
  /// In en, this message translates to:
  /// **'last Name'**
  String get p_lastName;

  /// No description provided for @p_email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get p_email;

  /// No description provided for @p_phoneNumner.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get p_phoneNumner;

  /// No description provided for @p_verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get p_verified;

  /// No description provided for @p_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get p_editProfile;

  /// No description provided for @home_viewoffers.
  ///
  /// In en, this message translates to:
  /// **'View Offers'**
  String get home_viewoffers;

  /// No description provided for @home_watch.
  ///
  /// In en, this message translates to:
  /// **'Watch & Learn'**
  String get home_watch;

  /// No description provided for @home_prem.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM FEEL FOR DRIVER SERVICES'**
  String get home_prem;

  /// No description provided for @home_india.
  ///
  /// In en, this message translates to:
  /// **'Made in India'**
  String get home_india;

  /// No description provided for @enterYourOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter Your OTP'**
  String get enterYourOtp;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent'**
  String get otpSent;

  /// No description provided for @otpNotReceived.
  ///
  /// In en, this message translates to:
  /// **'You didn\'t receive OTP? '**
  String get otpNotReceived;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loggedInReady.
  ///
  /// In en, this message translates to:
  /// **'You\'re now logged in and ready to go.'**
  String get loggedInReady;

  /// No description provided for @getStartedMinute.
  ///
  /// In en, this message translates to:
  /// **'It only takes a minute to get started.'**
  String get getStartedMinute;

  /// No description provided for @quickSimpleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Quick. Simple. Hassle-free registration.'**
  String get quickSimpleRegistration;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @emailId.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get emailId;

  /// No description provided for @registerAsUser.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAsUser;

  /// No description provided for @validFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid first name'**
  String get validFirstName;

  /// No description provided for @validLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid last name'**
  String get validLastName;

  /// No description provided for @validPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number for'**
  String get validPhoneNumber;

  /// No description provided for @mobileNumberExists.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number Exists'**
  String get mobileNumberExists;

  /// No description provided for @mobileRegisteredOwner.
  ///
  /// In en, this message translates to:
  /// **'This mobile number is already registered as an Owner.'**
  String get mobileRegisteredOwner;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @mobileRegisteredDriver.
  ///
  /// In en, this message translates to:
  /// **'This mobile number is already registered as a Driver.'**
  String get mobileRegisteredDriver;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'You have an account? '**
  String get haveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @welcomeRydyn.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rydyn!'**
  String get welcomeRydyn;

  /// No description provided for @registrationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your registration was successful. Please log in to continue.'**
  String get registrationSuccessMessage;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue'**
  String get pleaseLogin;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registrationSuccessful;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @dropLocation1.
  ///
  /// In en, this message translates to:
  /// **'Drop Location 1'**
  String get dropLocation1;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time:'**
  String get time;

  /// No description provided for @selectPickupOrDrop.
  ///
  /// In en, this message translates to:
  /// **'Please select Pickup or Drop location.'**
  String get selectPickupOrDrop;

  /// No description provided for @chooseLocationType.
  ///
  /// In en, this message translates to:
  /// **'Choose Location Type'**
  String get chooseLocationType;

  /// No description provided for @selectDrop2OnMap.
  ///
  /// In en, this message translates to:
  /// **'Select drop2 on map'**
  String get selectDrop2OnMap;

  /// No description provided for @selectOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select on map'**
  String get selectOnMap;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @startTypingSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Start typing to see suggestions...'**
  String get startTypingSuggestions;

  /// No description provided for @noVehiclesFound.
  ///
  /// In en, this message translates to:
  /// **'No Vehicles Found'**
  String get noVehiclesFound;

  /// No description provided for @recentAddedVehicles.
  ///
  /// In en, this message translates to:
  /// **'Recent Added Vehicles'**
  String get recentAddedVehicles;

  /// No description provided for @listAddedVehicles.
  ///
  /// In en, this message translates to:
  /// **'List of vehicles you added recently.'**
  String get listAddedVehicles;

  /// No description provided for @addNewVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add New Vehicle'**
  String get addNewVehicle;

  /// No description provided for @confirmDeleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle?'**
  String get confirmDeleteVehicle;

  /// No description provided for @addOnceUseEveryTime.
  ///
  /// In en, this message translates to:
  /// **'Add once, use every time'**
  String get addOnceUseEveryTime;

  /// No description provided for @uploadVehicleImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Vehicle Images'**
  String get uploadVehicleImages;

  /// No description provided for @vehicleBrand.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Brand'**
  String get vehicleBrand;

  /// No description provided for @selectBrand.
  ///
  /// In en, this message translates to:
  /// **'Select Brand'**
  String get selectBrand;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @selectModel.
  ///
  /// In en, this message translates to:
  /// **'Please select a model'**
  String get selectModel;

  /// No description provided for @vehicleCategory.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Category'**
  String get vehicleCategory;

  /// No description provided for @enterVehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Please enter a vehicle model'**
  String get enterVehicleModel;

  /// No description provided for @selectVehicleCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle category'**
  String get selectVehicleCategory;

  /// No description provided for @enterVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle number'**
  String get enterVehicleNumber;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// No description provided for @selectFuelType.
  ///
  /// In en, this message translates to:
  /// **'Please select fuel type'**
  String get selectFuelType;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @selectTransmission.
  ///
  /// In en, this message translates to:
  /// **'Please select transmission'**
  String get selectTransmission;

  /// No description provided for @acAvailable.
  ///
  /// In en, this message translates to:
  /// **'AC Available'**
  String get acAvailable;

  /// No description provided for @isAcAvailable.
  ///
  /// In en, this message translates to:
  /// **'Is AC Available?'**
  String get isAcAvailable;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// No description provided for @petrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get petrol;

  /// No description provided for @diesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get diesel;

  /// No description provided for @electric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get electric;

  /// No description provided for @cng.
  ///
  /// In en, this message translates to:
  /// **'CNG'**
  String get cng;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @semiAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Semi-Automatic'**
  String get semiAutomatic;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategory;

  /// No description provided for @validVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid vehicle number (e.g. TS05BY1234)'**
  String get validVehicleNumber;

  /// No description provided for @uploadAtLeastOneImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload at least 1 image'**
  String get uploadAtLeastOneImage;

  /// No description provided for @vehicleAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vehicle added successfully!'**
  String get vehicleAddedSuccess;

  /// No description provided for @pleaseSelectBrand.
  ///
  /// In en, this message translates to:
  /// **'Please select a brand'**
  String get pleaseSelectBrand;

  /// No description provided for @selectImageFrom.
  ///
  /// In en, this message translates to:
  /// **'Select Image From'**
  String get selectImageFrom;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @editVehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;

  /// No description provided for @updateVehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Update Vehicle Details'**
  String get updateVehicleDetails;

  /// No description provided for @vehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;

  /// No description provided for @deleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get deleteVehicle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @vehicleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted'**
  String get vehicleDeleted;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @exceptionalPerformance.
  ///
  /// In en, this message translates to:
  /// **'Exceptional performance and premium comfort features.'**
  String get exceptionalPerformance;

  /// No description provided for @keySpecifications.
  ///
  /// In en, this message translates to:
  /// **'Key Specifications'**
  String get keySpecifications;

  /// No description provided for @vehicleUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vehicle updated successfully!'**
  String get vehicleUpdatedSuccess;

  /// No description provided for @selectTripMode.
  ///
  /// In en, this message translates to:
  /// **'Select Trip mode'**
  String get selectTripMode;

  /// No description provided for @oneWay.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get oneWay;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTrip;

  /// No description provided for @hourlyTrip.
  ///
  /// In en, this message translates to:
  /// **'Hourly Trip'**
  String get hourlyTrip;

  /// No description provided for @hourlyFare.
  ///
  /// In en, this message translates to:
  /// **'Every 1 hr ₹ 129/-'**
  String get hourlyFare;

  /// No description provided for @chooseTripTime.
  ///
  /// In en, this message translates to:
  /// **'Choose Trip Time'**
  String get chooseTripTime;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @departureDateTime.
  ///
  /// In en, this message translates to:
  /// **'Departure Date & Time'**
  String get departureDateTime;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get selectDateTime;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @arrivalDateTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival Date & Time'**
  String get arrivalDateTime;

  /// No description provided for @arrivalDate.
  ///
  /// In en, this message translates to:
  /// **'Arrival Date'**
  String get arrivalDate;

  /// No description provided for @arrivalDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Arrival Date Required'**
  String get arrivalDateRequired;

  /// No description provided for @selectArrivalBeforeTime.
  ///
  /// In en, this message translates to:
  /// **'Please select the arrival date before choosing the arrival time.'**
  String get selectArrivalBeforeTime;

  /// No description provided for @invalidArrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Invalid Arrival Time'**
  String get invalidArrivalTime;

  /// No description provided for @arrivalAfterEta.
  ///
  /// In en, this message translates to:
  /// **'Arrival time must be after ETA'**
  String get arrivalAfterEta;

  /// No description provided for @arrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival Time'**
  String get arrivalTime;

  /// No description provided for @estimatedFare.
  ///
  /// In en, this message translates to:
  /// **'Estimated fare'**
  String get estimatedFare;

  /// No description provided for @viewBreakup.
  ///
  /// In en, this message translates to:
  /// **'View Breakup'**
  String get viewBreakup;

  /// No description provided for @selectPickupDrop.
  ///
  /// In en, this message translates to:
  /// **'Please select pickup & drop location'**
  String get selectPickupDrop;

  /// No description provided for @selectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle'**
  String get selectVehicle;

  /// No description provided for @arrivalDetailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Arrival Details Required'**
  String get arrivalDetailsRequired;

  /// No description provided for @arrivalDateTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select both arrival date and arrival time to continue.'**
  String get arrivalDateTimeRequired;

  /// No description provided for @driverRequestedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Requested a driver successfully'**
  String get driverRequestedSuccess;

  /// No description provided for @paymentBreakup.
  ///
  /// In en, this message translates to:
  /// **'Payment Breakup'**
  String get paymentBreakup;

  /// No description provided for @tripMode.
  ///
  /// In en, this message translates to:
  /// **'Trip Mode'**
  String get tripMode;

  /// No description provided for @servicePrice.
  ///
  /// In en, this message translates to:
  /// **'Service Price'**
  String get servicePrice;

  /// No description provided for @convenienceFee.
  ///
  /// In en, this message translates to:
  /// **'Convenience Fee'**
  String get convenienceFee;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Transactions Found'**
  String get noTransactionsFound;

  /// No description provided for @rideCancelled.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled'**
  String get rideCancelled;

  /// No description provided for @cancellationCharges.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Charges'**
  String get cancellationCharges;

  /// No description provided for @paymentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Payment Completed'**
  String get paymentCompleted;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed:'**
  String get paymentFailed;

  /// No description provided for @rideCompleted.
  ///
  /// In en, this message translates to:
  /// **'Ride Completed'**
  String get rideCompleted;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @newRide.
  ///
  /// In en, this message translates to:
  /// **'New Ride'**
  String get newRide;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noRidesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No rides available'**
  String get noRidesAvailable;

  /// No description provided for @vehicleNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'Vehicle not assigned'**
  String get vehicleNotAssigned;

  /// No description provided for @driverNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'Driver Not Assigned'**
  String get driverNotAssigned;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @cancelRide.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get cancelRide;

  /// No description provided for @confirmCancelRide.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this ride? This action cannot be undone.'**
  String get confirmCancelRide;

  /// No description provided for @cancelRideFree.
  ///
  /// In en, this message translates to:
  /// **'You can cancel this ride for FREE. Are you sure?'**
  String get cancelRideFree;

  /// No description provided for @cancelRideCharge.
  ///
  /// In en, this message translates to:
  /// **'Cancelling now will charge ₹59.\nDo you want to proceed?'**
  String get cancelRideCharge;

  /// No description provided for @pay59.
  ///
  /// In en, this message translates to:
  /// **'Pay ₹59'**
  String get pay59;

  /// No description provided for @couldNotOpenGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open Google Maps.'**
  String get couldNotOpenGoogleMaps;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied or not available.'**
  String get locationPermissionDenied;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @driverAssigned.
  ///
  /// In en, this message translates to:
  /// **'Driver Assigned'**
  String get driverAssigned;

  /// No description provided for @ride.
  ///
  /// In en, this message translates to:
  /// **'Ride'**
  String get ride;

  /// No description provided for @loadingDriver.
  ///
  /// In en, this message translates to:
  /// **'Loading driver...'**
  String get loadingDriver;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a review?'**
  String get writeReview;

  /// No description provided for @experienceQuestion.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get experienceQuestion;

  /// No description provided for @giveRating.
  ///
  /// In en, this message translates to:
  /// **'Give a rating'**
  String get giveRating;

  /// No description provided for @verificationCodeRide.
  ///
  /// In en, this message translates to:
  /// **'Verification code to start the ride'**
  String get verificationCodeRide;

  /// No description provided for @shareOtpDriver.
  ///
  /// In en, this message translates to:
  /// **'Share this OTP with your driver to start the ride.'**
  String get shareOtpDriver;

  /// No description provided for @fourDigitOtp.
  ///
  /// In en, this message translates to:
  /// **'4-Digit OTP'**
  String get fourDigitOtp;

  /// No description provided for @noCaptainsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No captains available'**
  String get noCaptainsAvailable;

  /// No description provided for @rideRequestReceived.
  ///
  /// In en, this message translates to:
  /// **'Ride request received'**
  String get rideRequestReceived;

  /// No description provided for @noCaptainsAccepted.
  ///
  /// In en, this message translates to:
  /// **'At the moment no captains accepted. Please cancel the ride below.'**
  String get noCaptainsAccepted;

  /// No description provided for @waitingForCaptains.
  ///
  /// In en, this message translates to:
  /// **'Waiting for captains to accept your ride'**
  String get waitingForCaptains;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left:'**
  String get timeLeft;

  /// No description provided for @routeInformation.
  ///
  /// In en, this message translates to:
  /// **'Route Information'**
  String get routeInformation;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @unableToOpenGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Unable to open Google Maps.'**
  String get unableToOpenGoogleMaps;

  /// No description provided for @errorOpeningDirections.
  ///
  /// In en, this message translates to:
  /// **'Error opening directions:'**
  String get errorOpeningDirections;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @cityLimit.
  ///
  /// In en, this message translates to:
  /// **'City Limit :'**
  String get cityLimit;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @slotDetails.
  ///
  /// In en, this message translates to:
  /// **'Slot Details'**
  String get slotDetails;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @driverDetails.
  ///
  /// In en, this message translates to:
  /// **'Driver Details'**
  String get driverDetails;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon Applied'**
  String get couponApplied;

  /// No description provided for @noReviewAvailable.
  ///
  /// In en, this message translates to:
  /// **'No review available'**
  String get noReviewAvailable;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating : '**
  String get rating;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback : '**
  String get feedback;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment : '**
  String get comment;

  /// No description provided for @cancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get cancellationPolicy;

  /// No description provided for @couponsOffers.
  ///
  /// In en, this message translates to:
  /// **'Coupons & Offers'**
  String get couponsOffers;

  /// No description provided for @validTill.
  ///
  /// In en, this message translates to:
  /// **'Valid Till:'**
  String get validTill;

  /// No description provided for @applied.
  ///
  /// In en, this message translates to:
  /// **'APPLIED'**
  String get applied;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'APPLY NOW'**
  String get applyNow;

  /// No description provided for @noOffersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Offers Available'**
  String get noOffersAvailable;

  /// No description provided for @politeDriver.
  ///
  /// In en, this message translates to:
  /// **'Polite Driver'**
  String get politeDriver;

  /// No description provided for @cleanliness.
  ///
  /// In en, this message translates to:
  /// **'Cleanliness'**
  String get cleanliness;

  /// No description provided for @smoothDriving.
  ///
  /// In en, this message translates to:
  /// **'Smooth Driving'**
  String get smoothDriving;

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get onTime;

  /// No description provided for @tapToRateDriver.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate your driver'**
  String get tapToRateDriver;

  /// No description provided for @howWasYourTrip.
  ///
  /// In en, this message translates to:
  /// **'How was your trip with\n'**
  String get howWasYourTrip;

  /// No description provided for @giveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get giveFeedback;

  /// No description provided for @leaveCommentOptional.
  ///
  /// In en, this message translates to:
  /// **'Leave a comment (optional)'**
  String get leaveCommentOptional;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @thankYouReviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your review is submitted'**
  String get thankYouReviewSubmitted;

  /// No description provided for @pleaseSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select rating'**
  String get pleaseSelectRating;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful:'**
  String get paymentSuccessful;

  /// No description provided for @bookingDocumentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Booking document ID not found'**
  String get bookingDocumentNotFound;

  /// No description provided for @rideCancelledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ride cancelled successfully'**
  String get rideCancelledSuccessfully;

  /// No description provided for @errorCancellingRide.
  ///
  /// In en, this message translates to:
  /// **'Error cancelling ride:'**
  String get errorCancellingRide;

  /// No description provided for @rideOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ride Ongoing'**
  String get rideOngoing;

  /// No description provided for @proceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedToPayment;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
