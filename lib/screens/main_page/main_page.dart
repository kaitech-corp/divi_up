import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../services/locator.dart';
import '../../services/navigation/navigation_service.dart';
import '../../services/navigation/route_names.dart';
import '../menu_drawer.dart';
import '../view_items/view_items.dart';
import 'main_page_data.dart';

NavigationService navigationService = locator<NavigationService>();

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

int _selectedIndex = 0;
  final List<Widget> _widgetOptions = const <Widget>[
    MainPageData(),
    ViewItems(),

    ];

void _onItemTapped(int index) {
  // FirebaseCrashlytics.instance.crash();
  setState(() {
    _selectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const MenuDrawer(),
      body:_widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigationService.navigateTo(SplitFormPageRoute);
        },
        tooltip: 'Split',
        child: const Icon(Icons.add,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.black,
        items: const <Widget>[
          Icon(Icons.home),
          Icon(Icons.monetization_on),
        ],
        onTap: _onItemTapped,
        index: _selectedIndex,
      ),
    );
  }
}
