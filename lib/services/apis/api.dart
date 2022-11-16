
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/market_model.dart';
import '../../models/product_model.dart';


class ApiData {

  Future<List<MarketData>> getMarketDataPy(String id) async {
    final http.Response response = await http.get(Uri.parse('https://us-central1-divi-364219.cloudfunctions.net/market_data_py?id=$id'));
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
    var res = jsonDecode(response.body);
    final Iterable<dynamic> list = res['data']['coins'] as Iterable<dynamic>;
    return list.map((dynamic coin) => MarketData.fromJSON(coin as Map<String, dynamic>)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data: ${response.statusCode}');
    }
  }

  Future<List<WalmartProducts>> productSearch(String product) async {
    final http.Response response = await http.get(Uri.parse('https://product-search-6wqtljnvra-uc.a.run.app?product=$product'));
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      final dynamic result = json.decode(response.body);
      print(result);
      final Iterable<dynamic> list = result['queries'] as Iterable<dynamic>;
      return list.map((dynamic stat) => WalmartProducts.fromJSON(stat as Map<String, dynamic>)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data: ${response.statusCode}');
    }
  }
}
