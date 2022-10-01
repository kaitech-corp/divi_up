import 'package:flutter/material.dart';



class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text('Divi',
                                style:
                                Theme.of(context).textTheme.headline5)),
                        const Align(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.deepOrange,
                          ),
                        )
                      ],
                    )
                       ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Find Friends',
                      ),
                  onTap: () {

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart,
                  ),
                  title:
                  const Text('Items', ),
                  onTap: () {

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Help & Feedback',),
                  onTap: () {
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings',),
                  onTap: () {
                  },
                ),
                // if (userService.currentUserID.contains('XCVzgl7xIG3'))
                //   ListTile(
                //     leading:
                //     const IconThemeWidget(icon: Icons.admin_panel_settings),
                //     title:
                //     Text('Admin', style: Theme.of(context).textTheme.subtitle1),
                //     onTap: () {
                //       if (userService.currentUserID.contains('XCVzgl7xIG3')) {
                //         navigationService.navigateTo(AdminPageRoute);
                //       }
                //     },
                //   ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title:
                  Text('Logout', style: Theme.of(context).textTheme.subtitle1),
                  onTap: () {
                  },
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('0.0.1'),
                )
              ],
            )),
      ),
    );
  }

}
