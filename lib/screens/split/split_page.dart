
import 'package:flutter/material.dart';

import '../main_page.dart';
import '../menu_drawer.dart';
import 'split_form.dart';

class SplitPage extends StatelessWidget{
  const SplitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split Item'),
        actions: [
          IconButton(onPressed:(){
            navigationService.pop();
          },
              icon: const Icon(Icons.close))
        ],
      ),
      drawer: const MenuDrawer(),
      body: SplitPageForm()
    );
  }

}
