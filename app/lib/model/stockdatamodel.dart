import 'package:http/http.dart' as http;
import 'dart:convert';

class StockService {
  static const String baseUrl = 'http://127.0.0.1:5000/get_stocks';

  Future<List<Stock>> fetchStocks(List<String> symbols) async {
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
