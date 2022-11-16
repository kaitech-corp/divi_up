import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/generics/generic_bloc.dart';
import '../../blocs/generics/generic_state.dart';
import '../../models/item_model.dart';
import '../../repositories/item_repository.dart';
import '../../services/navigation/route_names.dart';
import '../main_page/main_page.dart';

class ViewItems extends StatefulWidget{
  const ViewItems({super.key});

  @override
  State<ViewItems> createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericBloc<ItemData,ItemRepository>, GenericState>(
        builder: (BuildContext context, GenericState state){
          if(state is LoadingState){
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // color: Colors.white,
              child: const CupertinoActivityIndicator()
            );
          }
          if(state is HasDataState){
            final List<ItemData> items = state.data as List<ItemData>;
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: (){
                    navigationService.navigateTo(ItemUserDetailsRoute,arguments: items[index].docID);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(items[index].itemName),
                      subtitle: Text(items[index].total.toString()),
                      trailing: IconButton(onPressed: (){
                      navigationService.navigateTo(SplitEditFormPageRoute,arguments: items[index]);
                      },icon: const Icon(Icons.edit),),
                      // subtitle: Text(items[index].location),
                    ),
                  ),
                );
              },

                );
          }
          return const Text('Something went wrong!');
        });
  }
}