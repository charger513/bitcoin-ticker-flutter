import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';
import 'coin_data.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  Map<String, String> exchanges = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getExchangeRate();
  }

  getExchangeRate() async {
      loading = true;
      try {
        var data = await CoinData().getExchangeRate(selectedCurrency);

        loading = false;

        setState(() {
          exchanges = data;
          print(exchanges); // {BTC: 6756.57, ETH: 142.49, LTC: 40.30}
        });
      } catch(e) {
        print(e);
      }
  }

  DropdownButton<String> androidDropdown() {
    final items = currenciesList.map((currency) {
      return DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
    }).toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getExchangeRate();
        });
      }
    );
  }

  CupertinoPicker iOSPicker() {
    final items = currenciesList.map((currency) {
      return Text(currency);
    }).toList();

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getExchangeRate();
        });
      },
      children: items,
    );
  }

  List<Widget> buildCards() {
    List<Widget> cryptoCards = [];

    for (var crypto in cryptoList) {

      final value = loading ? '?' : exchanges[crypto];

      final card = Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );

      cryptoCards.add(card);
    }

    return cryptoCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildCards()
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown()
          ),
        ],
      ),
    );
  }
}
