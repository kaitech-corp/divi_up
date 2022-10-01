import 'package:flutter/cupertino.dart';

class SplitFunctions {
  void evenSplit(ValueNotifier<List<double>> splitList, double total){
    final double totalPP = total/splitList.value.length;
    if(splitList.value.isNotEmpty){
      splitList.value = List<double>.generate(splitList.value.length, (int index) => totalPP);
    } else {
      splitList.value = <double>[total];
    }

  }

  void customAmount(ValueNotifier<List<double>> splitList, double total, double amount, int index){
    final double totalPP = (total-amount)/splitList.value.length;
    splitList.value = List<double>.generate(splitList.value.length, (int index) => totalPP);
    splitList.value[index] = amount;
  }

  Widget formatTotal (ValueNotifier<List<double>> splitList, int index, String type){
    switch (type){
      case 'Even Split':
        return Text('\$${splitList.value[index].toStringAsFixed(2)}');
      default:
        return const Text('0.0');
    }
  }
}