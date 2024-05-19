import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class StockService {
  static const String baseUrl = 'http://127.0.0.1:5000/get_stocks';
  static const String searchURL = 'http://127.0.0.1:5000/searchforex';

  Future<List<Stock>> fetchStocks(List<String> symbols) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cacheKey = symbols.join(',');
    String? cachedData = prefs.getString(cacheKey);

    try {
        if (cachedData != null) {
          final data = json.decode(cachedData);
          return _parseStockData(data);
        } else {
          final response = await http.get(Uri.parse('$baseUrl?symbols=${symbols.join(',')}'));
          if (response.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(response.body);
            List<Stock> stocks = [];
            for (var symbol in symbols) {
              if (data.containsKey(symbol)) {
                stocks.add(Stock.fromJson(data[symbol]));
              }
            }
            return stocks;
          } else {
            throw Exception('Failed to load stock data!');
          }
        }
      
    } catch (err) {
      throw Exception("Error fetching stock data; $err");
    }
  }

  Future<List<SearchStock>> SearchStocks(List<String> symbols) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cacheKey = symbols.join(',');
    String? cachedData = prefs.getString(cacheKey);

    if (cachedData != null) {
      final data = json.decode(cachedData);
      return _parseSearchStockData(data);
    } else {
      final response = await http.get(Uri.parse('$searchURL?symbols=${symbols.join(',')}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> stocksData = responseData['data'];

        List<SearchStock> stocks = [];
        for (var item in stocksData) {
          stocks.add(SearchStock.fromJson(item));
        }

        return stocks;
      } else {
        throw Exception('Failed to load stock data!');
      }
    }
  }

  List<SearchStock> _parseSearchStockData(Map<String, dynamic> data) {
    List<SearchStock> stocks = [];
    for (var symbol in data.keys) {
      stocks.add(SearchStock.fromJson(data[symbol]));
    }
    return stocks;
  }
}


  List<Stock> _parseStockData(Map<String, dynamic> data) {
    List<Stock> stocks = [];
    for (var symbol in data.keys) {
      stocks.add(Stock.fromJson(data[symbol]));
    }
    return stocks;
  }

class SearchStock {
  final String symbol;
  final String instrument_name;
  final String currency;

  SearchStock({
    required this.symbol,
    required this.instrument_name,
    required this.currency,

  });

  factory SearchStock.fromJson(Map<String, dynamic> json) {
    return SearchStock(
      symbol: json['symbol'] ?? 'N/A',
      instrument_name: json['instrument_name'] ?? 'Unknown',
      currency: json['currency'] ?? 'Unknown');  
    }
}

class Stock {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;

  Stock({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? 'N/A',
      name: json['name'] ?? 'Unknown',
      price: json['close'] != null ? double.tryParse(json['close']) ?? 0.0 : 0.0,
      change: json['change'] != null ? double.tryParse(json['change']) ?? 0.0 : 0.0,
      changePercent: json['percent_change'] != null ? double.tryParse(json['percent_change']) ?? 0.0 : 0.0,    );
  }
}
