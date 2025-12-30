import 'package:fdl_ui/fdl_ui.dart';
import 'package:my_social/core/env/environment.dart';
import 'package:my_social/core/localization/i18n/strings.g.dart';
import 'package:my_social/core/router/router.dart';
import 'package:my_social/core/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

void main() {
  print(String.fromEnvironment('APP_ENV'));
  configureDependencies(
    String.fromEnvironment('APP_ENV', defaultValue: AppEnvironment.local),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          final t = context.t;
          return MaterialApp.router(
            title: t.appTitle,
            routerConfig: AppRouter.router,
            supportedLocales: AppLocaleUtils.supportedLocales,
            locale: TranslationProvider.of(context).flutterLocale,
            builder: (context, child) =>
                FDLStyleProvider(child: child ?? const SizedBox()),
          );
        },
      ),
    );
  }
}
