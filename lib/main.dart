import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/main_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>
          const MerchantCaravanApp(),
    ),
  );
}

class MerchantCaravanApp
    extends StatelessWidget {
  const MerchantCaravanApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(
        context,
      ),
      builder:
          DevicePreview.appBuilder,
      home: const MainMenuScreen(),
    );
  }
}