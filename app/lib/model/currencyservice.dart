import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService {
  static const List<String> list = <String>[
    "USD", "EUR", "JPY", "CAD", "AUD", "CNY", "SGD",
    "BTC", "ETH", "BCH", "LTC",
  ];

  static const String searchURL = 'http://127.0.0.1:5000/exchangecurrency';

  Future<Map<String, String>> fetchCurrencyImages() async {
    final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      Map<String, String> imageMap = {};

      for (var item in data) {
        String symbol = item['symbol'].toString().toUpperCase();
        if (list.contains(symbol)) {
          imageMap[symbol] = item['image'];
        }
      }

      imageMap['USD'] = ''; 
      imageMap['EUR'] = 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Euro_symbol_black.svg';
      imageMap['JPY'] = ''; 
      imageMap['CAD'] = ''; 
      imageMap['AUD'] = ''; 
      imageMap['CNY'] = ''; 
      imageMap['SGD'] = ''; 

      return imageMap;
    } else {
      throw Exception('Failed to load currency data!');
    }
  }

Future<List<CurrencyExchange>> currencyex(List<String> symbols, int amount) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cacheKey = symbols.join(',');
  String? cachedData = prefs.getString(cacheKey);

  if (cachedData != null) {
    final data = json.decode(cachedData);
    return _parseCurrencyExchange(data);
  } else {
    final response = await http.get(Uri.parse('$searchURL?symbol=${symbols.join('/')}&amount=$amount'));
    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      CurrencyExchange exchange = CurrencyExchange.fromJson(responseData);
      return [exchange];
    } else {
      throw Exception('Failed to load currency data!');
    }
  }
}



  List<CurrencyExchange> _parseCurrencyExchange(Map<String, dynamic> data) {
    List<CurrencyExchange> stocks = [];
    for (var symbol in data.keys) {
      stocks.add(CurrencyExchange.fromJson(data[symbol]));
    }
    return stocks;
  }
}

class CurrencyExchange {
  final double amount;
  final double rate;
  final String symbol;
  final DateTime timestamp;

  CurrencyExchange({
    required this.amount,
    required this.rate,
    required this.symbol,
    required this.timestamp,

  });

  factory CurrencyExchange.fromJson(Map<String, dynamic> json) {
    return CurrencyExchange(
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) ?? 0.0 : 0.0,    
      rate: json['rate'] != null ? double.tryParse(json['rate'].toString()) ?? 0.0 : 0.0,
      symbol: json['symbol'] ?? 'N/A',
      timestamp: json['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000) : DateTime.now(),    );
  }
}
