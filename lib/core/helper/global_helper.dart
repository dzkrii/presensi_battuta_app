import 'package:flutter/material.dart';

enum AppTextStyle {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  labelLarge,
  labelMedium,
  labelSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
}

class GlobalHelper {
  static TextStyle? getTextStyle(BuildContext context,
      {AppTextStyle appTextStyle = AppTextStyle.bodyMedium}) {
    final textTheme = Theme.of(context).textTheme;
    final appTextStyleMap = {
      AppTextStyle.displayLarge: textTheme.displayLarge,
      AppTextStyle.displayMedium: textTheme.displayMedium,
      AppTextStyle.displaySmall: textTheme.displaySmall,
      AppTextStyle.headlineLarge: textTheme.headlineLarge,
      AppTextStyle.headlineMedium: textTheme.headlineMedium,
      AppTextStyle.headlineSmall: textTheme.headlineSmall,
      AppTextStyle.titleLarge: textTheme.titleLarge,
      AppTextStyle.titleMedium: textTheme.titleMedium,
      AppTextStyle.titleSmall: textTheme.titleSmall,
      AppTextStyle.labelLarge: textTheme.labelLarge,
      AppTextStyle.labelMedium: textTheme.labelMedium,
      AppTextStyle.labelSmall: textTheme.labelSmall,
      AppTextStyle.bodyLarge: textTheme.bodyLarge,
      AppTextStyle.bodyMedium: textTheme.bodyMedium,
      AppTextStyle.bodySmall: textTheme.bodySmall,
    };
    return appTextStyleMap[appTextStyle];
  }

  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }
}
