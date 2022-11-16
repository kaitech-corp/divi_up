///Model Walmart API
class WalmartProducts {
  WalmartProducts({this.query, this.type});

  WalmartProducts.fromJSON(Map<String, dynamic> jsonMap)
      : query = jsonMap['displayName'] as String,
        type = jsonMap['type'] as String;
  String? query;
  String? type;
}