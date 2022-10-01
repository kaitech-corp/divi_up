import 'package:flutter/material.dart';

import 'screens/main_page.dart';
import 'services/initializer.dart';
import 'services/locator.dart';
import 'services/navigation/navigation_service.dart';
import 'services/navigation/router.dart';
import 'widgets/responsive_wrapper.dart';

void main() async{
  await projectInitializer();
  runApp(const DiviApp());
}

class DiviApp extends StatelessWidget {
  const DiviApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? widget){
        return responsiveWrapperBuilder(context, widget!);
      },
      title: 'Divi',
      theme: ThemeData.dark(

        // primarySwatch: Colors.deepOrange,
      ),
      home: const MainPage(title: 'Divi'),
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigationKey,
      onGenerateRoute: generateRoute,
    );
  }
}
