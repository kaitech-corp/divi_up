import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../../services/constants/constants.dart';
import '../../services/split_package/split_functions.dart';

class SplitPageForm extends StatefulWidget {
  const SplitPageForm({super.key});

  @override
  State<SplitPageForm> createState() => _SplitPageFormState();
}

class _SplitPageFormState extends State<SplitPageForm> {
  String dropdownValue = 'Food';
  final TextEditingController itemController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController customAmountController = TextEditingController();
  final ValueNotifier<List<double>> splitList = ValueNotifier<List<double>>(<double>[]);


  List<String> splitOption = <String>['Even Split','Custom'];
  String currentOption = 'Even Split';

  @override
  void initState() {
    super.initState();
    itemController.addListener(_onItemNameChange);
    totalController.addListener(_onItemTotalChange);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {}, child: const Text('Send')),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.wallet,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                  Column(
                    children: const <Widget>[
                      Text('Connect'),
                      Text('Wallet'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (dropdownValue == 'Item')
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimSearchBar(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  textController: itemController,
                  onSuffixTap: () {
                    setState(() {
                      itemController.clear();
                    });
                  }),
            ),
          ),
        Flexible(
            child: Center(
              child: SizedBox(
                width: 200,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  isExpanded: true,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue ?? '';
                    });
                  },
                  items:
                      splitType.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            )),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: totalController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            enableInteractiveSelection: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Total',
            ),
            validator: (String? value) {},
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
        Flexible( child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GroupButton<String>(buttons: splitOption,
            onSelected: (String type, int index, bool isSelected){
            setState(() {
              currentOption = type;
            });
              print('Type: $type, Index: $index, isSelected: $isSelected');
            },),
        )),
        Flexible(
            child: Column(
              children: <Widget>[
                ListTile(
                    title: const Text('Add People'),
                    trailing: IconButton(
                        onPressed: () {
                          if (totalController.text.isNotEmpty) {
                            setState(() {
                              splitList.value.add(0.0);
                              SplitFunctions().evenSplit(splitList, double.parse(totalController.text));
                            });
                          }
                        },
                        icon: const Icon(Icons.add))),
              ],
            )),
        if (splitList.value.isNotEmpty)
          Expanded(
            flex: 5,
              child: ListView.builder(
                itemCount: splitList.value.length,
                  itemBuilder: (BuildContext context, int index) {
                return userCard(index);
              })),

      ],
    );
  }

  Widget userCard(int index) {
    return GestureDetector(
      onTap: (){
        if(userCardButtonEnabled(currentOption)){
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            builder: (BuildContext context) => Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height*.3,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Custom amount: '),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*.2,
                        child: TextField(
                          controller: customAmountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),),
                      )
                    ],
                  ),
                  ElevatedButton(onPressed: (){

                  }, child: const Text('Save'))
                ],
              ),
            ),
          );
        }
      },
      child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueAccent
                  ),
                  child: ListTile(
                    title: Text('User $index'),
                    leading: const Icon(Icons.wallet),
                    trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            splitList.value.removeAt(index);
                            SplitFunctions().evenSplit(splitList, double.parse(totalController.text));
                          });
                        },
                        icon: const Icon(Icons.close)),
                    subtitle: SplitFunctions().formatTotal(splitList, index, currentOption),
                  ),
                ),
    );
  }

  bool userCardButtonEnabled(String type){
    if(type == splitOption[0]){
      return false;
    } else {
      return true;
    }
  }
  void _onItemNameChange() {}

  void _onItemTotalChange() {}
}
