import 'package:my_social/core/localization/i18n/strings.g.dart';
import 'package:flutter/material.dart';

extension LocalExtension on BuildContext {
  Translations get translations => Translations.of(this);
  String localizeMessage(String key) {
    final translations = Translations.of(this);
    return translations[key] ?? key;
  }
}

extension LocalizeMessageExtension on String {
  String? mayLocalizeMessage(BuildContext context) {
    final translations = Translations.of(context);
    final translated = translations[this];
    return translated;
  }

  String localizeMessage(BuildContext context) {
    final translations = Translations.of(context);
    return translations[this] ?? this;
  }

  String localizedFormError(BuildContext context) {
    return "apiError.formError.$this".mayLocalizeMessage(context) ?? this;
  }
}
