
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../../models/amount_model.dart';
import '../../../models/item_model.dart';
import '../../../services/database.dart';
import '../../../services/functions/functions.dart';
import '../../main_page/google_autocomplete.dart';
import '../../main_page/main_page.dart';


class SplitEditFormPageBloc extends FormBloc<String, String> {

  SplitEditFormPageBloc(this.itemData) : super(autoValidate: true) {
    addFieldBlocs(fieldBlocs: <FieldBloc>[
      itemName,
      itemTotal,
      evenSplit,
      itemType,
      itemLocation,
      dateCreated,
      // members,
    ]);
  }

  final ItemData itemData;

  TextEditingController controller = TextEditingController();

  List<String> accessUsers= <String>[];

  final TextFieldBloc<String> itemName = TextFieldBloc<String>();

  final TextFieldBloc<String> itemLocation = TextFieldBloc<String>();

  final TextFieldBloc<double> itemTotal = TextFieldBloc<double>();

  final BooleanFieldBloc<bool> evenSplit = BooleanFieldBloc<bool>(initialValue: false);

  final SelectFieldBloc<String, dynamic> itemType = SelectFieldBloc<String, List<String>>(
    items: <String>['Item', 'Event', 'Restaurant'],
    validators: [FieldBlocValidators.required],
  );


  final InputFieldBloc<DateTime?, Object> dateCreated = InputFieldBloc<DateTime?, Object>(initialValue: null);

  final ListFieldBloc<AmountDataBloc, dynamic> members = ListFieldBloc<AmountDataBloc, dynamic>(name: 'members');

  void addMember() {
    if(itemTotal.value.isNotEmpty){
      if(accessUsers.isEmpty){
        final AmountDataBloc member = AmountDataBloc(
          displayName: TextFieldBloc<String>(name: 'Name'),
          walletAddress: TextFieldBloc<String>(name: 'Public Address'),
          amount: TextFieldBloc<double>(name: 'Amount'),
          uid: 'myUID',
        );
        member.displayName.updateValue('Me');
        members.addFieldBloc(member);
        accessUsers.add(member.uid);
      } else {
        final AmountDataBloc member = AmountDataBloc(
          displayName: TextFieldBloc<String>(name: 'Name'),
          walletAddress: TextFieldBloc<String>(name: 'Public Address'),
          amount: TextFieldBloc<double>(name: 'Amount'),
          uid: DatabaseService().getFirestoreKey(),
        );
        members.addFieldBloc(member);
        accessUsers.add(member.uid);
      }
    } else {
      addErrors();
    }
  }

  void removeMember(int index) {
    members.removeFieldBlocAt(index);
    try {
      accessUsers.removeAt(index);
    } catch (e) {
      accessUsers.clear();
      for (final AmountDataBloc member in members.value){
        accessUsers.add(member.uid);
      }
    }
  }

  void addErrors() {
    itemName.addFieldError('Missing name!');
    itemTotal.addFieldError('Missing total!');
    itemType.addFieldError('Please select one!');
  }
  void updateInitialValues(){
    itemName.updateValue(itemData.itemName);
    itemTotal.updateValue(itemData.total.toString());
    itemType.updateValue(itemData.type);
    itemLocation.updateValue(itemData.location);
    controller.text = itemData.location;
    dateCreated.updateValue(itemData.dateCreated.toDate());
    evenSplit.updateValue(itemData.evenSplit);
  }

  @override
  Future<void> onSubmitting() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      DatabaseService().saveItem(defaultItemData.update(accessUsers:accessUsers, itemName: itemName.value, type: itemType.value,total: itemTotal.valueToDouble,location: controller.text,dateCreated: getTimestamp(dateCreated.value),evenSplit: evenSplit.value));
      DatabaseService(itemDocID: itemData.docID).deleteItem();
      emitSuccess(canSubmitAgain: true);
    } catch (e) {
      emitFailure();
    }
  }
}


class SplitEditFormPage extends StatelessWidget {
  const SplitEditFormPage({super.key, required this.itemData});

  final ItemData itemData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplitEditFormPageBloc>(
      create: (BuildContext context) => SplitEditFormPageBloc(itemData),
      child: Builder(
        builder: (BuildContext context) {
          final SplitEditFormPageBloc formBloc = BlocProvider.of<SplitEditFormPageBloc>(context);
          formBloc.updateInitialValues();
          return Scaffold(
            appBar: AppBar(title: const Text('Divi')),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: formBloc.submit,
                  icon: const Icon(Icons.send),
                  label: const Text('SUBMIT'),
                ),
              ],
            ),
            body: FormBlocListener<SplitEditFormPageBloc, String, String>(
              onSubmitting: (BuildContext context, FormBlocSubmitting<String, String> state) async {
                LoadingDialog.show(context);
              },
              onSuccess: (BuildContext context, FormBlocSuccess<String, String> state) {
                LoadingDialog.hide(context);
                navigationService.pop();
              },
              onFailure: (BuildContext context, FormBlocFailure<String, String> state) {
                LoadingDialog.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse!)));
              },
              child: ScrollableFormBlocManager(
                formBloc: formBloc,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.itemName,
                        // suffixButton: SuffixButton.obscureText,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                      ChoiceChipFieldBlocBuilder<String>(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceEvenly,
                        selectFieldBloc: formBloc.itemType,
                        selectedColor: Colors.blue,
                        itemBuilder: (BuildContext context, String value) => ChipFieldItem(
                          label: Text(value),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.itemTotal,
                        // suffixButton: SuffixButton.obscureText,
                        decoration: const InputDecoration(
                          labelText: 'Total',
                          hintText: 'USD',
                          prefixIcon: Icon(Icons.monetization_on),
                        ),
                      ),
                      TextFormField(
                        controller: formBloc.controller,
                        // suffixButton: SuffixButton.obscureText,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          prefixIcon: Icon(Icons.text_fields),
                          helperText: 'Optional',
                        ),
                      ),
                      GooglePlaces(controller: formBloc.controller, child: const Icon(Icons.map)),
                      DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: formBloc.dateCreated,
                        format: DateFormat('dd-MM-yyyy'),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Icon(Icons.calendar_today),
                          helperText: 'Optional',
                        ),
                      ),
                      SwitchFieldBlocBuilder(
                        booleanFieldBloc: formBloc.evenSplit,
                        body: const Text('Split Evenly'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: (){},
                            child: const Text('SEARCH USER'),
                          ),
                          ElevatedButton(
                            onPressed: formBloc.addMember,
                            child: const Text('ADD NEW USER'),
                          ),
                        ],
                      ),
                      BlocBuilder<ListFieldBloc<AmountDataBloc, dynamic>,
                          ListFieldBlocState<AmountDataBloc, dynamic>>(
                        bloc: formBloc.members,
                        builder: (BuildContext context, ListFieldBlocState<AmountDataBloc, dynamic> state) {
                          if (state.fieldBlocs.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.fieldBlocs.length,
                              itemBuilder: (BuildContext context, int i) {
                                return MemberCard(
                                  memberIndex: i,
                                  memberField: state.fieldBlocs[i],
                                  onRemoveMember: () =>
                                      formBloc.removeMember(i),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {

  const LoadingDialog({super.key});
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    builder: (_) => LoadingDialog(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}


class MemberCard extends StatelessWidget {

  const MemberCard({
    super.key,
    required this.memberIndex,
    required this.memberField,
    required this.onRemoveMember,
  });
  final int memberIndex;
  final AmountDataBloc memberField;

  final VoidCallback onRemoveMember;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black38,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Member #${memberIndex + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.displayName,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.amount,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.walletAddress,
              decoration:  InputDecoration(
                labelText: 'Public Wallet Address',
                icon: IconButton(onPressed: (){
                  getWalletAddress();
                }, icon: const Icon(Icons.qr_code_2_sharp)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> getWalletAddress() async {
    String address = await FlutterBarcodeScanner.scanBarcode(
        'green',
        'Cancel',
        true,
        ScanMode.QR);

    memberField.walletAddress.updateValue(address);
  }

}
