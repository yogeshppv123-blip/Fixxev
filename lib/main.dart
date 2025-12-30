import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fixxev/core/router/app_router.dart';
import 'package:fixxev/core/theme/app_theme.dart';
import 'package:fixxev/core/config/url_strategy.dart'; // Import URL strategy

void main() {
  // Configure URL strategy to verify removal of hash (#)
  configureUrlStrategy();
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const FixxevApp());
}

class FixxevApp extends StatelessWidget {
  const FixxevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FIXXEV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
