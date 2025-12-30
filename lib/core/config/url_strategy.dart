import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Configures the URL strategy to remove the hash (#) from the URL.
/// Usage: Call `usePathUrlStrategy()` in `main.dart` before `runApp()`.
void configureUrlStrategy() {
  usePathUrlStrategy();
}
