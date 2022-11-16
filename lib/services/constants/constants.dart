List<String> pairs = <String>['XRP', 'ADA', 'BTC', 'USD', 'JPY', 'EUR'];
const List<String> splitType = <String>['Restaurant', 'Event', 'Item', 'Custom'];
final List<String> splitOption = <String>['Even Split','Custom'];

const Map<String, String> coinIDAndIcon = <String, String>{
  'Qwsogvtv82FCd': 'https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg',
  'razxDUgYGNAdQ': 'https://cdn.coinranking.com/rk4RKHOuW/eth.svg',
  '-l8Mn2pVlRs-p': 'https://cdn.coinranking.com/B1oPuTyfX/xrp.svg',
  'qzawljRxB5bYu': 'https://cdn.coinranking.com/ryY28nXhW/ada.svg'
};

Map<String, String> refCurrency = <String, String>{
  'USD': 'yhjMzLPhuIDl',
  'EURO': '5k-_VTxqtCEI',
  'GBP': 'Hokyui45Z38f',
  'CAD': '_4s0A3Uuu5ML',
  'BRL': 'n5fpnvMGNsOS'
};

List<Map<String, String>> referenceCurrency = <Map<String, String>>[
  <String, String>{'Currency': 'USD', 'ID': 'yhjMzLPhuIDl'},
  <String, String>{'Currency': 'EURO', 'ID': '5k-_VTxqtCEI'},
  <String, String>{'Currency': 'GBP', 'ID': 'Hokyui45Z38f'},
  <String, String>{'Currency': 'CAD', 'ID': '_4s0A3Uuu5ML'},
  <String, String>{'Currency': 'BRL', 'ID': 'n5fpnvMGNsOS'}
];

Future<List<String>> pairsFuture(String x) async {
  return <String>['XRP', 'ADA', 'BTC', 'USD', 'JPY', 'EUR'];
}

const String title = 'Divi';
const String typeResponse = 'What would you like to split?';
