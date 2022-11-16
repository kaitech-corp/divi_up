import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/generics/generic_bloc.dart';
import '../../blocs/generics/generic_state.dart';
import '../../models/amount_model.dart';
import '../../repositories/amount_repository.dart';
import '../../services/constants/constants.dart';
import '../../services/navigation/route_names.dart';
import '../main_page/main_page.dart';
import '../menu_drawer.dart';

class ItemUserDetails extends StatefulWidget{
  const ItemUserDetails({super.key});

  @override
  State<ItemUserDetails> createState() => _ItemUserDetailsState();
}

class _ItemUserDetailsState extends State<ItemUserDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
          actions: <IconButton>[
            IconButton(onPressed: (){
              navigationService.pop();
            }, icon: const Icon(Icons.close))
          ],
        ),
        drawer: const MenuDrawer(),
        body: BlocBuilder<GenericBloc<AmountData,AmountRepository>, GenericState>(
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
              final List<AmountData> items = state.data as List<AmountData>;
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(items[index].displayName),
                        subtitle: Text(items[index].amount.toString()),
                        trailing: IconButton(onPressed: (){},icon: const Icon(Icons.edit),),
                      ),
                    ),
                  );
                },

              );
            }
            return const Text('Something went wrong!');
          }),
    );
  }
}