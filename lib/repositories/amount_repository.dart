import 'package:cloud_firestore/cloud_firestore.dart';
import '../blocs/generics/generic_bloc.dart';
import '../models/amount_model.dart';
import '../models/amount_model.dart';
import '../services/functions/cloud_functions.dart';


class AmountRepository extends GenericBlocRepository<AmountData> {
  AmountRepository({required this.docID});

  final String docID;

  @override
  Stream<List<AmountData>> data() {
    final CollectionReference<dynamic> amountCollection =
    FirebaseFirestore.instance.collection('amount').doc(docID).collection('amount');

    // Get all Activities
    List<AmountData> amountListFromSnapshot(QuerySnapshot<Object?> snapshot) {
      try {
        final List<AmountData> amountList =
        snapshot.docs.map((QueryDocumentSnapshot<Object?> doc) {
          return AmountData.fromDocument(doc);
        }).toList();
        return amountList;
      } catch (e) {
        CloudFunction()
            .logError('Error retrieving amount list:  ${e.toString()}');
        return <AmountData>[];
      }
    }

    return amountCollection
        .snapshots()
        .map(amountListFromSnapshot);
  }
}
