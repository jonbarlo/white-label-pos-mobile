import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es', 'CR'),
    Locale('en'),
    Locale('es')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Mobile POS'**
  String get appTitle;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Login failed error message
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login Error'**
  String get loginError;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Login subtitle message
  ///
  /// In en, this message translates to:
  /// **'To keep connected with us please login with your personal information'**
  String get loginSubtitle;

  /// Business slug hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your business slug'**
  String get enterBusinessSlug;

  /// Email hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// Password hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Quick login dropdown label
  ///
  /// In en, this message translates to:
  /// **'Quick Login (Test User)'**
  String get quickLogin;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get loginNow;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Business slug field label
  ///
  /// In en, this message translates to:
  /// **'Business Slug'**
  String get businessSlug;

  /// Dashboard screen title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Search field hint
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Sort button
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Warning message
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Info message
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// Yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Open button
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Add button text
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Remove button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Select button
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Deselect button
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get deselect;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Submit button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Finish button
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Start button
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Stop button
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// Pause button
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Resume button
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Point of sale system subtitle
  ///
  /// In en, this message translates to:
  /// **'Point of Sale System'**
  String get pointOfSaleSystem;

  /// Inventory alerts section
  ///
  /// In en, this message translates to:
  /// **'Inventory Alerts'**
  String get inventoryAlerts;

  /// All alerts tab
  ///
  /// In en, this message translates to:
  /// **'All Alerts'**
  String get allAlerts;

  /// Expiring items tab
  ///
  /// In en, this message translates to:
  /// **'Expiring Items'**
  String get expiringItems;

  /// Underperforming items tab
  ///
  /// In en, this message translates to:
  /// **'Underperforming'**
  String get underperforming;

  /// Error message when creating promotion fails
  ///
  /// In en, this message translates to:
  /// **'Error creating promotion'**
  String get errorCreatingPromotion;

  /// Promotion configuration section title
  ///
  /// In en, this message translates to:
  /// **'Promotion Configuration'**
  String get promotionConfiguration;

  /// Percentage discount option
  ///
  /// In en, this message translates to:
  /// **'Percentage Discount'**
  String get percentageDiscount;

  /// Fixed amount discount option
  ///
  /// In en, this message translates to:
  /// **'Fixed Amount Off'**
  String get fixedAmountOff;

  /// Buy one get one promotion option
  ///
  /// In en, this message translates to:
  /// **'Buy One Get One'**
  String get buyOneGetOne;

  /// Quick actions label
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Cook recipe button text
  ///
  /// In en, this message translates to:
  /// **'Cook Recipe'**
  String get cookRecipe;

  /// Description for cook recipe action
  ///
  /// In en, this message translates to:
  /// **'Use expiring items to create dishes'**
  String get useExpiringItemsToCreateDishes;

  /// Create promotion button text
  ///
  /// In en, this message translates to:
  /// **'Create Promotion'**
  String get createPromotion;

  /// Description for create promotion action
  ///
  /// In en, this message translates to:
  /// **'Create special offers for items'**
  String get createSpecialOffersForItems;

  /// View analytics action
  ///
  /// In en, this message translates to:
  /// **'View Analytics'**
  String get viewAnalytics;

  /// Description for view analytics action
  ///
  /// In en, this message translates to:
  /// **'Check cooking history and metrics'**
  String get checkCookingHistoryAndMetrics;

  /// Cooking history action
  ///
  /// In en, this message translates to:
  /// **'Cooking History'**
  String get cookingHistory;

  /// Description for cooking history action
  ///
  /// In en, this message translates to:
  /// **'View recent cooking activities'**
  String get viewRecentCookingActivities;

  /// Dialog text for recipe selection
  ///
  /// In en, this message translates to:
  /// **'Select a recipe to cook using expiring items'**
  String get selectARecipeToCookUsingExpiringItems;

  /// Feature description prefix
  ///
  /// In en, this message translates to:
  /// **'This feature will:'**
  String get thisFeatureWill;

  /// Feature benefit description
  ///
  /// In en, this message translates to:
  /// **'Automatically select recipes using expiring items'**
  String get automaticallySelectRecipesUsingExpiringItems;

  /// Feature benefit description
  ///
  /// In en, this message translates to:
  /// **'Consume inventory and reduce waste'**
  String get consumeInventoryAndReduceWaste;

  /// Feature benefit description
  ///
  /// In en, this message translates to:
  /// **'Create customizable promotions'**
  String get createCustomizablePromotions;

  /// Quantity field label
  ///
  /// In en, this message translates to:
  /// **'Quantity to Cook'**
  String get quantityToCook;

  /// Helper text for quantity field
  ///
  /// In en, this message translates to:
  /// **'This will create a promotion with the same quantity'**
  String get thisWillCreateAPromotionWithTheSameQuantity;

  /// Promotion name field label
  ///
  /// In en, this message translates to:
  /// **'Promotion Name'**
  String get promotionName;

  /// Example abbreviation
  ///
  /// In en, this message translates to:
  /// **'e.g.'**
  String get eG;

  /// Chef special promotion type
  ///
  /// In en, this message translates to:
  /// **'Chef Special'**
  String get chefSpecial;

  /// Example dish name
  ///
  /// In en, this message translates to:
  /// **'Truffle Pizza'**
  String get trufflePizza;

  /// Promotion description field label
  ///
  /// In en, this message translates to:
  /// **'Promotion Description'**
  String get promotionDescription;

  /// Promotion description hint
  ///
  /// In en, this message translates to:
  /// **'Description of the promotion'**
  String get descriptionOfThePromotion;

  /// Promotion type field label
  ///
  /// In en, this message translates to:
  /// **'Promotion Type'**
  String get promotionType;

  /// Discount promotion type
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// Flash sale promotion type
  ///
  /// In en, this message translates to:
  /// **'Flash Sale'**
  String get flashSale;

  /// Discount type field label
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get discountType;

  /// Free item discount type
  ///
  /// In en, this message translates to:
  /// **'Free Item'**
  String get freeItem;

  /// Discount percentage field label
  ///
  /// In en, this message translates to:
  /// **'Discount Percentage'**
  String get discountPercentage;

  /// Discount amount field label
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get discountAmount;

  /// Promotion expiration field label
  ///
  /// In en, this message translates to:
  /// **'Promotion Expires In (Hours)'**
  String get promotionExpiresInHours;

  /// Validation error for promotion name
  ///
  /// In en, this message translates to:
  /// **'Please enter a promotion name'**
  String get pleaseEnterAPromotionName;

  /// Validation error for discount value
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid discount value'**
  String get pleaseEnterAValidDiscountValue;

  /// Success message for promotion creation
  ///
  /// In en, this message translates to:
  /// **'Successfully created promotion'**
  String get successfullyCreatedPromotion;

  /// Percentage field label
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Description for promotion created from inventory alert
  ///
  /// In en, this message translates to:
  /// **'Promotion created from inventory alert'**
  String get promotionCreatedFromInventoryAlert;

  /// Analytics screen title
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Features screen title
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// Sales overview label
  ///
  /// In en, this message translates to:
  /// **'Sales Overview'**
  String get salesOverview;

  /// Today's sales label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get todaysSales;

  /// Transactions section
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Average order label
  ///
  /// In en, this message translates to:
  /// **'Avg Order'**
  String get avgOrder;

  /// New features available section
  ///
  /// In en, this message translates to:
  /// **'New Features Available'**
  String get newFeaturesAvailable;

  /// Description for exploring features
  ///
  /// In en, this message translates to:
  /// **'Explore our new Recipe & Promotion System with mobile notifications.'**
  String get exploreFeaturesDescription;

  /// Explore features button
  ///
  /// In en, this message translates to:
  /// **'Explore Features'**
  String get exploreFeatures;

  /// Recent activity label
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// Language status label
  ///
  /// In en, this message translates to:
  /// **'Language Status'**
  String get languageStatus;

  /// Current language label
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// Native name field
  ///
  /// In en, this message translates to:
  /// **'Native Name'**
  String get nativeName;

  /// Select language label
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language changes saved message
  ///
  /// In en, this message translates to:
  /// **'Language changes saved'**
  String get languageChangesSaved;

  /// Language information text
  ///
  /// In en, this message translates to:
  /// **'Mobile POS supports Spanish and English. Default language is Spanish (Costa Rica).'**
  String get languageInfo;

  /// Language changes applied message
  ///
  /// In en, this message translates to:
  /// **'Language changes will be saved and applied immediately.'**
  String get languageChangesApplied;

  /// Profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Confirm logout dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Saving message
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Loading profile message
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// Profile updated success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// Failed to load profile message
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// Please login to view profile message
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your profile'**
  String get pleaseLoginToViewProfile;

  /// Initializing message
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// User data not available message
  ///
  /// In en, this message translates to:
  /// **'User data not available'**
  String get userDataNotAvailable;

  /// Personal information label
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Work information label
  ///
  /// In en, this message translates to:
  /// **'Work Information'**
  String get workInformation;

  /// Account settings label
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// Support and help label
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportAndHelp;

  /// Edit profile button
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Change photo button
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// Photo upload coming soon message
  ///
  /// In en, this message translates to:
  /// **'Photo upload coming soon!'**
  String get photoUploadComingSoon;

  /// Full name field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Enter your name hint
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// Phone number field
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Role field
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Employee ID field
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeId;

  /// Department field
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// Hire date field
  ///
  /// In en, this message translates to:
  /// **'Hire Date'**
  String get hireDate;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Quick stats section
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// Orders label
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// This month section
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Tables label
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get tables;

  /// This week section
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// Tips section
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// Change password button
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Password change coming soon message
  ///
  /// In en, this message translates to:
  /// **'Password change coming soon!'**
  String get passwordChangeComingSoon;

  /// Notification settings section
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Notification settings coming soon message
  ///
  /// In en, this message translates to:
  /// **'Notification settings coming soon!'**
  String get notificationSettingsComingSoon;

  /// Theme settings section
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// Theme settings coming soon message
  ///
  /// In en, this message translates to:
  /// **'Theme settings coming soon!'**
  String get themeSettingsComingSoon;

  /// Privacy and security section
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// Privacy settings coming soon message
  ///
  /// In en, this message translates to:
  /// **'Privacy settings coming soon!'**
  String get privacySettingsComingSoon;

  /// Help center section
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// Help center coming soon message
  ///
  /// In en, this message translates to:
  /// **'Help center coming soon!'**
  String get helpCenterComingSoon;

  /// Contact support section
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Contact support coming soon message
  ///
  /// In en, this message translates to:
  /// **'Contact support coming soon!'**
  String get contactSupportComingSoon;

  /// Training materials section
  ///
  /// In en, this message translates to:
  /// **'Training Materials'**
  String get trainingMaterials;

  /// Training materials coming soon message
  ///
  /// In en, this message translates to:
  /// **'Training materials coming soon!'**
  String get trainingMaterialsComingSoon;

  /// Clear all data button
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// Clear data confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will clear all stored data and log you out. This action cannot be undone.'**
  String get clearDataConfirmation;

  /// Clear stored data debug button
  ///
  /// In en, this message translates to:
  /// **'Clear Stored Data (Debug)'**
  String get clearStoredDataDebug;

  /// Floor plan screen title
  ///
  /// In en, this message translates to:
  /// **'Floor Plan'**
  String get floorPlan;

  /// Messages screen title
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Business management label
  ///
  /// In en, this message translates to:
  /// **'Business Management'**
  String get businessManagement;

  /// Add business button
  ///
  /// In en, this message translates to:
  /// **'Add Business'**
  String get addBusiness;

  /// Error message when loading businesses fails
  ///
  /// In en, this message translates to:
  /// **'Error loading businesses'**
  String get errorLoadingBusinesses;

  /// No businesses found message
  ///
  /// In en, this message translates to:
  /// **'No businesses found'**
  String get noBusinessesFound;

  /// Add first business message
  ///
  /// In en, this message translates to:
  /// **'Add your first business to get started'**
  String get addFirstBusinessToGetStarted;

  /// Active status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Inactive status
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Delete business button
  ///
  /// In en, this message translates to:
  /// **'Delete Business'**
  String get deleteBusiness;

  /// Delete business confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get deleteBusinessConfirmation;

  /// Warning that action cannot be undone
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// Floor plan management label
  ///
  /// In en, this message translates to:
  /// **'Floor Plan Management'**
  String get floorPlanManagement;

  /// Overview section
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Floor plans label
  ///
  /// In en, this message translates to:
  /// **'Floor Plans'**
  String get floorPlans;

  /// Table status overview label
  ///
  /// In en, this message translates to:
  /// **'Table Status Overview'**
  String get tableStatusOverview;

  /// Real-time restaurant metrics description
  ///
  /// In en, this message translates to:
  /// **'Real-time restaurant floor plan metrics'**
  String get realTimeRestaurantMetrics;

  /// Total tables label
  ///
  /// In en, this message translates to:
  /// **'Total Tables'**
  String get totalTables;

  /// Available label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Occupied label
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupied;

  /// Reserved status
  ///
  /// In en, this message translates to:
  /// **'reserved'**
  String get reserved;

  /// Cleaning label
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get cleaning;

  /// Cart label
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Cart empty message
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartIsEmpty;

  /// Item not found for barcode message
  ///
  /// In en, this message translates to:
  /// **'Item not found for this barcode'**
  String get itemNotFoundForBarcode;

  /// Promotion section
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get promotion;

  /// Cashier label
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get cashier;

  /// Menu label
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Inventory label
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// Discounts section
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// Promotions section
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotions;

  /// Scan button text
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// Error message when loading categories fails
  ///
  /// In en, this message translates to:
  /// **'Error loading categories'**
  String get errorLoadingCategories;

  /// Error message when loading items fails
  ///
  /// In en, this message translates to:
  /// **'Error loading items'**
  String get errorLoadingItems;

  /// Search result section
  ///
  /// In en, this message translates to:
  /// **'Search Result'**
  String get searchResult;

  /// No items found message
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// Suggestion to adjust search terms
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get tryAdjustingSearchTerms;

  /// No items available in category message
  ///
  /// In en, this message translates to:
  /// **'No items available in this category'**
  String get noItemsAvailableInCategory;

  /// Actions label
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Guest label
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// Your cart is empty message
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// Add items to get started message
  ///
  /// In en, this message translates to:
  /// **'Add items to get started'**
  String get addItemsToGetStarted;

  /// Charge table order button
  ///
  /// In en, this message translates to:
  /// **'Charge Table Order'**
  String get chargeTableOrder;

  /// Hold order button
  ///
  /// In en, this message translates to:
  /// **'Hold Order'**
  String get holdOrder;

  /// Order held message
  ///
  /// In en, this message translates to:
  /// **'Order held'**
  String get orderHeld;

  /// Void order button
  ///
  /// In en, this message translates to:
  /// **'Void Order'**
  String get voidOrder;

  /// Order voided message
  ///
  /// In en, this message translates to:
  /// **'Order voided'**
  String get orderVoided;

  /// Print receipt button
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get printReceipt;

  /// Receipt printed message
  ///
  /// In en, this message translates to:
  /// **'Receipt printed'**
  String get receiptPrinted;

  /// Email receipt button
  ///
  /// In en, this message translates to:
  /// **'Email Receipt'**
  String get emailReceipt;

  /// Receipt emailed message
  ///
  /// In en, this message translates to:
  /// **'Receipt emailed'**
  String get receiptEmailed;

  /// Set guest count dialog title
  ///
  /// In en, this message translates to:
  /// **'Set Guest Count'**
  String get setGuestCount;

  /// Customer info label
  ///
  /// In en, this message translates to:
  /// **'Customer Info'**
  String get customerInfo;

  /// Customer info dialog description
  ///
  /// In en, this message translates to:
  /// **'Customer info dialog'**
  String get customerInfoDialog;

  /// Special requests section
  ///
  /// In en, this message translates to:
  /// **'Special Requests'**
  String get specialRequests;

  /// Special requests dialog description
  ///
  /// In en, this message translates to:
  /// **'Special requests dialog'**
  String get specialRequestsDialog;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// More label
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// POS service label
  ///
  /// In en, this message translates to:
  /// **'POS Service'**
  String get posService;

  /// No recent sales message
  ///
  /// In en, this message translates to:
  /// **'No recent sales'**
  String get noRecentSales;

  /// Sales will appear here message
  ///
  /// In en, this message translates to:
  /// **'Sales will appear here after transactions'**
  String get salesWillAppearHere;

  /// Current orders section
  ///
  /// In en, this message translates to:
  /// **'Current Orders'**
  String get currentOrders;

  /// Manage restaurant orders description
  ///
  /// In en, this message translates to:
  /// **'Manage restaurant orders'**
  String get manageRestaurantOrders;

  /// No active orders message
  ///
  /// In en, this message translates to:
  /// **'No Active Orders'**
  String get noActiveOrders;

  /// New orders will appear here message
  ///
  /// In en, this message translates to:
  /// **'New orders will appear here'**
  String get newOrdersWillAppearHere;

  /// Failed to load orders message
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders'**
  String get failedToLoadOrders;

  /// Daily transactions section
  ///
  /// In en, this message translates to:
  /// **'Daily Transactions'**
  String get dailyTransactions;

  /// View completed sales button
  ///
  /// In en, this message translates to:
  /// **'View completed sales'**
  String get viewCompletedSales;

  /// No transactions today message
  ///
  /// In en, this message translates to:
  /// **'No Transactions Today'**
  String get noTransactionsToday;

  /// Completed sales will appear here message
  ///
  /// In en, this message translates to:
  /// **'Completed sales will appear here'**
  String get completedSalesWillAppearHere;

  /// Failed to load transactions message
  ///
  /// In en, this message translates to:
  /// **'Failed to load transactions'**
  String get failedToLoadTransactions;

  /// Inventory status section
  ///
  /// In en, this message translates to:
  /// **'Inventory Status'**
  String get inventoryStatus;

  /// Monitor stock levels description
  ///
  /// In en, this message translates to:
  /// **'Monitor stock levels'**
  String get monitorStockLevels;

  /// No inventory data message
  ///
  /// In en, this message translates to:
  /// **'No Inventory Data'**
  String get noInventoryData;

  /// Menu items will appear here message
  ///
  /// In en, this message translates to:
  /// **'Menu items will appear here with stock info'**
  String get menuItemsWillAppearHere;

  /// Failed to load inventory message
  ///
  /// In en, this message translates to:
  /// **'Failed to load inventory'**
  String get failedToLoadInventory;

  /// Unknown status
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Split payment button text
  ///
  /// In en, this message translates to:
  /// **'Split Payment'**
  String get splitPayment;

  /// Customer name label
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// Customer phone label
  ///
  /// In en, this message translates to:
  /// **'Customer Phone'**
  String get customerPhone;

  /// Customer email label
  ///
  /// In en, this message translates to:
  /// **'Customer Email'**
  String get customerEmail;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Payment methods label
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// Add payment label
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPayment;

  /// Amount validation message
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountIsRequired;

  /// Payment method label
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Cash payment method
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Credit card payment method
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// Debit card payment method
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get debitCard;

  /// Mobile payment method
  ///
  /// In en, this message translates to:
  /// **'Mobile Payment'**
  String get mobilePayment;

  /// Check payment method
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// Payment method validation message
  ///
  /// In en, this message translates to:
  /// **'Payment method is required'**
  String get paymentMethodIsRequired;

  /// Complete split payment label
  ///
  /// In en, this message translates to:
  /// **'Complete Split Payment'**
  String get completeSplitPayment;

  /// Select customer label
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get selectCustomer;

  /// New customer label
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get newCustomer;

  /// Guest checkout label
  ///
  /// In en, this message translates to:
  /// **'Guest Checkout'**
  String get guestCheckout;

  /// Search results label
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No email label
  ///
  /// In en, this message translates to:
  /// **'No Email'**
  String get noEmail;

  /// No phone label
  ///
  /// In en, this message translates to:
  /// **'No Phone'**
  String get noPhone;

  /// No customers found message
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// Create customer label
  ///
  /// In en, this message translates to:
  /// **'Create Customer'**
  String get createCustomer;

  /// Split billing screen title
  ///
  /// In en, this message translates to:
  /// **'Split Billing'**
  String get splitBilling;

  /// Add split button text
  ///
  /// In en, this message translates to:
  /// **'Add Split'**
  String get addSplit;

  /// Remove last split button text
  ///
  /// In en, this message translates to:
  /// **'Remove Last Split'**
  String get removeLastSplit;

  /// Assign item to split hint text
  ///
  /// In en, this message translates to:
  /// **'Assign item to split'**
  String get assignItemToSplit;

  /// New stock quantity field
  ///
  /// In en, this message translates to:
  /// **'New Stock Quantity'**
  String get newStockQuantity;

  /// Update button text
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Card payment method
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// Mobile payment method
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// Finalize split button text
  ///
  /// In en, this message translates to:
  /// **'Finalize Split'**
  String get finalizeSplit;

  /// All items label
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get allItems;

  /// Low stock label
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// Categories label
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Error loading inventory message
  ///
  /// In en, this message translates to:
  /// **'Error loading inventory'**
  String get errorLoadingInventory;

  /// No inventory items found message
  ///
  /// In en, this message translates to:
  /// **'No inventory items found'**
  String get noInventoryItemsFound;

  /// Add your first item message
  ///
  /// In en, this message translates to:
  /// **'Add your first item to get started'**
  String get addYourFirstItemToGetStarted;

  /// All items well stocked message
  ///
  /// In en, this message translates to:
  /// **'All items are well stocked'**
  String get allItemsAreWellStocked;

  /// No low stock items found message
  ///
  /// In en, this message translates to:
  /// **'No low stock items found'**
  String get noLowStockItemsFound;

  /// No categories found message
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// Categories will appear here message
  ///
  /// In en, this message translates to:
  /// **'Categories will appear here'**
  String get categoriesWillAppearHere;

  /// Out of stock status
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// Search inventory label
  ///
  /// In en, this message translates to:
  /// **'Search Inventory'**
  String get searchInventory;

  /// Filter options label
  ///
  /// In en, this message translates to:
  /// **'Filter Options'**
  String get filterOptions;

  /// Filter options implementation message
  ///
  /// In en, this message translates to:
  /// **'Filter options will be implemented here'**
  String get filterOptionsWillBeImplementedHere;

  /// Add new item label
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addNewItem;

  /// Add item form implementation message
  ///
  /// In en, this message translates to:
  /// **'Add item form will be implemented here'**
  String get addItemFormWillBeImplementedHere;

  /// Edit item label
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// Update stock label
  ///
  /// In en, this message translates to:
  /// **'Update Stock'**
  String get updateStock;

  /// Delete item label
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// Reports and analytics screen title
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get reportsAndAnalytics;

  /// Refresh data action
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// Export report action
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// Recipe and promotion features label
  ///
  /// In en, this message translates to:
  /// **'Recipe & Promotion Features'**
  String get recipeAndPromotionFeatures;

  /// Revenue section
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// Date range label
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// Custom option
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// All status filter
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Cancelled status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Refunded status
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// Payment label
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// All payment methods filter
  ///
  /// In en, this message translates to:
  /// **'All Methods'**
  String get allMethods;

  /// PDF report option
  ///
  /// In en, this message translates to:
  /// **'PDF Report'**
  String get pdfReport;

  /// CSV data option
  ///
  /// In en, this message translates to:
  /// **'CSV Data'**
  String get csvData;

  /// Excel spreadsheet option
  ///
  /// In en, this message translates to:
  /// **'Excel Spreadsheet'**
  String get excelSpreadsheet;

  /// Exporting report message
  ///
  /// In en, this message translates to:
  /// **'Exporting report as'**
  String get exportingReportAs;

  /// Loading overview data message
  ///
  /// In en, this message translates to:
  /// **'Loading overview data...'**
  String get loadingOverviewData;

  /// Failed to load overview data message
  ///
  /// In en, this message translates to:
  /// **'Failed to load overview data'**
  String get failedToLoadOverviewData;

  /// Total sales section
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// Average order section
  ///
  /// In en, this message translates to:
  /// **'Average Order'**
  String get averageOrder;

  /// Per transaction description
  ///
  /// In en, this message translates to:
  /// **'per transaction'**
  String get perTransaction;

  /// Top product section
  ///
  /// In en, this message translates to:
  /// **'Top Product'**
  String get topProduct;

  /// Most popular item description
  ///
  /// In en, this message translates to:
  /// **'Most popular item'**
  String get mostPopularItem;

  /// Conversion rate section
  ///
  /// In en, this message translates to:
  /// **'Conversion Rate'**
  String get conversionRate;

  /// Of visitors description
  ///
  /// In en, this message translates to:
  /// **'of visitors'**
  String get ofVisitors;

  /// Sales trend section
  ///
  /// In en, this message translates to:
  /// **'Sales Trend'**
  String get salesTrend;

  /// Sales trend chart description
  ///
  /// In en, this message translates to:
  /// **'Sales trend chart'**
  String get salesTrendChart;

  /// Coming soon with real data message
  ///
  /// In en, this message translates to:
  /// **'Coming soon with real data'**
  String get comingSoonWithRealData;

  /// Top selling items section
  ///
  /// In en, this message translates to:
  /// **'Top Selling Items'**
  String get topSellingItems;

  /// View all button
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Popular item description
  ///
  /// In en, this message translates to:
  /// **'Popular item'**
  String get popularItem;

  /// Loading transactions message
  ///
  /// In en, this message translates to:
  /// **'Loading transactions...'**
  String get loadingTransactions;

  /// No transactions found message
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// Try adjusting filters message
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or date range'**
  String get tryAdjustingFiltersOrDateRange;

  /// Sale label
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// Sale number prefix
  ///
  /// In en, this message translates to:
  /// **'Sale #'**
  String get saleNumber;

  /// Loading revenue data message
  ///
  /// In en, this message translates to:
  /// **'Loading revenue data...'**
  String get loadingRevenueData;

  /// Failed to load revenue data message
  ///
  /// In en, this message translates to:
  /// **'Failed to load revenue data'**
  String get failedToLoadRevenueData;

  /// Total revenue section
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// Gross income description
  ///
  /// In en, this message translates to:
  /// **'Gross income'**
  String get grossIncome;

  /// Gross profit section
  ///
  /// In en, this message translates to:
  /// **'Gross Profit'**
  String get grossProfit;

  /// After costs description
  ///
  /// In en, this message translates to:
  /// **'After costs'**
  String get afterCosts;

  /// Profit margin section
  ///
  /// In en, this message translates to:
  /// **'Profit Margin'**
  String get profitMargin;

  /// Profit ratio description
  ///
  /// In en, this message translates to:
  /// **'Profit ratio'**
  String get profitRatio;

  /// Total cost section
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// Operating costs description
  ///
  /// In en, this message translates to:
  /// **'Operating costs'**
  String get operatingCosts;

  /// Revenue by day section
  ///
  /// In en, this message translates to:
  /// **'Revenue by Day'**
  String get revenueByDay;

  /// Revenue trend chart description
  ///
  /// In en, this message translates to:
  /// **'Revenue trend chart'**
  String get revenueTrendChart;

  /// Transaction details section
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// Items section
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No items found for sale message
  ///
  /// In en, this message translates to:
  /// **'No items found for this sale'**
  String get noItemsFoundForThisSale;

  /// Loading items message
  ///
  /// In en, this message translates to:
  /// **'Loading items...'**
  String get loadingItems;

  /// Business analytics section
  ///
  /// In en, this message translates to:
  /// **'Business Analytics'**
  String get businessAnalytics;

  /// Item analytics section
  ///
  /// In en, this message translates to:
  /// **'Item Analytics'**
  String get itemAnalytics;

  /// Staff analytics section
  ///
  /// In en, this message translates to:
  /// **'Staff Analytics'**
  String get staffAnalytics;

  /// Customer analytics section
  ///
  /// In en, this message translates to:
  /// **'Customer Analytics'**
  String get customerAnalytics;

  /// Inventory analytics section
  ///
  /// In en, this message translates to:
  /// **'Inventory Analytics'**
  String get inventoryAnalytics;

  /// Revenue analytics section
  ///
  /// In en, this message translates to:
  /// **'Revenue Analytics'**
  String get revenueAnalytics;

  /// Performance metrics section
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// Sales metrics section
  ///
  /// In en, this message translates to:
  /// **'Sales Metrics'**
  String get salesMetrics;

  /// Customer metrics section
  ///
  /// In en, this message translates to:
  /// **'Customer Metrics'**
  String get customerMetrics;

  /// Inventory metrics section
  ///
  /// In en, this message translates to:
  /// **'Inventory Metrics'**
  String get inventoryMetrics;

  /// Staff metrics section
  ///
  /// In en, this message translates to:
  /// **'Staff Metrics'**
  String get staffMetrics;

  /// Revenue metrics section
  ///
  /// In en, this message translates to:
  /// **'Revenue Metrics'**
  String get revenueMetrics;

  /// Data export section
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get dataExport;

  /// Report generation section
  ///
  /// In en, this message translates to:
  /// **'Report Generation'**
  String get reportGeneration;

  /// Chart visualization section
  ///
  /// In en, this message translates to:
  /// **'Chart Visualization'**
  String get chartVisualization;

  /// Trend analysis section
  ///
  /// In en, this message translates to:
  /// **'Trend Analysis'**
  String get trendAnalysis;

  /// Comparative analysis section
  ///
  /// In en, this message translates to:
  /// **'Comparative Analysis'**
  String get comparativeAnalysis;

  /// Forecasting section
  ///
  /// In en, this message translates to:
  /// **'Forecasting'**
  String get forecasting;

  /// KPI dashboard section
  ///
  /// In en, this message translates to:
  /// **'KPI Dashboard'**
  String get kpiDashboard;

  /// Real-time analytics section
  ///
  /// In en, this message translates to:
  /// **'Real-time Analytics'**
  String get realTimeAnalytics;

  /// Historical data section
  ///
  /// In en, this message translates to:
  /// **'Historical Data'**
  String get historicalData;

  /// Data insights section
  ///
  /// In en, this message translates to:
  /// **'Data Insights'**
  String get dataInsights;

  /// Business intelligence section
  ///
  /// In en, this message translates to:
  /// **'Business Intelligence'**
  String get businessIntelligence;

  /// Currency management section
  ///
  /// In en, this message translates to:
  /// **'Currency Management'**
  String get currencyManagement;

  /// Add currency button
  ///
  /// In en, this message translates to:
  /// **'Add Currency'**
  String get addCurrency;

  /// Currency code field
  ///
  /// In en, this message translates to:
  /// **'Currency Code'**
  String get currencyCode;

  /// Currency symbol field
  ///
  /// In en, this message translates to:
  /// **'Currency Symbol'**
  String get currencySymbol;

  /// Currency name field
  ///
  /// In en, this message translates to:
  /// **'Currency Name'**
  String get currencyName;

  /// Exchange rate field
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRate;

  /// Is default field
  ///
  /// In en, this message translates to:
  /// **'Is Default'**
  String get isDefault;

  /// Default currency label
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultCurrency;

  /// Edit currency button
  ///
  /// In en, this message translates to:
  /// **'Edit Currency'**
  String get editCurrency;

  /// Delete currency button
  ///
  /// In en, this message translates to:
  /// **'Delete Currency'**
  String get deleteCurrency;

  /// Currency preferences section
  ///
  /// In en, this message translates to:
  /// **'Currency Preferences'**
  String get currencyPreferences;

  /// Order taking section
  ///
  /// In en, this message translates to:
  /// **'Order Taking'**
  String get orderTaking;

  /// Table selection section
  ///
  /// In en, this message translates to:
  /// **'Table Selection'**
  String get tableSelection;

  /// Waiter dashboard title
  ///
  /// In en, this message translates to:
  /// **'Waiter Dashboard'**
  String get waiterDashboard;

  /// Waiter screen section
  ///
  /// In en, this message translates to:
  /// **'Waiter Screen'**
  String get waiterScreen;

  /// Take order button
  ///
  /// In en, this message translates to:
  /// **'Take Order'**
  String get takeOrder;

  /// View orders button
  ///
  /// In en, this message translates to:
  /// **'View Orders'**
  String get viewOrders;

  /// Table status section
  ///
  /// In en, this message translates to:
  /// **'Table Status'**
  String get tableStatus;

  /// Assign table button
  ///
  /// In en, this message translates to:
  /// **'Assign Table'**
  String get assignTable;

  /// Unassign table button
  ///
  /// In en, this message translates to:
  /// **'Unassign Table'**
  String get unassignTable;

  /// Waiter orders section
  ///
  /// In en, this message translates to:
  /// **'Waiter Orders'**
  String get waiterOrders;

  /// Admin dashboard section
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// Menu management section
  ///
  /// In en, this message translates to:
  /// **'Menu Management'**
  String get menuManagement;

  /// PDF menu generation section
  ///
  /// In en, this message translates to:
  /// **'PDF Menu Generation'**
  String get pdfMenuGeneration;

  /// Custom template management section
  ///
  /// In en, this message translates to:
  /// **'Custom Template Management'**
  String get customTemplateManagement;

  /// Generate menu button
  ///
  /// In en, this message translates to:
  /// **'Generate Menu'**
  String get generateMenu;

  /// Template settings section
  ///
  /// In en, this message translates to:
  /// **'Template Settings'**
  String get templateSettings;

  /// Reports section
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// Sales report section
  ///
  /// In en, this message translates to:
  /// **'Sales Report'**
  String get salesReport;

  /// Inventory report section
  ///
  /// In en, this message translates to:
  /// **'Inventory Report'**
  String get inventoryReport;

  /// Staff report section
  ///
  /// In en, this message translates to:
  /// **'Staff Report'**
  String get staffReport;

  /// Recipes section
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// Smart suggestions section
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestions'**
  String get smartSuggestions;

  /// First onboarding page title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mobile POS'**
  String get onboardingPage1Title;

  /// First onboarding page description
  ///
  /// In en, this message translates to:
  /// **'Manage your restaurant operations efficiently with our comprehensive POS system'**
  String get onboardingPage1Description;

  /// Second onboarding page title
  ///
  /// In en, this message translates to:
  /// **'Easy Order Management'**
  String get onboardingPage2Title;

  /// Second onboarding page description
  ///
  /// In en, this message translates to:
  /// **'Take orders quickly and manage tables with our intuitive interface'**
  String get onboardingPage2Description;

  /// Third onboarding page title
  ///
  /// In en, this message translates to:
  /// **'Real-time Kitchen Display'**
  String get onboardingPage3Title;

  /// Third onboarding page description
  ///
  /// In en, this message translates to:
  /// **'Keep track of orders in real-time with our kitchen display system'**
  String get onboardingPage3Description;

  /// Fourth onboarding page title
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Reports'**
  String get onboardingPage4Title;

  /// Fourth onboarding page description
  ///
  /// In en, this message translates to:
  /// **'Generate detailed reports and analytics to optimize your business'**
  String get onboardingPage4Description;

  /// Onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Onboarding Screen'**
  String get onboardingScreen;

  /// Page label
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// Of text for pagination
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofText;

  /// Skip onboarding accessibility label
  ///
  /// In en, this message translates to:
  /// **'Skip onboarding and go to login'**
  String get skipOnboardingAndGoToLogin;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Onboarding content accessibility label
  ///
  /// In en, this message translates to:
  /// **'Onboarding content area'**
  String get onboardingContentArea;

  /// Previous page button accessibility label
  ///
  /// In en, this message translates to:
  /// **'Go to previous page'**
  String get goToPreviousPage;

  /// Complete onboarding button accessibility label
  ///
  /// In en, this message translates to:
  /// **'Complete onboarding and get started'**
  String get completeOnboardingAndGetStarted;

  /// Next page button accessibility label
  ///
  /// In en, this message translates to:
  /// **'Go to next page'**
  String get goToNextPage;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Bytes unit
  ///
  /// In en, this message translates to:
  /// **'bytes'**
  String get bytes;

  /// Error message for PDF generation
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF'**
  String get errorGeneratingPdf;

  /// Permission denied error message
  ///
  /// In en, this message translates to:
  /// **'Permission denied to open file'**
  String get permissionDeniedToOpenFile;

  /// Error message for PDF download
  ///
  /// In en, this message translates to:
  /// **'Error downloading PDF'**
  String get errorDownloadingPdf;

  /// Color picker dialog title
  ///
  /// In en, this message translates to:
  /// **'Pick Category Background Color'**
  String get pickCategoryBackgroundColor;

  /// Access denied message
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// Administrator access required message
  ///
  /// In en, this message translates to:
  /// **'This feature is only available to system administrators'**
  String get thisFeatureIsOnlyAvailableToSystemAdministrators;

  /// Error message for template loading
  ///
  /// In en, this message translates to:
  /// **'Error loading templates'**
  String get errorLoadingTemplates;

  /// No templates available message
  ///
  /// In en, this message translates to:
  /// **'No custom templates'**
  String get noCustomTemplates;

  /// Create first template message
  ///
  /// In en, this message translates to:
  /// **'Create your first custom template to get started'**
  String get createYourFirstCustomTemplateToGetStarted;

  /// Default text
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultText;

  /// Preview button text
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Set as default button text
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// Template set as default message
  ///
  /// In en, this message translates to:
  /// **'template set as default'**
  String get templateSetAsDefault;

  /// Error message for setting default template
  ///
  /// In en, this message translates to:
  /// **'Error setting default template'**
  String get errorSettingDefaultTemplate;

  /// Delete template dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Template'**
  String get deleteTemplate;

  /// Delete template confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the template'**
  String get areYouSureYouWantToDeleteTemplate;

  /// Template deleted success message
  ///
  /// In en, this message translates to:
  /// **'template deleted successfully'**
  String get templateDeletedSuccessfully;

  /// Error message for deleting template
  ///
  /// In en, this message translates to:
  /// **'Error deleting template'**
  String get errorDeletingTemplate;

  /// Create template dialog title
  ///
  /// In en, this message translates to:
  /// **'Create Custom Template'**
  String get createCustomTemplate;

  /// Template name field label
  ///
  /// In en, this message translates to:
  /// **'Template Name'**
  String get templateName;

  /// Template name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a template name'**
  String get pleaseEnterATemplateName;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// HTML content field label
  ///
  /// In en, this message translates to:
  /// **'HTML Content'**
  String get htmlContent;

  /// HTML content field hint
  ///
  /// In en, this message translates to:
  /// **'Enter HTML template content'**
  String get enterHtmlTemplateContent;

  /// HTML content validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter HTML content'**
  String get pleaseEnterHtmlContent;

  /// CSS content field label
  ///
  /// In en, this message translates to:
  /// **'CSS Content'**
  String get cssContent;

  /// CSS content field hint
  ///
  /// In en, this message translates to:
  /// **'Enter CSS styles'**
  String get enterCssStyles;

  /// Set as default template checkbox label
  ///
  /// In en, this message translates to:
  /// **'Set as Default Template'**
  String get setAsDefaultTemplate;

  /// Create button text
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Template created success message
  ///
  /// In en, this message translates to:
  /// **'Template created successfully'**
  String get templateCreatedSuccessfully;

  /// Error message for creating template
  ///
  /// In en, this message translates to:
  /// **'Error creating template'**
  String get errorCreatingTemplate;

  /// Edit template dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Custom Template'**
  String get editCustomTemplate;

  /// Template updated success message
  ///
  /// In en, this message translates to:
  /// **'Template updated successfully'**
  String get templateUpdatedSuccessfully;

  /// Error message for updating template
  ///
  /// In en, this message translates to:
  /// **'Error updating template'**
  String get errorUpdatingTemplate;

  /// Preview template dialog title
  ///
  /// In en, this message translates to:
  /// **'Preview Template'**
  String get previewTemplate;

  /// Information section title
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// New button text
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newText;

  /// Refresh recipes button tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh recipes'**
  String get refreshRecipes;

  /// All label
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Easy difficulty level
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Medium difficulty level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Hard difficulty level
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// Search recipes field hint
  ///
  /// In en, this message translates to:
  /// **'Search recipes...'**
  String get searchRecipes;

  /// Active only filter option
  ///
  /// In en, this message translates to:
  /// **'Active Only'**
  String get activeOnly;

  /// Searching recipes loading message
  ///
  /// In en, this message translates to:
  /// **'Searching recipes...'**
  String get searchingRecipes;

  /// Loading recipes message
  ///
  /// In en, this message translates to:
  /// **'Loading recipes...'**
  String get loadingRecipes;

  /// Unable to load recipes error message
  ///
  /// In en, this message translates to:
  /// **'Unable to load recipes'**
  String get unableToLoadRecipes;

  /// Connection error message
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get checkConnectionAndTryAgain;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No recipes found message
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get noRecipesFound;

  /// No recipes found for search query
  ///
  /// In en, this message translates to:
  /// **'No recipes found for query'**
  String get noRecipesFoundForQuery;

  /// Clear search button text
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No difficulty recipes message prefix
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noDifficultyRecipes;

  /// Try different difficulty message
  ///
  /// In en, this message translates to:
  /// **'Try a different difficulty or create a new recipe'**
  String get tryDifferentDifficultyOrCreateNew;

  /// Difficulty label
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// Prep time label
  ///
  /// In en, this message translates to:
  /// **'Prep Time'**
  String get prepTime;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Cook time label
  ///
  /// In en, this message translates to:
  /// **'Cook Time'**
  String get cookTime;

  /// Servings label
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// Ingredients label
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// Instructions label
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// Delete recipe dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Recipe'**
  String get deleteRecipe;

  /// Delete recipe confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the recipe'**
  String get deleteRecipeConfirmation;

  /// Recipe deleted success message
  ///
  /// In en, this message translates to:
  /// **'Recipe deleted successfully'**
  String get recipeDeletedSuccessfully;

  /// Failed to delete recipe error message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete recipe'**
  String get failedToDeleteRecipe;

  /// Template selection section title
  ///
  /// In en, this message translates to:
  /// **'Template Selection'**
  String get templateSelection;

  /// No templates available message
  ///
  /// In en, this message translates to:
  /// **'No templates available'**
  String get noTemplatesAvailable;

  /// Failed to load templates error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load templates'**
  String get failedToLoadTemplates;

  /// No inventory alerts available message
  ///
  /// In en, this message translates to:
  /// **'No inventory alerts available'**
  String get noInventoryAlertsAvailable;

  /// No expiring items alerts message
  ///
  /// In en, this message translates to:
  /// **'No expiring items alerts'**
  String get noExpiringItemsAlerts;

  /// No underperforming items alerts message
  ///
  /// In en, this message translates to:
  /// **'No underperforming items alerts'**
  String get noUnderperformingItemsAlerts;

  /// Item label
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// View details button text
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Cook recipe using message
  ///
  /// In en, this message translates to:
  /// **'Cook recipe using'**
  String get cookRecipeUsing;

  /// Unknown item label
  ///
  /// In en, this message translates to:
  /// **'Unknown Item'**
  String get unknownItem;

  /// This will message
  ///
  /// In en, this message translates to:
  /// **'This will'**
  String get thisWill;

  /// Consume inventory items bullet point
  ///
  /// In en, this message translates to:
  /// **'• Consume inventory items'**
  String get consumeInventoryItems;

  /// Reduce waste bullet point
  ///
  /// In en, this message translates to:
  /// **'• Reduce waste'**
  String get reduceWaste;

  /// Bar screen title
  ///
  /// In en, this message translates to:
  /// **'Bar Screen'**
  String get barScreen;

  /// Kitchen orders title
  ///
  /// In en, this message translates to:
  /// **'Kitchen Orders'**
  String get kitchenOrders;

  /// Refresh orders button
  ///
  /// In en, this message translates to:
  /// **'Refresh Orders'**
  String get refreshOrders;

  /// All caught up message
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUp;

  /// Loading kitchen orders message
  ///
  /// In en, this message translates to:
  /// **'Loading kitchen orders...'**
  String get loadingKitchenOrders;

  /// Error loading orders message
  ///
  /// In en, this message translates to:
  /// **'Error loading orders'**
  String get errorLoadingOrders;

  /// Check connection message
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again'**
  String get pleaseCheckConnectionAndTryAgain;

  /// Order label
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// Urgent label
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// Table label
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// Prepare button text
  ///
  /// In en, this message translates to:
  /// **'Prepare'**
  String get prepare;

  /// Ready status
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get ready;

  /// Complete status
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// Read only mode label
  ///
  /// In en, this message translates to:
  /// **'Read Only Mode'**
  String get readOnlyMode;

  /// Order for table label
  ///
  /// In en, this message translates to:
  /// **'Order for Table'**
  String get orderForTable;

  /// Loading table orders message
  ///
  /// In en, this message translates to:
  /// **'Loading table orders...'**
  String get loadingTableOrders;

  /// Customer details label
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// Customer name label
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerNameLabel;

  /// Enter customer name hint
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enterCustomerName;

  /// Special instructions label
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get specialInstructions;

  /// Special instructions hint
  ///
  /// In en, this message translates to:
  /// **'Any special instructions for the order'**
  String get specialInstructionsHint;

  /// Menu items label
  ///
  /// In en, this message translates to:
  /// **'Menu Items'**
  String get menuItems;

  /// No menu items available message
  ///
  /// In en, this message translates to:
  /// **'No menu items available'**
  String get noMenuItemsAvailable;

  /// Menu items temporarily unavailable message
  ///
  /// In en, this message translates to:
  /// **'Menu items temporarily unavailable'**
  String get menuItemsTemporarilyUnavailable;

  /// Existing order items message
  ///
  /// In en, this message translates to:
  /// **'Existing order items will still be shown'**
  String get existingOrderItemsWillStillBeShown;

  /// Unavailable status
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Order items count label
  ///
  /// In en, this message translates to:
  /// **'Order Items Count'**
  String get orderItemsCount;

  /// No items in cart message
  ///
  /// In en, this message translates to:
  /// **'No items in cart'**
  String get noItemsInCart;

  /// Subtotal label
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Tax label
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// Total with colon
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get totalWithColon;

  /// Submitting message
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// Submit order button text
  ///
  /// In en, this message translates to:
  /// **'Submit Order'**
  String get submitOrder;

  /// Please add items to order message
  ///
  /// In en, this message translates to:
  /// **'Please add items to your order'**
  String get pleaseAddItemsToOrder;

  /// Order submitted successfully message
  ///
  /// In en, this message translates to:
  /// **'Order submitted successfully'**
  String get orderSubmittedSuccessfully;

  /// Failed to submit order message
  ///
  /// In en, this message translates to:
  /// **'Failed to submit order'**
  String get failedToSubmitOrder;

  /// Refresh tables button
  ///
  /// In en, this message translates to:
  /// **'Refresh Tables'**
  String get refreshTables;

  /// No floor plans available message
  ///
  /// In en, this message translates to:
  /// **'No floor plans available'**
  String get noFloorPlansAvailable;

  /// Floor plan view label
  ///
  /// In en, this message translates to:
  /// **'Floor Plan View'**
  String get floorPlanView;

  /// Search tables label
  ///
  /// In en, this message translates to:
  /// **'Search Tables'**
  String get searchTables;

  /// Loading tables message
  ///
  /// In en, this message translates to:
  /// **'Loading tables...'**
  String get loadingTables;

  /// Error loading tables message
  ///
  /// In en, this message translates to:
  /// **'Error loading tables'**
  String get errorLoadingTables;

  /// No tables found matching search
  ///
  /// In en, this message translates to:
  /// **'No tables found matching your search'**
  String get noTablesFoundMatching;

  /// No available tables message
  ///
  /// In en, this message translates to:
  /// **'No available tables'**
  String get noAvailableTables;

  /// No occupied tables message
  ///
  /// In en, this message translates to:
  /// **'No occupied tables'**
  String get noOccupiedTables;

  /// No reserved tables message
  ///
  /// In en, this message translates to:
  /// **'No reserved tables'**
  String get noReservedTables;

  /// No tables being cleaned message
  ///
  /// In en, this message translates to:
  /// **'No tables being cleaned'**
  String get noTablesBeingCleaned;

  /// No tables found message
  ///
  /// In en, this message translates to:
  /// **'No tables found'**
  String get noTablesFound;

  /// Check back later message
  ///
  /// In en, this message translates to:
  /// **'Check back later or try a different filter'**
  String get checkBackLaterOrTryDifferentFilter;

  /// Seats label
  ///
  /// In en, this message translates to:
  /// **'seats'**
  String get seats;

  /// Select open order title
  ///
  /// In en, this message translates to:
  /// **'Select Open Order'**
  String get selectOpenOrder;

  /// Details label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Capacity label
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// Customer label
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// Assigned to label
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assignedTo;

  /// Last activity label
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivity;

  /// Reservation label
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get reservation;

  /// Order items label
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get orderItems;

  /// No items label
  ///
  /// In en, this message translates to:
  /// **'No Items'**
  String get noItems;

  /// Reserve table action
  ///
  /// In en, this message translates to:
  /// **'Reserve Table'**
  String get reserveTable;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Select time label
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// Placeholder text
  ///
  /// In en, this message translates to:
  /// **'placeholder'**
  String get placeholder;

  /// Reserve button
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// Seat customer at table action
  ///
  /// In en, this message translates to:
  /// **'Seat Customer at Table'**
  String get seatCustomerAtTable;

  /// Party size label
  ///
  /// In en, this message translates to:
  /// **'Party Size'**
  String get partySize;

  /// Please enter valid name and party size message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name and party size'**
  String get pleaseEnterValidNameAndPartySize;

  /// Customer seated at table message
  ///
  /// In en, this message translates to:
  /// **'Customer seated at table'**
  String get customerSeatedAtTable;

  /// Failed to seat customer error
  ///
  /// In en, this message translates to:
  /// **'Failed to seat customer'**
  String get failedToSeatCustomer;

  /// Seat button
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get seat;

  /// Clearing table action
  ///
  /// In en, this message translates to:
  /// **'Clearing table'**
  String get clearingTable;

  /// Table cleared successfully message
  ///
  /// In en, this message translates to:
  /// **'cleared successfully'**
  String get clearedSuccessfully;

  /// Failed to clear table error
  ///
  /// In en, this message translates to:
  /// **'Failed to clear table'**
  String get failedToClearTable;

  /// Check in reservation for table action
  ///
  /// In en, this message translates to:
  /// **'Check in Reservation for Table'**
  String get checkInReservationForTable;

  /// Reservation checked in for table message
  ///
  /// In en, this message translates to:
  /// **'Reservation checked in for table'**
  String get reservationCheckedInForTable;

  /// Failed to check in error
  ///
  /// In en, this message translates to:
  /// **'Failed to check in'**
  String get failedToCheckIn;

  /// Check in button
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// View button
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Add items button
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get addItems;

  /// Waiter label
  ///
  /// In en, this message translates to:
  /// **'Waiter'**
  String get waiter;

  /// Ready to serve customers message
  ///
  /// In en, this message translates to:
  /// **'Ready to serve customers'**
  String get readyToServeCustomers;

  /// Active tables label
  ///
  /// In en, this message translates to:
  /// **'Active Tables'**
  String get activeTables;

  /// Pending orders label
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pendingOrders;

  /// Today's tips label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tips'**
  String get todaysTips;

  /// Order history label
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// View past orders button
  ///
  /// In en, this message translates to:
  /// **'View Past Orders'**
  String get viewPastOrders;

  /// Manage customer details button
  ///
  /// In en, this message translates to:
  /// **'Manage Customer Details'**
  String get manageCustomerDetails;

  /// Customer information label
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformation;

  /// Inventory check label
  ///
  /// In en, this message translates to:
  /// **'Inventory Check'**
  String get inventoryCheck;

  /// Check item availability button
  ///
  /// In en, this message translates to:
  /// **'Check Item Availability'**
  String get checkItemAvailability;

  /// Daily report label
  ///
  /// In en, this message translates to:
  /// **'Daily Report'**
  String get dailyReport;

  /// View daily summary button
  ///
  /// In en, this message translates to:
  /// **'View Daily Summary'**
  String get viewDailySummary;

  /// Table order completed message
  ///
  /// In en, this message translates to:
  /// **'Table order completed'**
  String get tableOrderCompleted;

  /// Order completed lowercase
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get orderCompletedLowercase;

  /// New customer at table message
  ///
  /// In en, this message translates to:
  /// **'New customer at table'**
  String get newCustomerAtTable;

  /// Kitchen notification table ready message
  ///
  /// In en, this message translates to:
  /// **'Kitchen notification: table ready'**
  String get kitchenNotificationTableReady;

  /// Ready lowercase
  ///
  /// In en, this message translates to:
  /// **'ready'**
  String get readyLowercase;

  /// Promotion updated message
  ///
  /// In en, this message translates to:
  /// **'Promotion updated'**
  String get promotionUpdated;

  /// Happy hour special label
  ///
  /// In en, this message translates to:
  /// **'Happy Hour Special'**
  String get happyHourSpecial;

  /// Coming soon label
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Today's orders label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get todaysOrders;

  /// Tips earned label
  ///
  /// In en, this message translates to:
  /// **'Tips Earned'**
  String get tipsEarned;

  /// View tables button text
  ///
  /// In en, this message translates to:
  /// **'View Tables'**
  String get viewTables;

  /// Kitchen view button text
  ///
  /// In en, this message translates to:
  /// **'Kitchen View'**
  String get kitchenView;

  /// Messages and promotions label
  ///
  /// In en, this message translates to:
  /// **'Messages & Promotions'**
  String get messagesAndPromotions;

  /// Created label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Mark as read button
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// No messages or promotions message
  ///
  /// In en, this message translates to:
  /// **'No messages or promotions'**
  String get noMessagesOrPromotions;

  /// Check back later for updates message
  ///
  /// In en, this message translates to:
  /// **'Check back later for updates'**
  String get checkBackLaterForUpdates;

  /// Error loading messages message
  ///
  /// In en, this message translates to:
  /// **'Error loading messages'**
  String get errorLoadingMessages;

  /// Today's performance label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Performance'**
  String get todaysPerformance;

  /// Recent orders label
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// Split bill button text
  ///
  /// In en, this message translates to:
  /// **'Split Bill'**
  String get splitBill;

  /// Content options section title
  ///
  /// In en, this message translates to:
  /// **'Content Options'**
  String get contentOptions;

  /// Include prices option
  ///
  /// In en, this message translates to:
  /// **'Include Prices'**
  String get includePrices;

  /// Show item prices in menu description
  ///
  /// In en, this message translates to:
  /// **'Show item prices in menu'**
  String get showItemPricesInMenu;

  /// Include descriptions option
  ///
  /// In en, this message translates to:
  /// **'Include Descriptions'**
  String get includeDescriptions;

  /// Show item descriptions in menu description
  ///
  /// In en, this message translates to:
  /// **'Show item descriptions in menu'**
  String get showItemDescriptions;

  /// Include allergens option
  ///
  /// In en, this message translates to:
  /// **'Include Allergens'**
  String get includeAllergens;

  /// Show allergen information description
  ///
  /// In en, this message translates to:
  /// **'Show allergen information'**
  String get showAllergenInformation;

  /// Include calories option
  ///
  /// In en, this message translates to:
  /// **'Include Calories'**
  String get includeCalories;

  /// Show calorie information description
  ///
  /// In en, this message translates to:
  /// **'Show calorie information'**
  String get showCalorieInformation;

  /// Include item images option
  ///
  /// In en, this message translates to:
  /// **'Include Item Images'**
  String get includeItemImages;

  /// Show menu item images in PDF description
  ///
  /// In en, this message translates to:
  /// **'Show menu item images in PDF'**
  String get showMenuItemImagesInPdf;

  /// Include business logo option
  ///
  /// In en, this message translates to:
  /// **'Include Business Logo'**
  String get includeBusinessLogo;

  /// Show business logo in PDF header description
  ///
  /// In en, this message translates to:
  /// **'Show business logo in PDF header'**
  String get showBusinessLogoInPdfHeader;

  /// Layout options section title
  ///
  /// In en, this message translates to:
  /// **'Layout Options'**
  String get layoutOptions;

  /// Orientation field label
  ///
  /// In en, this message translates to:
  /// **'Orientation'**
  String get orientation;

  /// Portrait orientation
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get portrait;

  /// Landscape orientation
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get landscape;

  /// Font size field label
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// Small font size
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// Large font size
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// Color scheme field label
  ///
  /// In en, this message translates to:
  /// **'Color Scheme'**
  String get colorScheme;

  /// Light color scheme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark color scheme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Auto color scheme
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// Category layout options section title
  ///
  /// In en, this message translates to:
  /// **'Category Layout Options'**
  String get categoryLayoutOptions;

  /// Category layout field label
  ///
  /// In en, this message translates to:
  /// **'Category Layout'**
  String get categoryLayout;

  /// Category layout helper text
  ///
  /// In en, this message translates to:
  /// **'How categories are organized in the PDF'**
  String get howCategoriesAreOrganizedInPdf;

  /// Same page category layout option
  ///
  /// In en, this message translates to:
  /// **'Same page - category items together'**
  String get samePageCategoryItemsTogether;

  /// Separate page category layout option
  ///
  /// In en, this message translates to:
  /// **'Separate page - category title page, items on pages'**
  String get separatePageCategoryTitlePageItemsPages;

  /// Category background color field label
  ///
  /// In en, this message translates to:
  /// **'Category Background Color'**
  String get categoryBackgroundColor;

  /// Hex color code example
  ///
  /// In en, this message translates to:
  /// **'Hex color code (e.g., #0066CC)'**
  String get hexColorCodeExample;

  /// Max items per page field label
  ///
  /// In en, this message translates to:
  /// **'Max Items Per Page'**
  String get maxItemsPerPage;

  /// Default colon text
  ///
  /// In en, this message translates to:
  /// **'Default:'**
  String get defaultColon;

  /// Generating PDF loading message
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdf;

  /// Generate PDF menu button text
  ///
  /// In en, this message translates to:
  /// **'Generate PDF Menu'**
  String get generatePdfMenu;

  /// Please select template message
  ///
  /// In en, this message translates to:
  /// **'Please select a template'**
  String get pleaseSelectTemplate;

  /// PDF generated successfully message
  ///
  /// In en, this message translates to:
  /// **'PDF generated successfully'**
  String get pdfGeneratedSuccessfully;

  /// Access denied description
  ///
  /// In en, this message translates to:
  /// **'This feature is only available to system administrators'**
  String get accessDeniedDescription;

  /// Go back button text
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Add menu item button text
  ///
  /// In en, this message translates to:
  /// **'Add Menu Item'**
  String get addMenuItem;

  /// Select business field label
  ///
  /// In en, this message translates to:
  /// **'Select Business'**
  String get selectBusiness;

  /// Select one business message
  ///
  /// In en, this message translates to:
  /// **'Select one business'**
  String get selectOneBusiness;

  /// Search menu items field label
  ///
  /// In en, this message translates to:
  /// **'Search menu items'**
  String get searchMenuItems;

  /// Category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// All categories option
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// Available only filter option
  ///
  /// In en, this message translates to:
  /// **'Available Only'**
  String get availableOnly;

  /// Clear filters button text
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Select a business message
  ///
  /// In en, this message translates to:
  /// **'Select a business'**
  String get selectABusiness;

  /// Please select a business from dropdown message
  ///
  /// In en, this message translates to:
  /// **'Please select a business from the dropdown'**
  String get pleaseSelectABusinessFromDropdown;

  /// Error loading menu items message
  ///
  /// In en, this message translates to:
  /// **'Error loading menu items'**
  String get errorLoadingMenuItems;

  /// No menu items found message
  ///
  /// In en, this message translates to:
  /// **'No menu items found'**
  String get noMenuItemsFound;

  /// Try adjusting filters or add new menu item message
  ///
  /// In en, this message translates to:
  /// **'Try adjusting filters or add a new menu item'**
  String get tryAdjustingFiltersOrAddNewMenuItem;

  /// Category ID field label
  ///
  /// In en, this message translates to:
  /// **'Category ID'**
  String get categoryId;

  /// Make unavailable button text
  ///
  /// In en, this message translates to:
  /// **'Make Unavailable'**
  String get makeUnavailable;

  /// Delete menu item dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Menu Item'**
  String get deleteMenuItem;

  /// Menu item deleted success message
  ///
  /// In en, this message translates to:
  /// **'Menu item deleted successfully'**
  String get menuItemDeletedSuccessfully;

  /// Error deleting menu item message
  ///
  /// In en, this message translates to:
  /// **'Error deleting menu item'**
  String get errorDeletingMenuItem;

  /// Menu item made unavailable message
  ///
  /// In en, this message translates to:
  /// **'made unavailable'**
  String get menuItemMadeUnavailable;

  /// Menu item made available message
  ///
  /// In en, this message translates to:
  /// **'made available'**
  String get menuItemMadeAvailable;

  /// Successfully message
  ///
  /// In en, this message translates to:
  /// **'successfully'**
  String get successfully;

  /// Error updating menu item availability message
  ///
  /// In en, this message translates to:
  /// **'Error updating menu item availability'**
  String get errorUpdatingMenuItemAvailability;

  /// Create menu item dialog title
  ///
  /// In en, this message translates to:
  /// **'Create Menu Item'**
  String get createMenuItem;

  /// Business field label
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// Please select a category message
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectACategory;

  /// Please select a business first message
  ///
  /// In en, this message translates to:
  /// **'Please select a business first'**
  String get pleaseSelectABusinessFirst;

  /// Menu item created success message
  ///
  /// In en, this message translates to:
  /// **'Menu item created successfully'**
  String get menuItemCreatedSuccessfully;

  /// Error creating menu item message
  ///
  /// In en, this message translates to:
  /// **'Error creating menu item'**
  String get errorCreatingMenuItem;

  /// Edit menu item dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Menu Item'**
  String get editMenuItem;

  /// Menu item updated success message
  ///
  /// In en, this message translates to:
  /// **'Menu item updated successfully'**
  String get menuItemUpdatedSuccessfully;

  /// Error updating menu item message
  ///
  /// In en, this message translates to:
  /// **'Error updating menu item'**
  String get errorUpdatingMenuItem;

  /// System administration title
  ///
  /// In en, this message translates to:
  /// **'System Administration'**
  String get systemAdministration;

  /// Multi-tenant POS management title
  ///
  /// In en, this message translates to:
  /// **'Multi-Tenant POS Management'**
  String get multiTenantPosManagement;

  /// Multi-tenant POS description
  ///
  /// In en, this message translates to:
  /// **'Manage multiple businesses and their POS systems'**
  String get multiTenantPosDescription;

  /// System overview title
  ///
  /// In en, this message translates to:
  /// **'System Overview'**
  String get systemOverview;

  /// Total businesses label
  ///
  /// In en, this message translates to:
  /// **'Total Businesses'**
  String get totalBusinesses;

  /// Active users label
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// Smart recipe suggestions label
  ///
  /// In en, this message translates to:
  /// **'Smart Recipe Suggestions'**
  String get smartRecipeSuggestions;

  /// Cooked label
  ///
  /// In en, this message translates to:
  /// **'Cooked'**
  String get cooked;

  /// Waste prevention label
  ///
  /// In en, this message translates to:
  /// **'Waste Prevention'**
  String get wastePrevention;

  /// No pending suggestions available message
  ///
  /// In en, this message translates to:
  /// **'No pending suggestions available'**
  String get noPendingSuggestionsAvailable;

  /// High urgency label
  ///
  /// In en, this message translates to:
  /// **'High Urgency'**
  String get highUrgency;

  /// Medium urgency label
  ///
  /// In en, this message translates to:
  /// **'Medium Urgency'**
  String get mediumUrgency;

  /// Low urgency label
  ///
  /// In en, this message translates to:
  /// **'Low Urgency'**
  String get lowUrgency;

  /// No cooked suggestions available message
  ///
  /// In en, this message translates to:
  /// **'No cooked suggestions available'**
  String get noCookedSuggestionsAvailable;

  /// No suggestions available message
  ///
  /// In en, this message translates to:
  /// **'No suggestions available'**
  String get noSuggestionsAvailable;

  /// Error loading waste prevention data message
  ///
  /// In en, this message translates to:
  /// **'Error loading waste prevention data'**
  String get errorLoadingWastePreventionData;

  /// No smart recipe suggestions available message
  ///
  /// In en, this message translates to:
  /// **'No smart recipe suggestions available'**
  String get noSmartRecipeSuggestionsAvailable;

  /// Confidence label
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// Potential savings label
  ///
  /// In en, this message translates to:
  /// **'Potential Savings'**
  String get potentialSavings;

  /// Matching ingredients label
  ///
  /// In en, this message translates to:
  /// **'Matching Ingredients'**
  String get matchingIngredients;

  /// Already cooked label
  ///
  /// In en, this message translates to:
  /// **'Already Cooked'**
  String get alreadyCooked;

  /// Cooked on label
  ///
  /// In en, this message translates to:
  /// **'Cooked On'**
  String get cookedOn;

  /// Ingredients used label
  ///
  /// In en, this message translates to:
  /// **'Ingredients Used'**
  String get ingredientsUsed;

  /// Recipe cooked successfully message
  ///
  /// In en, this message translates to:
  /// **'Recipe cooked successfully'**
  String get recipeCookedSuccessfully;

  /// Cook recipe title
  ///
  /// In en, this message translates to:
  /// **'Cook Recipe'**
  String get cookRecipeTitle;

  /// Recipe configuration label
  ///
  /// In en, this message translates to:
  /// **'Recipe Configuration'**
  String get recipeConfiguration;

  /// This will create promotion message
  ///
  /// In en, this message translates to:
  /// **'This will create a promotion with the same quantity'**
  String get thisWillCreatePromotionWithSameQuantity;

  /// Chef special example label
  ///
  /// In en, this message translates to:
  /// **'Chef\'s Special Example'**
  String get chefSpecialExample;

  /// Quantity must be greater than 0 message
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get quantityMustBeGreaterThan0;

  /// Create promotion for label
  ///
  /// In en, this message translates to:
  /// **'Create Promotion for'**
  String get createPromotionFor;

  /// Create promotion to help move inventory message
  ///
  /// In en, this message translates to:
  /// **'Create a promotion to help move inventory'**
  String get createAPromotionToHelpMoveInventory;

  /// Chef special discount example label
  ///
  /// In en, this message translates to:
  /// **'Chef\'s Special Discount Example'**
  String get chefSpecialDiscountExample;

  /// Cooking recipe message
  ///
  /// In en, this message translates to:
  /// **'Cooking recipe...'**
  String get cookingRecipe;

  /// Recipe label
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get recipe;

  /// Quantity cooked label
  ///
  /// In en, this message translates to:
  /// **'Quantity Cooked'**
  String get quantityCooked;

  /// Cost savings label
  ///
  /// In en, this message translates to:
  /// **'Cost Savings'**
  String get costSavings;

  /// Failed to cook recipe message
  ///
  /// In en, this message translates to:
  /// **'Failed to cook recipe'**
  String get failedToCookRecipe;

  /// Not available label
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// Promotions management screen title
  ///
  /// In en, this message translates to:
  /// **'Promotions Management'**
  String get promotionsManagement;

  /// Error loading promotions message
  ///
  /// In en, this message translates to:
  /// **'Error loading promotions'**
  String get errorLoadingPromotions;

  /// No promotions yet message
  ///
  /// In en, this message translates to:
  /// **'No promotions yet'**
  String get noPromotionsYet;

  /// Create first promotion message
  ///
  /// In en, this message translates to:
  /// **'Create your first promotion to get started'**
  String get createYourFirstPromotionToGetStarted;

  /// Scheduled status
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// Expired status
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// Create promotion form placeholder
  ///
  /// In en, this message translates to:
  /// **'Create promotion form will be implemented here'**
  String get createPromotionFormWillBeImplemented;

  /// Edit promotion title
  ///
  /// In en, this message translates to:
  /// **'Edit Promotion'**
  String get editPromotion;

  /// Edit promotion form placeholder
  ///
  /// In en, this message translates to:
  /// **'Edit promotion form will be implemented here'**
  String get editPromotionFormWillBeImplemented;

  /// Delete promotion title
  ///
  /// In en, this message translates to:
  /// **'Delete Promotion'**
  String get deletePromotion;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get areYouSureYouWantToDelete;

  /// Create chef special promotion title
  ///
  /// In en, this message translates to:
  /// **'Create Chef Special Promotion'**
  String get createChefSpecialPromotion;

  /// Available recipes section title
  ///
  /// In en, this message translates to:
  /// **'Available Recipes'**
  String get availableRecipes;

  /// Error loading recipes message
  ///
  /// In en, this message translates to:
  /// **'Error loading recipes'**
  String get errorLoadingRecipes;

  /// No recipe suggestions available message
  ///
  /// In en, this message translates to:
  /// **'No recipe suggestions available'**
  String get noRecipeSuggestionsAvailable;

  /// Quantity field label
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Waste reduction section title
  ///
  /// In en, this message translates to:
  /// **'Waste Reduction'**
  String get wasteReduction;

  /// Promotion created label
  ///
  /// In en, this message translates to:
  /// **'Promotion Created:'**
  String get promotionCreated;

  /// Type field label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Quantity tracking label
  ///
  /// In en, this message translates to:
  /// **'Quantity Tracking:'**
  String get quantityTracking;

  /// Total quantity label
  ///
  /// In en, this message translates to:
  /// **'Total Quantity'**
  String get totalQuantity;

  /// Used quantity label
  ///
  /// In en, this message translates to:
  /// **'Used Quantity'**
  String get usedQuantity;

  /// Remaining label
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// Expires label
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// Special offer label
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get specialOffer;

  /// Selected items label
  ///
  /// In en, this message translates to:
  /// **'Selected Items'**
  String get selectedItems;

  /// No description placeholder
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// Cook button text
  ///
  /// In en, this message translates to:
  /// **'Cook'**
  String get cook;

  /// Freshly prepared description
  ///
  /// In en, this message translates to:
  /// **'Freshly prepared'**
  String get freshlyPrepared;

  /// Using premium ingredients description
  ///
  /// In en, this message translates to:
  /// **'using premium ingredients'**
  String get usingPremiumIngredients;

  /// Create promotion with quantity tracking bullet point
  ///
  /// In en, this message translates to:
  /// **'• Create a promotion with quantity tracking'**
  String get createPromotionWithQuantityTracking;

  /// Create promotion for expiring items description
  ///
  /// In en, this message translates to:
  /// **'Create a promotion for expiring or underperforming items'**
  String get createAPromotionForExpiringOrUnderperformingItems;

  /// Create targeted promotions description
  ///
  /// In en, this message translates to:
  /// **'Create targeted promotions'**
  String get createTargetedPromotions;

  /// Help move inventory description
  ///
  /// In en, this message translates to:
  /// **'help move inventory'**
  String get helpMoveInventory;

  /// Increase sales and reduce waste description
  ///
  /// In en, this message translates to:
  /// **'increase sales and reduce waste'**
  String get increaseSalesAndReduceWaste;

  /// Cooking analytics section title
  ///
  /// In en, this message translates to:
  /// **'Cooking Analytics'**
  String get cookingAnalytics;

  /// Error loading analytics message
  ///
  /// In en, this message translates to:
  /// **'Error loading analytics'**
  String get errorLoadingAnalytics;

  /// Total recipes cooked label
  ///
  /// In en, this message translates to:
  /// **'Total Recipes Cooked'**
  String get totalRecipesCooked;

  /// Waste reduced label
  ///
  /// In en, this message translates to:
  /// **'Waste Reduced'**
  String get wasteReduced;

  /// Promotions created label
  ///
  /// In en, this message translates to:
  /// **'Promotions Created'**
  String get promotionsCreated;

  /// Error loading history message
  ///
  /// In en, this message translates to:
  /// **'Error loading history'**
  String get errorLoadingHistory;

  /// No cooking history yet message
  ///
  /// In en, this message translates to:
  /// **'No cooking history yet'**
  String get noCookingHistoryYet;

  /// Start cooking recipes message
  ///
  /// In en, this message translates to:
  /// **'Start cooking recipes to see your history here'**
  String get startCookingRecipesToSeeYourHistoryHere;

  /// Unknown recipe placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown recipe'**
  String get unknownRecipe;

  /// Date field label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Unknown date placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get unknownDate;

  /// Invalid date message
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get invalidDate;

  /// Urgency field label
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get urgency;

  /// Floor plan editor screen title
  ///
  /// In en, this message translates to:
  /// **'Floor Plan Editor'**
  String get floorPlanEditor;

  /// Send button text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Reply button text
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// Call button text
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// Restart app button text
  ///
  /// In en, this message translates to:
  /// **'Restart App'**
  String get restartApp;

  /// Clear data button text
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// Clear table button text
  ///
  /// In en, this message translates to:
  /// **'Clear Table'**
  String get clearTable;

  /// Seat customer button text
  ///
  /// In en, this message translates to:
  /// **'Seat Customer'**
  String get seatCustomer;

  /// Make reservation button text
  ///
  /// In en, this message translates to:
  /// **'Make Reservation'**
  String get makeReservation;

  /// Tables management screen title
  ///
  /// In en, this message translates to:
  /// **'Tables Management'**
  String get tablesManagement;

  /// New message dialog title
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessage;

  /// Emergency call dialog title
  ///
  /// In en, this message translates to:
  /// **'Emergency Call'**
  String get emergencyCall;

  /// Emergency call confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to make an emergency call?'**
  String get emergencyCallConfirmation;

  /// Preparing status
  ///
  /// In en, this message translates to:
  /// **'PREPARING'**
  String get preparing;

  /// Language settings screen title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language updated message
  ///
  /// In en, this message translates to:
  /// **'Language Updated'**
  String get languageUpdated;

  /// Floor plan viewer screen title
  ///
  /// In en, this message translates to:
  /// **'Floor Plan Viewer'**
  String get floorPlanViewer;

  /// Clear table confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear this table? This will mark it as available.'**
  String get clearTableConfirmation;

  /// Unassigned items label
  ///
  /// In en, this message translates to:
  /// **'Unassigned Items:'**
  String get unassignedItems;

  /// No items assigned message
  ///
  /// In en, this message translates to:
  /// **'No items assigned.'**
  String get noItemsAssigned;

  /// Checkout button text
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Complete sale button text
  ///
  /// In en, this message translates to:
  /// **'Complete Sale'**
  String get completeSale;

  /// Scan barcode dialog title
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// Enter barcode manually instruction
  ///
  /// In en, this message translates to:
  /// **'Enter barcode manually or use camera scanner:'**
  String get enterBarcodeManually;

  /// Available discounts dialog title
  ///
  /// In en, this message translates to:
  /// **'Available Discounts'**
  String get availableDiscounts;

  /// How many guests question
  ///
  /// In en, this message translates to:
  /// **'How many guests will be dining?'**
  String get howManyGuests;

  /// Set button text
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// Select promotion dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Promotion'**
  String get selectPromotion;

  /// Network error dialog title
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkError;

  /// Add step button text
  ///
  /// In en, this message translates to:
  /// **'Add Step'**
  String get addStep;

  /// Position in pixels label
  ///
  /// In en, this message translates to:
  /// **'Position (pixels)'**
  String get positionPixels;

  /// Size in pixels label
  ///
  /// In en, this message translates to:
  /// **'Size (pixels)'**
  String get sizePixels;

  /// Add table button text
  ///
  /// In en, this message translates to:
  /// **'Add Table'**
  String get addTable;

  /// i18n test screen title
  ///
  /// In en, this message translates to:
  /// **'i18n Test Screen'**
  String get i18nTestScreen;

  /// Spanish Costa Rica language option
  ///
  /// In en, this message translates to:
  /// **'Spanish (es-CR)'**
  String get spanishCostaRica;

  /// English US language option
  ///
  /// In en, this message translates to:
  /// **'English (en-US)'**
  String get englishUS;

  /// Language switching bullet point
  ///
  /// In en, this message translates to:
  /// **'• Language switching'**
  String get languageSwitching;

  /// Language persistence bullet point
  ///
  /// In en, this message translates to:
  /// **'• Language persistence'**
  String get languagePersistence;

  /// Locale management bullet point
  ///
  /// In en, this message translates to:
  /// **'• Locale management'**
  String get localeManagement;

  /// Translation display bullet point
  ///
  /// In en, this message translates to:
  /// **'• Translation display'**
  String get translationDisplay;

  /// Language testing screen title
  ///
  /// In en, this message translates to:
  /// **'Language Testing'**
  String get languageTesting;

  /// Switch to Spanish button text
  ///
  /// In en, this message translates to:
  /// **'Switch to Spanish'**
  String get switchToSpanish;

  /// Switch to English button text
  ///
  /// In en, this message translates to:
  /// **'Switch to English'**
  String get switchToEnglish;

  /// Test language switching button text
  ///
  /// In en, this message translates to:
  /// **'Test Language Switching'**
  String get testLanguageSwitching;

  /// Test default language button text
  ///
  /// In en, this message translates to:
  /// **'Test Default Language (Spanish)'**
  String get testDefaultLanguage;

  /// Test error messages button text
  ///
  /// In en, this message translates to:
  /// **'Test Error Messages (Spanish)'**
  String get testErrorMessages;

  /// Test success messages button text
  ///
  /// In en, this message translates to:
  /// **'Test Success Messages (Spanish)'**
  String get testSuccessMessages;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case 'CR':
            return AppLocalizationsEsCr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
