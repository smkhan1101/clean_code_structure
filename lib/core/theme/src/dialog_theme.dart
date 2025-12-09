import 'package:startup_repo/imports.dart';

DialogThemeData get dialogThemeLight => DialogThemeData(
      shape: AppRadius.circular16Shape,
      backgroundColor: backgroundColorLight,
      insetPadding: AppPadding.padding32,
    );

DialogThemeData get dialogThemeDark => dialogThemeLight.copyWith(backgroundColor: backgroundColorDark);
