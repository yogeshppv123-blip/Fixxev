import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fixxev/core/router/app_router.dart';
import 'package:fixxev/core/theme/app_theme.dart';
import 'package:fixxev/core/config/url_strategy.dart'; // Import URL strategy
import 'package:provider/provider.dart';
import 'package:fixxev/core/providers/theme_provider.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const FixxevApp(),
    ),
  );
}

class FixxevApp extends StatelessWidget {
  const FixxevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'FIXXEV',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
