import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sample_app/model/stockdatamodel.dart'; 

class StockDetailPage extends StatelessWidget {
  final Stock stock;
  final apikey = dotenv.env['TWELVE_API'];
  StockDetailPage({required this.stock});
  DateTime? lastDisplayedMonth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(stock.name,
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            Text(stock.symbol,
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.normal,
                    fontSize: 15))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Balance',
              style: TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.normal,
                  fontSize: 15),
            ),
            Text(
              //TODO: fixed
              '\$420.73',
              style: TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<FlSpot>>(
                future: fetch7DayData(stock.symbol),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  List<FlSpot> spots = snapshot.data!;
                  print(spots);
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) {
                              DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                              
                              // Check if the month has changed since the last displayed month
                              if (lastDisplayedMonth == null || date.month != lastDisplayedMonth!.month) {
                                lastDisplayedMonth = date;
                                // Display the month label
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(DateFormat('MMM d, yyyy').format(date)),
                                );
                              } else {
                                // If the month hasn't changed, return an empty container
                                return Container();
                              }
                            },
                        ),
                      ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.black.withOpacity(0.3)),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 3,
                          color: Color.fromRGBO(79, 200, 127, 1),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.withOpacity(0.3),
                                Color.fromRGBO(79, 200, 127, 1).withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text(
                  '\$${stock.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Lexend',
                    ),
                ),
                Text(
                  '${stock.changePercent.toStringAsFixed(2)}% Today',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Lexend',
                    color: stock.change >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Future<List<FlSpot>> fetch7DayData(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://api.twelvedata.com/time_series?symbol=$symbol&interval=1day&outputsize=7&apikey=$apikey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['values'];
      if (data == null) {
        throw Exception('No data found');
      }
      return data.reversed
          .map<FlSpot>((point) => FlSpot(
                DateTime.parse(point['datetime']).millisecondsSinceEpoch.toDouble(),
                double.parse(point['close']),
              ))
          .toList();
    } else {
      throw Exception('Failed to load 7-day data');
    }
  }
}
