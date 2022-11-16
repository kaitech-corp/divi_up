class MarketData {
  MarketData(this.iconUrl, this.name, this.price, this.symbol);

  MarketData.fromJSON(Map<String,dynamic> jsonMap) :
      iconUrl = jsonMap['iconUrl'] as String,
      name = jsonMap['name'] as String,
      price = jsonMap['price'] as String,
      symbol = jsonMap['symbol'] as String;


  final String? iconUrl;
  final String? name;
  final String? price;
  final String? symbol;
}
