part of 'style.dart';

abstract class AppTextStyles {
  static AppTextStyles get defaultTextStyle => DefaultTextStyle();

  // Heading styles
  TextStyle get h1;
  TextStyle get h2;
  TextStyle get h3;
  TextStyle get h4;

  // Body text styles
  TextStyle get p;
  TextStyle get label;
  TextStyle get button;
  TextStyle get input;
}

class DefaultTextStyle implements AppTextStyles {
  @override
  TextStyle get h1 => const TextStyle(
    fontSize: 24, // text-2xl
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get h2 => const TextStyle(
    fontSize: 20, // text-xl
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get h3 => const TextStyle(
    fontSize: 18, // text-lg
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get h4 => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get p => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w400, // font-weight-normal
    height: 1.5,
  );

  @override
  TextStyle get label => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get button => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get input => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w400, // font-weight-normal
    height: 1.5,
  );
}

class DarkTextStyles implements AppTextStyles {
  @override
  TextStyle get h1 => const TextStyle(
    fontSize: 24, // text-2xl
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get h2 => const TextStyle(
    fontSize: 20, // text-xl
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get h3 => const TextStyle(
    fontSize: 18, // text-lg
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get h4 => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get p => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w400, // font-weight-normal
    height: 1.5,
  );

  @override
  TextStyle get label => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get button => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w500, // font-weight-medium
    height: 1.5,
  );

  @override
  TextStyle get input => const TextStyle(
    fontSize: 16, // text-base
    fontWeight: FontWeight.w400, // font-weight-normal
    height: 1.5,
  );
}

extension TextExtenstion on Text {
  Text h1(BuildContext context) => Text(data!, style: context.textStyles.h1);
  Text h2(BuildContext context) => Text(data!, style: context.textStyles.h2);
  Text h3(BuildContext context) => Text(data!, style: context.textStyles.h3);
  Text h4(BuildContext context) => Text(data!, style: context.textStyles.h4);
  Text p(BuildContext context) => Text(data!, style: context.textStyles.p);
  Text label(BuildContext context) =>
      Text(data!, style: context.textStyles.label);
  Text button(BuildContext context) =>
      Text(data!, style: context.textStyles.button);
  Text input(BuildContext context) =>
      Text(data!, style: context.textStyles.input);
}

extension AppTextStylesExtension on TextStyle {
  TextStyle applyColor(Color color) => copyWith(color: color);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w600, height: 1.5);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold, height: 1.5);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
}
