import 'package:my_social/core/localization/i18n/strings.g.dart';
import 'package:flutter/material.dart';

extension LocalExtension on BuildContext {
  Translations get translations => Translations.of(this);
  String localizeMessage(String key) {
    final translations = Translations.of(this);
    return translations[key] ?? key;
  }
}
