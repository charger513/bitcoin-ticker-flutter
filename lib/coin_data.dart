import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
  'XRP'
];

const APIKEY = '85353893-48C4-4C0E-B96E-87367DC8B506';

class CoinData {

  Future<Map<String, String>> getExchangeRate(String currency) async {

    Map<String, String> cryptoPrices = {};

    for(String crypto in cryptoList) {
      String url = 'https://rest.coinapi.io/v1/exchangerate/$crypto/$currency?apikey=$APIKEY';

      final response = await http.get(url);
      if(response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        double rate = decodedData['rate'];

        cryptoPrices[crypto] = rate.toStringAsFixed(2);

      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }

    return cryptoPrices;
  }

}
