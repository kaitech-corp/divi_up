import 'package:cloud_firestore/cloud_firestore.dart';
import '../blocs/generics/generic_bloc.dart';
import '../models/history_model.dart';
import '../services/functions/cloud_functions.dart';



class HistoryRepository extends GenericBlocRepository<HistoryData> {
  HistoryRepository({required this.uid});

  final String uid;

  @override
  Stream<List<HistoryData>> data() {
    final CollectionReference<dynamic> historyCollection =
    FirebaseFirestore.instance.collection('history');

    // Get all History
    List<HistoryData> _itemListFromSnapshot(QuerySnapshot<Object> snapshot) {
      try {
        final List<HistoryData> itemList =
        snapshot.docs.map((QueryDocumentSnapshot<Object> doc) {
          return HistoryData.fromDocument(doc);
        }).toList();
        return itemList;
      } catch (e) {
        CloudFunction()
            .logError('Error retrieving history list:  ${e.toString()}');
        return <HistoryData>[];
      }
    }

    return historyCollection
        .doc(uid)
        .collection('history')
        .snapshots()
        .map(_itemListFromSnapshot);
  }
}
