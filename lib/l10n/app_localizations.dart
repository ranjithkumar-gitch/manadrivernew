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
  /// **'Mobile number'**
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
  /// **'About Us'**
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
  /// **'3. Refund Timeline'**
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

  /// No description provided for @welcomeNyzoRide.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Nyzo Ride!'**
  String get welcomeNyzoRide;

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
  /// **'Vehicle details (vehicle owners)'**
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

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'NYZO RIDE – OWNER'**
  String get privacyPolicyTitle;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: January 2026'**
  String get lastUpdated;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride (“Nyzo Ride”, “we”, “our”, “us”) respects your privacy and is committed to protecting the personal information of users (“you”, “user”, “driver”, “vehicle owner”) who use the Nyzo Ride mobile application, website, and related services (collectively, the “Platform”).'**
  String get privacyIntro;

  /// No description provided for @privacyPolicyExplanation.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy explains how we collect, use, store, share, and protect your information.'**
  String get privacyPolicyExplanation;

  /// No description provided for @informationWeCollect.
  ///
  /// In en, this message translates to:
  /// **'INFORMATION WE COLLECT'**
  String get informationWeCollect;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'1.1 Personal Information'**
  String get personalInformation;

  /// No description provided for @weMayCollectFollowing.
  ///
  /// In en, this message translates to:
  /// **'We may collect the following:'**
  String get weMayCollectFollowing;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email address (optional)'**
  String get emailOptional;

  /// No description provided for @profilePhotoOptional.
  ///
  /// In en, this message translates to:
  /// **'Profile photo (optional)'**
  String get profilePhotoOptional;

  /// No description provided for @governmentIdDetails.
  ///
  /// In en, this message translates to:
  /// **'Government ID details (for drivers – License, PAN/Aadhaar where required)'**
  String get governmentIdDetails;

  /// No description provided for @locationInformation.
  ///
  /// In en, this message translates to:
  /// **'1.2 Location Information'**
  String get locationInformation;

  /// No description provided for @realTimeLocation.
  ///
  /// In en, this message translates to:
  /// **'Real-time location during active trips'**
  String get realTimeLocation;

  /// No description provided for @pickupDropLocations.
  ///
  /// In en, this message translates to:
  /// **'Pickup and drop locations'**
  String get pickupDropLocations;

  /// No description provided for @tripRoutesDistance.
  ///
  /// In en, this message translates to:
  /// **'Trip routes and distance data'**
  String get tripRoutesDistance;

  /// No description provided for @locationCollectionNote.
  ///
  /// In en, this message translates to:
  /// **'Location is collected only when the app is in use and for trip-related purposes.'**
  String get locationCollectionNote;

  /// No description provided for @usageDeviceInformation.
  ///
  /// In en, this message translates to:
  /// **'1.3 Usage & Device Information'**
  String get usageDeviceInformation;

  /// No description provided for @deviceModel.
  ///
  /// In en, this message translates to:
  /// **'Device model'**
  String get deviceModel;

  /// No description provided for @osVersion.
  ///
  /// In en, this message translates to:
  /// **'OS version'**
  String get osVersion;

  /// No description provided for @appUsageData.
  ///
  /// In en, this message translates to:
  /// **'App usage data'**
  String get appUsageData;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get ipAddress;

  /// No description provided for @crashLogs.
  ///
  /// In en, this message translates to:
  /// **'Crash logs and diagnostic data'**
  String get crashLogs;

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'1.4 Payment Information'**
  String get paymentInformation;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get paymentStatus;

  /// No description provided for @transactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// No description provided for @paymentMethodNote.
  ///
  /// In en, this message translates to:
  /// **'Payment method (Nyzo Ride does NOT store card or UPI credentials)'**
  String get paymentMethodNote;

  /// No description provided for @howWeUseInformation.
  ///
  /// In en, this message translates to:
  /// **'2. HOW WE USE YOUR INFORMATION'**
  String get howWeUseInformation;

  /// No description provided for @weUseYourInformationTo.
  ///
  /// In en, this message translates to:
  /// **'We use your information to:'**
  String get weUseYourInformationTo;

  /// No description provided for @connectOwnersDrivers.
  ///
  /// In en, this message translates to:
  /// **'Connect vehicle owners with drivers'**
  String get connectOwnersDrivers;

  /// No description provided for @enableBookingsTrips.
  ///
  /// In en, this message translates to:
  /// **'Enable bookings and trip management'**
  String get enableBookingsTrips;

  /// No description provided for @verifyDriverIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify driver identity and eligibility'**
  String get verifyDriverIdentity;

  /// No description provided for @processPaymentsRefunds.
  ///
  /// In en, this message translates to:
  /// **'Process payments and refunds'**
  String get processPaymentsRefunds;

  /// No description provided for @improveAppPerformance.
  ///
  /// In en, this message translates to:
  /// **'Improve app performance and user experience'**
  String get improveAppPerformance;

  /// No description provided for @communicateUpdatesAlerts.
  ///
  /// In en, this message translates to:
  /// **'Communicate service updates and alerts'**
  String get communicateUpdatesAlerts;

  /// No description provided for @preventFraudMisuse.
  ///
  /// In en, this message translates to:
  /// **'Prevent fraud and misuse'**
  String get preventFraudMisuse;

  /// No description provided for @complyLegalObligations.
  ///
  /// In en, this message translates to:
  /// **'Comply with legal obligations'**
  String get complyLegalObligations;

  /// No description provided for @informationSharing.
  ///
  /// In en, this message translates to:
  /// **'3. INFORMATION SHARING'**
  String get informationSharing;

  /// No description provided for @noSellRentData.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride does not sell or rent your personal data.'**
  String get noSellRentData;

  /// No description provided for @weMayShareLimitedInfo.
  ///
  /// In en, this message translates to:
  /// **'We may share limited information with:'**
  String get weMayShareLimitedInfo;

  /// No description provided for @shareDriversOwners.
  ///
  /// In en, this message translates to:
  /// **'Drivers / Vehicle Owners – only what is required for a trip'**
  String get shareDriversOwners;

  /// No description provided for @sharePaymentGateways.
  ///
  /// In en, this message translates to:
  /// **'Payment gateways – for transaction processing'**
  String get sharePaymentGateways;

  /// No description provided for @shareCloudPartners.
  ///
  /// In en, this message translates to:
  /// **'Cloud & technology partners – app hosting, analytics'**
  String get shareCloudPartners;

  /// No description provided for @shareLawAuthorities.
  ///
  /// In en, this message translates to:
  /// **'Law enforcement / government authorities – when legally required'**
  String get shareLawAuthorities;

  /// No description provided for @dataStorageSecurity.
  ///
  /// In en, this message translates to:
  /// **'4. DATA STORAGE & SECURITY'**
  String get dataStorageSecurity;

  /// No description provided for @dataStoredSecureServers.
  ///
  /// In en, this message translates to:
  /// **'Data is stored on secure servers'**
  String get dataStoredSecureServers;

  /// No description provided for @industryEncryptionUsed.
  ///
  /// In en, this message translates to:
  /// **'Industry-standard encryption is used'**
  String get industryEncryptionUsed;

  /// No description provided for @accessLimitedAuthorized.
  ///
  /// In en, this message translates to:
  /// **'Access is limited to authorized personnel only'**
  String get accessLimitedAuthorized;

  /// No description provided for @regularSecurityAudits.
  ///
  /// In en, this message translates to:
  /// **'Regular security audits are conducted'**
  String get regularSecurityAudits;

  /// No description provided for @noSystemFullySecure.
  ///
  /// In en, this message translates to:
  /// **'Despite best efforts, no digital system is 100% secure. Users share data at their own risk.'**
  String get noSystemFullySecure;

  /// No description provided for @userRights.
  ///
  /// In en, this message translates to:
  /// **'5. USER RIGHTS'**
  String get userRights;

  /// No description provided for @youHaveTheRightTo.
  ///
  /// In en, this message translates to:
  /// **'You have the right to:'**
  String get youHaveTheRightTo;

  /// No description provided for @accessPersonalData.
  ///
  /// In en, this message translates to:
  /// **'Access your personal data'**
  String get accessPersonalData;

  /// No description provided for @updateInformation.
  ///
  /// In en, this message translates to:
  /// **'Update or correct your information'**
  String get updateInformation;

  /// No description provided for @requestAccountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Request deletion of your account'**
  String get requestAccountDeletion;

  /// No description provided for @withdrawConsent.
  ///
  /// In en, this message translates to:
  /// **'Withdraw consent (where applicable)'**
  String get withdrawConsent;

  /// No description provided for @accountDeletionNote.
  ///
  /// In en, this message translates to:
  /// **'Account deletion requests may be subject to legal or regulatory retention requirements.'**
  String get accountDeletionNote;

  /// No description provided for @dataRetention.
  ///
  /// In en, this message translates to:
  /// **'6. DATA RETENTION'**
  String get dataRetention;

  /// No description provided for @dataRetainedAsNecessary.
  ///
  /// In en, this message translates to:
  /// **'Data is retained only as long as necessary'**
  String get dataRetainedAsNecessary;

  /// No description provided for @tripTransactionRetention.
  ///
  /// In en, this message translates to:
  /// **'Trip and transaction records may be retained for legal, tax, or dispute purposes'**
  String get tripTransactionRetention;

  /// No description provided for @inactiveAccountsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Inactive accounts may be deleted after a defined period'**
  String get inactiveAccountsDeleted;

  /// No description provided for @childrensPrivacy.
  ///
  /// In en, this message translates to:
  /// **'7. CHILDREN’S PRIVACY'**
  String get childrensPrivacy;

  /// No description provided for @notForUnder18.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride is not intended for users under 18 years'**
  String get notForUnder18;

  /// No description provided for @noMinorDataCollection.
  ///
  /// In en, this message translates to:
  /// **'We do not knowingly collect data from minors'**
  String get noMinorDataCollection;

  /// No description provided for @thirdPartyServices.
  ///
  /// In en, this message translates to:
  /// **'8. THIRD-PARTY SERVICES'**
  String get thirdPartyServices;

  /// No description provided for @mayContainThirdPartyLinks.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride may contain links or integrations with third-party services'**
  String get mayContainThirdPartyLinks;

  /// No description provided for @notResponsibleThirdPartyPrivacy.
  ///
  /// In en, this message translates to:
  /// **'We are not responsible for their privacy practices'**
  String get notResponsibleThirdPartyPrivacy;

  /// No description provided for @platformDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'9. PLATFORM NATURE DISCLAIMER'**
  String get platformDisclaimer;

  /// No description provided for @platformOnly.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride is a technology platform only:'**
  String get platformOnly;

  /// No description provided for @notTransportOperator.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride is not a transport operator'**
  String get notTransportOperator;

  /// No description provided for @doesNotOwnVehicles.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride does not own vehicles'**
  String get doesNotOwnVehicles;

  /// No description provided for @doesNotEmployDrivers.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride does not employ drivers'**
  String get doesNotEmployDrivers;

  /// No description provided for @independentProviders.
  ///
  /// In en, this message translates to:
  /// **'Drivers and vehicle owners are independent service providers'**
  String get independentProviders;

  /// No description provided for @policyChanges.
  ///
  /// In en, this message translates to:
  /// **'10. CHANGES TO THIS POLICY'**
  String get policyChanges;

  /// No description provided for @policyMayUpdate.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride may update this Privacy Policy from time to time'**
  String get policyMayUpdate;

  /// No description provided for @policyUpdatedVersions.
  ///
  /// In en, this message translates to:
  /// **'Updated versions will be published within the app or website'**
  String get policyUpdatedVersions;

  /// No description provided for @policyContinuedUse.
  ///
  /// In en, this message translates to:
  /// **'Continued use of the platform implies acceptance of the revised policy'**
  String get policyContinuedUse;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'11. CONTACT US'**
  String get contactUs;

  /// No description provided for @privacyConcernsContact.
  ///
  /// In en, this message translates to:
  /// **'For privacy concerns or data requests, contact:'**
  String get privacyConcernsContact;

  /// No description provided for @nyzoRideSupport.
  ///
  /// In en, this message translates to:
  /// **'Nyzo Ride Support'**
  String get nyzoRideSupport;

  /// No description provided for @nyzoRideEmail.
  ///
  /// In en, this message translates to:
  /// **'hello@nyzoride.com'**
  String get nyzoRideEmail;

  /// No description provided for @nyzoRidePhone.
  ///
  /// In en, this message translates to:
  /// **'9000464851'**
  String get nyzoRidePhone;

  /// No description provided for @termsConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'NYZO RIDE – OWNER, Terms & Conditions'**
  String get termsConditionsTitle;

  /// No description provided for @platformPurpose.
  ///
  /// In en, this message translates to:
  /// **'1. PLATFORM PURPOSE'**
  String get platformPurpose;

  /// No description provided for @platformPurposeDesc1.
  ///
  /// In en, this message translates to:
  /// **'This application is only a technology platform that connects vehicle owners with independent drivers.'**
  String get platformPurposeDesc1;

  /// No description provided for @platformPurposeDesc2.
  ///
  /// In en, this message translates to:
  /// **'The platform does not provide drivers as employees, does not guarantee driver availability, and does not offer transportation services.'**
  String get platformPurposeDesc2;

  /// No description provided for @eligibility.
  ///
  /// In en, this message translates to:
  /// **'2. ELIGIBILITY'**
  String get eligibility;

  /// No description provided for @eligibilityDesc1.
  ///
  /// In en, this message translates to:
  /// **'The vehicle owner must be 18 years or older.'**
  String get eligibilityDesc1;

  /// No description provided for @eligibilityDesc2.
  ///
  /// In en, this message translates to:
  /// **'The owner must have legal ownership or valid authorization to use the vehicle.'**
  String get eligibilityDesc2;

  /// No description provided for @eligibilityDesc3.
  ///
  /// In en, this message translates to:
  /// **'Only legally registered vehicles are allowed on the platform.'**
  String get eligibilityDesc3;

  /// No description provided for @vehicleResponsibility.
  ///
  /// In en, this message translates to:
  /// **'3. VEHICLE RESPONSIBILITY'**
  String get vehicleResponsibility;

  /// No description provided for @vehicleResponsibilityDesc1.
  ///
  /// In en, this message translates to:
  /// **'The owner is fully responsible for the condition, safety, and legality of the vehicle.'**
  String get vehicleResponsibilityDesc1;

  /// No description provided for @vehicleResponsibilityDesc2.
  ///
  /// In en, this message translates to:
  /// **'Before every trip, the owner must ensure:'**
  String get vehicleResponsibilityDesc2;

  /// No description provided for @vehicleResponsibilityPoint1.
  ///
  /// In en, this message translates to:
  /// **'Vehicle is in good running condition'**
  String get vehicleResponsibilityPoint1;

  /// No description provided for @vehicleResponsibilityPoint2.
  ///
  /// In en, this message translates to:
  /// **'Adequate fuel is available'**
  String get vehicleResponsibilityPoint2;

  /// No description provided for @vehicleResponsibilityPoint3.
  ///
  /// In en, this message translates to:
  /// **'All documents (RC, Insurance, PUC, permits if applicable) are valid'**
  String get vehicleResponsibilityPoint3;

  /// No description provided for @driverRelationship.
  ///
  /// In en, this message translates to:
  /// **'4. DRIVER RELATIONSHIP'**
  String get driverRelationship;

  /// No description provided for @driversIndependent.
  ///
  /// In en, this message translates to:
  /// **'Drivers on the platform are independent individuals, not employees or agents of the platform.'**
  String get driversIndependent;

  /// No description provided for @platformNotResponsibleDrivers.
  ///
  /// In en, this message translates to:
  /// **'The platform is not responsible for the conduct, behavior, or actions of drivers.'**
  String get platformNotResponsibleDrivers;

  /// No description provided for @ownersFreeAcceptReject.
  ///
  /// In en, this message translates to:
  /// **'Owners are free to accept or reject any driver request.'**
  String get ownersFreeAcceptReject;

  /// No description provided for @bookingTripDetails.
  ///
  /// In en, this message translates to:
  /// **'5. BOOKING & TRIP DETAILS'**
  String get bookingTripDetails;

  /// No description provided for @ownersSelectTripType.
  ///
  /// In en, this message translates to:
  /// **'Owners must clearly select the correct trip type (One Way / Round Trip / Hourly / Outstation).'**
  String get ownersSelectTripType;

  /// No description provided for @pickupDropDurationInstructions.
  ///
  /// In en, this message translates to:
  /// **'Pickup, drop location, duration, and special instructions must be clearly mentioned.'**
  String get pickupDropDurationInstructions;

  /// No description provided for @tripChangesAgreement.
  ///
  /// In en, this message translates to:
  /// **'Any change during the trip must be mutually agreed between owner and driver.'**
  String get tripChangesAgreement;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'6. PAYMENTS'**
  String get payments;

  /// No description provided for @paymentDetailsShown.
  ///
  /// In en, this message translates to:
  /// **'Payment details are shown before booking confirmation.'**
  String get paymentDetailsShown;

  /// No description provided for @platformFacilitatesPayments.
  ///
  /// In en, this message translates to:
  /// **'The platform only facilitates payments and is not responsible for off-app or cash transactions.'**
  String get platformFacilitatesPayments;

  /// No description provided for @additionalChargesSettlement.
  ///
  /// In en, this message translates to:
  /// **'Any additional charges must be settled directly between owner and driver.'**
  String get additionalChargesSettlement;

  /// No description provided for @cancellations.
  ///
  /// In en, this message translates to:
  /// **'7. CANCELLATIONS'**
  String get cancellations;

  /// No description provided for @repeatedCancellationsSuspension.
  ///
  /// In en, this message translates to:
  /// **'Repeated cancellations by the owner may result in temporary or permanent suspension.'**
  String get repeatedCancellationsSuspension;

  /// No description provided for @cancellationChargesDisplayed.
  ///
  /// In en, this message translates to:
  /// **'Cancellation charges, if applicable, will be displayed before confirmation.'**
  String get cancellationChargesDisplayed;

  /// No description provided for @safetyLiability.
  ///
  /// In en, this message translates to:
  /// **'8. SAFETY & LIABILITY'**
  String get safetyLiability;

  /// No description provided for @platformNotResponsibleSafety.
  ///
  /// In en, this message translates to:
  /// **'The platform is not responsible for accidents, injuries, damages, theft, or losses during the trip.'**
  String get platformNotResponsibleSafety;

  /// No description provided for @insuranceClaimsHandledDirectly.
  ///
  /// In en, this message translates to:
  /// **'Any insurance claims must be handled directly between the owner, driver, and insurance company.'**
  String get insuranceClaimsHandledDirectly;

  /// No description provided for @ownersEnsureInsurance.
  ///
  /// In en, this message translates to:
  /// **'Owners are advised to ensure active insurance coverage before every trip.'**
  String get ownersEnsureInsurance;

  /// No description provided for @postTripInspection.
  ///
  /// In en, this message translates to:
  /// **'9. POST-TRIP VEHICLE INSPECTION & BELONGINGS'**
  String get postTripInspection;

  /// No description provided for @ownerInspectVehicle.
  ///
  /// In en, this message translates to:
  /// **'After trip completion, the owner must immediately inspect the vehicle.'**
  String get ownerInspectVehicle;

  /// No description provided for @platformNotResponsible.
  ///
  /// In en, this message translates to:
  /// **'The platform is not responsible for:'**
  String get platformNotResponsible;

  /// No description provided for @notResponsibleBelongings.
  ///
  /// In en, this message translates to:
  /// **'Any personal belongings (cash, mobile phones, documents, valuables, etc.) left inside the vehicle'**
  String get notResponsibleBelongings;

  /// No description provided for @notResponsibleDamages.
  ///
  /// In en, this message translates to:
  /// **'Any scratches, dents, or damages identified after trip completion'**
  String get notResponsibleDamages;

  /// No description provided for @raiseIssueImmediately.
  ///
  /// In en, this message translates to:
  /// **'If any issue is noticed, the owner must raise it immediately with the driver.'**
  String get raiseIssueImmediately;

  /// No description provided for @complaintsNotEntertained.
  ///
  /// In en, this message translates to:
  /// **'Complaints raised after delay or after leaving the vehicle will not be entertained.'**
  String get complaintsNotEntertained;

  /// No description provided for @prohibitedActivities.
  ///
  /// In en, this message translates to:
  /// **'10. PROHIBITED ACTIVITIES'**
  String get prohibitedActivities;

  /// No description provided for @falseInformation.
  ///
  /// In en, this message translates to:
  /// **'Provide false vehicle or personal information'**
  String get falseInformation;

  /// No description provided for @illegalActivities.
  ///
  /// In en, this message translates to:
  /// **'Use the platform for illegal activities'**
  String get illegalActivities;

  /// No description provided for @misbehaveDrivers.
  ///
  /// In en, this message translates to:
  /// **'Misbehave, threaten, or harass drivers'**
  String get misbehaveDrivers;

  /// No description provided for @violationAccountTermination.
  ///
  /// In en, this message translates to:
  /// **'Violation may lead to account termination without prior notice.'**
  String get violationAccountTermination;

  /// No description provided for @ratingsFeedback.
  ///
  /// In en, this message translates to:
  /// **'11. RATINGS & FEEDBACK'**
  String get ratingsFeedback;

  /// No description provided for @ownersProvideFeedback.
  ///
  /// In en, this message translates to:
  /// **'Owners should provide honest and fair feedback.'**
  String get ownersProvideFeedback;

  /// No description provided for @fakeReviewsRestriction.
  ///
  /// In en, this message translates to:
  /// **'Fake, abusive, or misleading reviews may result in account restrictions.'**
  String get fakeReviewsRestriction;

  /// No description provided for @accountSuspensionTermination.
  ///
  /// In en, this message translates to:
  /// **'12. ACCOUNT SUSPENSION OR TERMINATION'**
  String get accountSuspensionTermination;

  /// No description provided for @platformSuspendTerminate.
  ///
  /// In en, this message translates to:
  /// **'The platform reserves the right to suspend or terminate accounts if:'**
  String get platformSuspendTerminate;

  /// No description provided for @termsViolated.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions are violated'**
  String get termsViolated;

  /// No description provided for @fraudulentActivityDetected.
  ///
  /// In en, this message translates to:
  /// **'Fraudulent activity is detected'**
  String get fraudulentActivityDetected;

  /// No description provided for @repeatedComplaintsReceived.
  ///
  /// In en, this message translates to:
  /// **'Repeated complaints are received'**
  String get repeatedComplaintsReceived;

  /// No description provided for @dataUsagePrivacy.
  ///
  /// In en, this message translates to:
  /// **'13. DATA USAGE & PRIVACY'**
  String get dataUsagePrivacy;

  /// No description provided for @ownerDataServicePurpose.
  ///
  /// In en, this message translates to:
  /// **'Owner data is used only for service-related purposes.'**
  String get ownerDataServicePurpose;

  /// No description provided for @personalInfoSharedLaw.
  ///
  /// In en, this message translates to:
  /// **'Personal information will not be shared except when required by law.'**
  String get personalInfoSharedLaw;

  /// No description provided for @changesToTerms.
  ///
  /// In en, this message translates to:
  /// **'14. CHANGES TO TERMS'**
  String get changesToTerms;

  /// No description provided for @platformModifyTerms.
  ///
  /// In en, this message translates to:
  /// **'The platform may modify these Terms & Conditions at any time.'**
  String get platformModifyTerms;

  /// No description provided for @continuedUseAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Continued use of the app means acceptance of updated terms.'**
  String get continuedUseAcceptance;

  /// No description provided for @acceptance.
  ///
  /// In en, this message translates to:
  /// **'15. ACCEPTANCE'**
  String get acceptance;

  /// No description provided for @ownerAcceptance.
  ///
  /// In en, this message translates to:
  /// **'By using this application, the owner confirms that they have read, understood, and agreed to all the above Terms & Conditions.'**
  String get ownerAcceptance;
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
