import 'package:cloud_firestore/cloud_firestore.dart';
import '../blocs/generics/generic_bloc.dart';
import '../models/item_model.dart';
import '../services/functions/cloud_functions.dart';


class ItemRepository extends GenericBlocRepository<ItemData> {
  ItemRepository();

  // final String docID;

  @override
  Stream<List<ItemData>> data() {
    final CollectionReference<dynamic> itemsCollection =
        FirebaseFirestore.instance.collection('items');

    // Get all Activities
    List<ItemData> itemListFromSnapshot(QuerySnapshot<Object?> snapshot) {
      try {
        final List<ItemData> itemList =
            snapshot.docs.map((QueryDocumentSnapshot<Object?> doc) {
          return ItemData.fromDocument(doc);
        }).toList();
        return itemList;
      } catch (e) {
        CloudFunction()
            .logError('Error retrieving items list:  ${e.toString()}');
        return <ItemData>[];
      }
    }

    return itemsCollection
        .snapshots()
        .map(itemListFromSnapshot);
  }
}
