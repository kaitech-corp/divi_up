

import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../screens/split/split_page.dart';
import 'route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final Object? args = settings.arguments;
  switch (settings.name!) {
    case SplitPageRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const SplitPage(),
      );
    default:
      return MaterialPageRoute<Widget>(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Oops!'),
            ),
            body: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10,),
                    Image.asset(Assets.images.error.path,fit: BoxFit.cover,width: 300,height: 300,),
                    const Text('Something went wrong. Sorry about that.',textScaleFactor: 1.5,textAlign: TextAlign.center,style: TextStyle(color: Colors.redAccent),),
                    const SizedBox(height: 10,),
                    const Text('Be sure to check your network connection just in case.',textScaleFactor: 1.5,textAlign: TextAlign.center,),
                  ],
                )),
          ));
  }
}


MaterialPageRoute _getPageRoute({required String routeName, required Widget viewToShow }) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (BuildContext context) => viewToShow);
}