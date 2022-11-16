import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/item_model.dart';
import '../../services/database.dart';
import 'create_item_event.dart';
import 'create_item_state.dart';

class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  CreateItemBloc() :super(CreateItemState.initial()) {
    final ItemData itemData = defaultItemData;
    on<ItemTotalChanged>(
            (ItemTotalChanged event, Emitter<CreateItemState> emit) async
            {
              emit(state.update(hasTotal: event.total! > 0));
              itemData.update(total: event.total);
            }
              );
    on<ItemTypeChange>((ItemTypeChange event, Emitter<CreateItemState> emit) async{
      itemData.update(type: event.type);
      if(event.type == 'Restaurant'){
        emit(CreateItemState.restaurant());
      } else {
        emit(CreateItemState.notRestaurant());
      }
    });
    on<ItemNameChanged>((ItemNameChanged event, Emitter<CreateItemState> emit) async{
      itemData.update(itemName: event.name);
    });
    on<ItemLocationChanged>((ItemLocationChanged event, Emitter<CreateItemState> emit) async{
      itemData.update(location: event.location);
    });
    on<ItemAccessUsersChanged>((ItemAccessUsersChanged event, Emitter<CreateItemState> emit) async{
      itemData.update(accessUsers: event.accessUsers);
    });
    on<ItemGeoPointChanged>((ItemGeoPointChanged event, Emitter<CreateItemState> emit) async{
      itemData.update(geoPoint: event.geoPoint);
    });
    on<ItemEvenSplitChanged>((ItemEvenSplitChanged event, Emitter<CreateItemState> emit) async{
      itemData.update(evenSplit: event.evenSplit);
    });
    on<CreateItemButtonPressed>(
            (CreateItemButtonPressed event,
            Emitter<CreateItemState> emit) async {
          emit(CreateItemState.loading());
          try {
            DatabaseService().saveItem(itemData);
          } catch (_) {
            emit(CreateItemState.failure());
          }
        });
  }
}
