import 'package:flutter/material.dart';

import '../services/constants/constants.dart';
import '../services/locator.dart';
import '../services/navigation/navigation_service.dart';
import '../services/navigation/route_names.dart';
import 'menu_drawer.dart';

NavigationService navigationService = locator<NavigationService>();

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: <Widget>[
          const Text('Currency Rates',),
          Flexible(
            flex: 3,
            child: Column(
              children: List<Widget>.generate(
                6,
                (int index) => ListTile(
                  leading: Text(index.toString()),
                  title: Text(pairs[index]),
                ),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            ),
          ),
          const Flexible(
            child: Text('Split an Item.'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         navigationService.navigateTo(SplitPageRoute);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
