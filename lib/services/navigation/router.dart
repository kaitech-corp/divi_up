import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/generics/generic_bloc.dart';
import '../../blocs/generics/generics_event.dart';
import '../../gen/assets.gen.dart';
import '../../models/amount_model.dart';
import '../../models/item_model.dart';
import '../../repositories/amount_repository.dart';
import '../../screens/main_page/main_page.dart';
import '../../screens/split/split_form/split_edit_form.dart';
import '../../screens/split/split_form/split_form.dart';
import '../../screens/view_item_details/item_details.dart';
import '../constants/constants.dart';
import 'route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final Object? args = settings.arguments;
  switch (settings.name!) {
    case HomeRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const MainPage(title: title),
      );
    case SplitFormPageRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const SplitFormPage(),
      );
    case SplitEditFormPageRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: SplitEditFormPage(itemData: args as ItemData,),
      );
    case ItemUserDetailsRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BlocProvider<GenericBloc<AmountData, AmountRepository>>(
            create: (BuildContext context)  =>
            GenericBloc<AmountData, AmountRepository>(
                repository: AmountRepository(docID: args.toString()))..add(LoadingGenericData()),
            child: const ItemUserDetails()),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      Assets.images.error.path,
                      fit: BoxFit.cover,
                      width: 300,
                      height: 300,
                    ),
                    const Text(
                      'Something went wrong. Sorry about that.',
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Be sure to check your network connection just in case.',
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
              ));
  }
}

MaterialPageRoute<Object> _getPageRoute(
    {required String routeName, required Widget viewToShow}) {
  return MaterialPageRoute<Object>(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (BuildContext context) => viewToShow);
}

// class SplitEditArguments{
//
//   SplitEditArguments(this.itemData,);
//   final ItemData itemData;
// }