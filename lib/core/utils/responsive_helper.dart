import 'package:flutter/material.dart';

/// Responsive helper for different screen sizes
class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Returns number of grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  /// Returns horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) return 20;
    if (isTablet(context)) return 40;
    return 80;
  }

  /// Returns section spacing based on screen size
  static double getSectionSpacing(BuildContext context) {
    if (isMobile(context)) return 60;
    if (isTablet(context)) return 80;
    return 100;
  }
}

/// Extension for easier responsive access
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  double get screenWidth => ResponsiveHelper.screenWidth(this);
  double get screenHeight => ResponsiveHelper.screenHeight(this);
  int get gridColumns => ResponsiveHelper.getGridColumns(this);
  double get horizontalPadding => ResponsiveHelper.getHorizontalPadding(this);
  double get sectionSpacing => ResponsiveHelper.getSectionSpacing(this);
}
