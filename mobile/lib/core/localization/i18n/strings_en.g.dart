///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Welcome Back'
	String get welcomeBack => 'Welcome Back';

	/// en: 'Sign in to continue your journey'
	String get signInToContinue => 'Sign in to continue your journey';

	/// en: 'Email Address'
	String get emailAddress => 'Email Address';

	/// en: 'john@example.com'
	String get emailPlaceholder => 'john@example.com';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Sign In'
	String get signIn => 'Sign In';

	/// en: 'Don't have an account?'
	String get dontHaveAccount => 'Don\'t have an account?';

	/// en: 'Create Account'
	String get createAccount => 'Create Account';

	/// en: 'User not found'
	String get userNotFound => 'User not found';

	/// en: 'User already exists'
	String get userAlreadyExists => 'User already exists';

	/// en: 'Invalid credentials'
	String get invalidCredentials => 'Invalid credentials';

	/// en: 'Invalid email'
	String get invalidEmail => 'Invalid email';

	/// en: 'Invalid password'
	String get invalidPassword => 'Invalid password';

	/// en: 'Create Your Account'
	String get createYourAccount => 'Create Your Account';

	/// en: 'Join FDL and start your e-bike journey'
	String get joinFDLAndStart => 'Join FDL and start your e-bike journey';

	/// en: 'Full Name'
	String get fullName => 'Full Name';

	/// en: 'John Doe'
	String get fullNamePlaceholder => 'John Doe';

	/// en: 'Confirm Password'
	String get confirmPassword => 'Confirm Password';

	/// en: 'Already have an account?'
	String get alreadyHaveAccount => 'Already have an account?';

	/// en: 'Account created successfully'
	String get registerSuccess => 'Account created successfully';

	/// en: 'Login successful'
	String get loginSuccess => 'Login successful';

	/// en: 'FDL Bikes'
	String get appTitle => 'FDL Bikes';

	/// en: 'Electric Mobility'
	String get appSubtitle => 'Electric Mobility';

	/// en: 'Rental Packages'
	String get rentalPackages => 'Rental Packages';

	/// en: 'Choose the plan that fits your lifestyle.'
	String get rentalPackagesDescription => 'Choose the plan that fits your lifestyle.';

	/// en: 'FDL Bikes'
	String get electrumBikes => 'FDL Bikes';

	/// en: 'Discover our fleet of premium electric bikes.'
	String get electrumBikesDescription => 'Discover our fleet of premium electric bikes.';

	/// en: 'Range'
	String get range => 'Range';

	/// en: 'View Details'
	String get viewDetails => 'View Details';

	/// en: 'Available'
	String get available => 'Available';

	/// en: 'Limited'
	String get limited => 'Limited';

	/// en: 'Unavailable'
	String get unavailable => 'Unavailable';

	/// en: 'Most Popular'
	String get mostPopular => 'Most Popular';

	/// en: 'Day'
	String get day => 'Day';

	/// en: 'Week'
	String get week => 'Week';

	/// en: 'Month'
	String get month => 'Month';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'No bikes available'
	String get noBikesAvailable => 'No bikes available';

	/// en: 'No packages available'
	String get noPackagesAvailable => 'No packages available';

	/// en: 'No promotions available'
	String get noPromotionsAvailable => 'No promotions available';

	/// en: 'Valid until'
	String get validUntil => 'Valid until';

	/// en: '← Back to Bikes'
	String get backToBikes => '← Back to Bikes';

	/// en: 'I'm Interested to Rent'
	String get interestedToRent => 'I\'m Interested to Rent';

	/// en: 'Top Speed'
	String get topSpeed => 'Top Speed';

	/// en: 'Charging Time'
	String get chargingTime => 'Charging Time';

	/// en: 'Weight'
	String get weight => 'Weight';

	/// en: 'Motor Power'
	String get motorPower => 'Motor Power';

	/// en: 'Rental Interest Form'
	String get rentalInterestForm => 'Rental Interest Form';

	/// en: 'Preferred Start Date'
	String get preferredStartDate => 'Preferred Start Date';

	/// en: 'dd/mm/yyyy'
	String get preferredStartDatePlaceholder => 'dd/mm/yyyy';

	/// en: 'Pickup Area'
	String get pickupArea => 'Pickup Area';

	/// en: 'Select pickup location'
	String get pickupAreaPlaceholder => 'Select pickup location';

	/// en: 'Contact (Email or Phone)'
	String get contact => 'Contact (Email or Phone)';

	/// en: 'Email@mail.com'
	String get contactPlaceholder => 'Email@mail.com';

	/// en: 'Additional Notes'
	String get additionalNotes => 'Additional Notes';

	/// en: 'Any specific requirements or questions...'
	String get additionalNotesPlaceholder => 'Any specific requirements or questions...';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Submit Request'
	String get submitRequest => 'Submit Request';

	/// en: 'Interest submitted successfully'
	String get interestSubmittedSuccessfully => 'Interest submitted successfully';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'welcomeBack' => 'Welcome Back',
			'signInToContinue' => 'Sign in to continue your journey',
			'emailAddress' => 'Email Address',
			'emailPlaceholder' => 'john@example.com',
			'password' => 'Password',
			'signIn' => 'Sign In',
			'dontHaveAccount' => 'Don\'t have an account?',
			'createAccount' => 'Create Account',
			'userNotFound' => 'User not found',
			'userAlreadyExists' => 'User already exists',
			'invalidCredentials' => 'Invalid credentials',
			'invalidEmail' => 'Invalid email',
			'invalidPassword' => 'Invalid password',
			'createYourAccount' => 'Create Your Account',
			'joinFDLAndStart' => 'Join FDL and start your e-bike journey',
			'fullName' => 'Full Name',
			'fullNamePlaceholder' => 'John Doe',
			'confirmPassword' => 'Confirm Password',
			'alreadyHaveAccount' => 'Already have an account?',
			'registerSuccess' => 'Account created successfully',
			'loginSuccess' => 'Login successful',
			'appTitle' => 'FDL Bikes',
			'appSubtitle' => 'Electric Mobility',
			'rentalPackages' => 'Rental Packages',
			'rentalPackagesDescription' => 'Choose the plan that fits your lifestyle.',
			'electrumBikes' => 'FDL Bikes',
			'electrumBikesDescription' => 'Discover our fleet of premium electric bikes.',
			'range' => 'Range',
			'viewDetails' => 'View Details',
			'available' => 'Available',
			'limited' => 'Limited',
			'unavailable' => 'Unavailable',
			'mostPopular' => 'Most Popular',
			'day' => 'Day',
			'week' => 'Week',
			'month' => 'Month',
			'retry' => 'Retry',
			'noBikesAvailable' => 'No bikes available',
			'noPackagesAvailable' => 'No packages available',
			'noPromotionsAvailable' => 'No promotions available',
			'validUntil' => 'Valid until',
			'backToBikes' => '← Back to Bikes',
			'interestedToRent' => 'I\'m Interested to Rent',
			'topSpeed' => 'Top Speed',
			'chargingTime' => 'Charging Time',
			'weight' => 'Weight',
			'motorPower' => 'Motor Power',
			'rentalInterestForm' => 'Rental Interest Form',
			'preferredStartDate' => 'Preferred Start Date',
			'preferredStartDatePlaceholder' => 'dd/mm/yyyy',
			'pickupArea' => 'Pickup Area',
			'pickupAreaPlaceholder' => 'Select pickup location',
			'contact' => 'Contact (Email or Phone)',
			'contactPlaceholder' => 'Email@mail.com',
			'additionalNotes' => 'Additional Notes',
			'additionalNotesPlaceholder' => 'Any specific requirements or questions...',
			'cancel' => 'Cancel',
			'submitRequest' => 'Submit Request',
			'interestSubmittedSuccessfully' => 'Interest submitted successfully',
			_ => null,
		};
	}
}
