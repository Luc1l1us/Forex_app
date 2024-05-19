import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/user_provider.dart';
import 'package:sample_app/model/stockdatamodel.dart';

// remove this after debugging
void main() async {
  runApp(ChangeNotifierProvider(create: (context) => UserProvider(),
    child: const MaterialApp(
      home: searchpage(),
    ),
  ));
}

class searchpage extends StatefulWidget {
  const searchpage({super.key});

  @override
  State<searchpage> createState() => _searchpage();
}

class _searchpage extends State<searchpage> {
  final StockService _stockService = StockService();
  late Future<List<SearchStock>> _futureStocks;

  @override
  void initState() {
    super.initState();
    _futureStocks = _stockService.SearchStocks(['AA', 'BB']);
    //TODO: how tf do you even get the ID?
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserFromApi(); 
  }

  static TextStyle genText = TextStyle(
    fontFamily: 'Lexend',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 30),
              Text('Search', 
                  textScaler: TextScaler.linear(3),
                  style: TextStyle(fontFamily: 'Lexend'),
              ),
            ]
          ),
          SizedBox(height: 20),
          Text('By entering keywords into the search bar, you can browse through a list of relevant results.', 
              style: TextStyle(fontFamily: 'Lexend'),
          ),
          SizedBox(height: 30),
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                onTap: () {
                },
                onChanged: (_) { 
                  _futureStocks = _stockService.SearchStocks([_]);
                  setState(() {
                    
                  });
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(
                title: Text(item),
                onTap: () {
                  _futureStocks = _stockService.SearchStocks([item]);
                  setState(() {}); 
              });
            }
          );
          }
        ),
          FutureBuilder<List<SearchStock>>(
            future: _futureStocks, 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily:'Lexend',
                fontSize: 20,
              )));
              }

              final stocks = snapshot.data!;

              return Expanded(
                child: ListView.builder(
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return Card(
                    margin: EdgeInsets.only(left: 50, right: 50, bottom: 10, top: 30),
                      child: ListTile(
                        onTap: () {
                          //TODO: Bring functionality here?
                        },
                        title: Text(stock.instrument_name, style: genText),
                        subtitle: Text(stock.symbol, style: genText),
                        trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Text(stock.currency, style: genText,),
                            ]
                          ),
                      )
                    );
                  },
                )
              );
            }
          )
      ],
      ),
    );
  }
}