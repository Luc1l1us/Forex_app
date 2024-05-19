import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/user_provider.dart';
import 'package:sample_app/firebase_options.dart';
import 'package:sample_app/model/stockdatamodel.dart';
import 'package:sample_app/pages/login.dart';
import 'package:sample_app/pages/notifcationspage.dart';
import 'package:sample_app/pages/portfolio.dart';
import 'package:sample_app/pages/profilepage.dart';
import 'package:sample_app/pages/register.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sample_app/pages/searchpage.dart';
import 'package:sample_app/pages/stockpage.dart';
import 'package:sample_app/pages/tradepage.dart';


// remove this after debugging
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider(create: (context) => UserProvider(),
    child: const MaterialApp(
      home: home(),
    ),
  ));
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _home();
}

class _home extends State<home> {
  static TextStyle genText = TextStyle(fontFamily: 'Lexend');
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  int _currentpageindex = 0;
  final StockService _stockService = StockService();
  late Future<List<Stock>> _futureStocks;

  @override
  void initState() {
    super.initState();
    _futureStocks = _stockService.fetchStocks([]);
    //_futureStocks = _stockService.fetchStocks(['AMC', 'GME', 'TSLA', 'AMD']);
    //TODO: how tf do you even get the ID?
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserFromApi(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              children: [
                SizedBox(width: 50),
                RandomAvatar(
                  DateTime.now().toIso8601String(),
                  height: 75,
                  width: 75,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(right: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting(),
                          style: TextStyle(
                            fontFamily: 'Lexend',
                          ),
                        ),
                        FutureBuilder<void>(
                          future: Provider.of<UserProvider>(context, listen: false).fetchUserFromApi(), 
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error loading user data"),
                              );
                            } else {
                              final userProvider = Provider.of<UserProvider>(context, listen: false);
                              if (!userProvider.isUserLoaded) {
                                return Center(
                                  child: Text("No user data found"),
                                );
                              }
                              return Text(
                                  '${userProvider.user['First Name']} ${userProvider.user['Last Name']}',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                              );
                            }
                          })),
                    ],
                  )
                ),
              ),
                IconButton(
                  color: Color.fromRGBO(79, 200, 127, 1),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const notificationpage()));
                  }, 
                  icon: 
                  Badge(
                    backgroundColor: Color.fromRGBO(0, 148, 116, 1),
                    // TODO: change label color to green
                    label: Text('2'), //TODO: Make this actual notification numbers
                    child:(
                      Icon(
                        Icons.notification_add_outlined, 
                        size: 30,
                        )
                    ),
                  )
                ),
                SizedBox(width: 30),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(child: Text('')),
                    Text('Market Status Today', style: TextStyle(
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                    // TODO: change register here to actual update
                    SizedBox(width: 100),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const register_page()));
                      }, 
                      child: Text('See All'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        backgroundColor: const Color.fromRGBO(79, 200, 127, 1),
                        foregroundColor: Colors.black,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily:'Lexend',
                        )
                      ),
                    ),
                    Expanded(child: Text('')),
                  ]
                ),
              ]
            ),
            Row(
              textDirection: TextDirection.ltr,
              children: [
                SizedBox(width: 50),
                Text('Stocks', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily:'Lexend',
                  fontSize: 30,
                )),
              ]
            ),
            FutureBuilder<List<Stock>>(
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => StockDetailPage(stock: stock)));
                          },
                          leading: CircleAvatar(
                            backgroundColor: const Color.fromRGBO(79, 200, 127, 1),
                            foregroundColor: Colors.black,
                            child: Text(stock.symbol[0]),
                          ),
                          title: Text(stock.name, style: genText),
                          subtitle: Text(stock.symbol, style: genText),
                          trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text('\$${stock.price.toStringAsFixed(2)}', style: genText,),
                                Text(
                                  '${stock.changePercent.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: stock.change >= 0 ? Colors.green : Colors.red,
                                  )
                                )
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
        )
      ),
    );
  }
}
