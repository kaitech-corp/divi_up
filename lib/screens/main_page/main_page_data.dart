import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../models/market_model.dart';
import '../../services/apis/api.dart';
import '../../services/constants/constants.dart';

class MainPageData extends StatefulWidget {
  const MainPageData({super.key});

  @override
  State<MainPageData> createState() => _MainPageDataState();
}

class _MainPageDataState extends State<MainPageData> {
  Map<String, String> dropdownValue = <String, String>{
    'Currency': 'USD',
    'ID': 'yhjMzLPhuIDl'
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Flexible(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 100,
            child: DropdownButton<Map>(
              value: referenceCurrency[0],
              isExpanded: true,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (Map? newValue) {
                setState(() {
                  dropdownValue = newValue! as Map<String, String>;
                });
                print(dropdownValue['ID']);
              },
              items: referenceCurrency.map((Map<String, String> map) {
                return DropdownMenuItem<Map>(
                  value: map,
                  child: Text(map['Currency']!),
                );
              }).toList(),
            ),
          ),
        )),
        Flexible(
            flex: 2,
            child: FutureBuilder<List<MarketData>>(
              future: ApiData().getMarketDataPy(dropdownValue['ID']!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MarketData>> response) {
                if (response.hasData) {
                  final List<MarketData> marketData = response.data!;
                  return ListView.builder(
                      itemCount: marketData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: SvgPicture.network(
                            marketData[index].iconUrl!,
                            height: 25,
                            width: 25,
                          ),
                          title: Text(marketData[index].symbol!),
                          trailing: Text(
                              '\$${double.parse(marketData[index].price!).toStringAsFixed(2)}'),
                        );
                      });
                } else {
                  return const SkeletonLoader(
                      baseColor: Colors.white70, items: 3, builder: ListTile());
                }
              },
            )),
      ],
    );
  }
}
