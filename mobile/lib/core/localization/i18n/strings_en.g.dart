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

	/// en: 'My Social'
	String get appTitle => 'My Social';
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
			'fullName' => 'Full Name',
			'fullNamePlaceholder' => 'John Doe',
			'confirmPassword' => 'Confirm Password',
			'alreadyHaveAccount' => 'Already have an account?',
			'registerSuccess' => 'Account created successfully',
			'loginSuccess' => 'Login successful',
			'appTitle' => 'My Social',
			_ => null,
		};
	}
}
