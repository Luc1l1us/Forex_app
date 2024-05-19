import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/user_provider.dart';
import 'package:sample_app/model/currencyservice.dart';

void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MaterialApp(
      home: TradePage(),
    ),
  ));
}

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final CurrencyService _currencyService = CurrencyService();
  Map<String, String> _imageMap = {};
  final TextEditingController _from = TextEditingController();
  String firstcurrency = 'USD';
  String secondcurrency = 'EUR';
  final List<String> _currencies = [
    "USD", "EUR", "JPY", "CAD", "AUD", "CNY", "SGD",
    "BTC", "ETH", "BCH", "LTC"
  ];

  Future<void> _fetchCurrencyImages() async {
    try {
      final imageMap = await _currencyService.fetchCurrencyImages();
      setState(() {
        _imageMap = imageMap;
      });
    } catch (e) {
      print('Error fetching currency images: $e');
    }
  }
  late Future<List<CurrencyExchange>> _forex; 

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextStyle labelStyle = TextStyle(fontFamily: 'Lexend');
  static TextStyle genText = TextStyle(fontFamily: 'Lexend');

  @override
  void initState() {
    super.initState();
    _forex = _currencyService.currencyex(['USD/JPY'],1);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserFromApi();
    _fetchCurrencyImages();
  }

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
              Text(
                'Currency Converter',
                textScaleFactor: 3,
                style: TextStyle(fontFamily: 'Lexend'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'The Currency Converter page provides a simple and efficient way for users to convert between different currencies.',
            style: TextStyle(fontFamily: 'Lexend'),
          ),
          SizedBox(height: 30),
          Form(
            key: _form,
            child: Container(
              padding: EdgeInsets.all(100),
              child: Column(
                children: [
                  TextFormField(
                    controller: _from,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: labelStyle,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildDropdownMenu(_currencies, 'firstcurrency'),
                  SizedBox(height: 20),
                  _buildDropdownMenu(_currencies, 'secondcurrency'),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 200, vertical: 30),
                      backgroundColor: const Color.fromRGBO(79, 200, 127, 1),
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend',
                      ),
                    ),
                      onPressed: () {
                        if (_form.currentState?.validate() ?? false) {
                          int amount = int.parse(_from.text);
                          setState(() {
                            _forex = _currencyService.currencyex([firstcurrency, secondcurrency], amount);
                          });
                        }
                      },
                    child: Text('Calculate'),
                  ),
                FutureBuilder<List<CurrencyExchange>>(
                  future: _forex,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend',
                        fontSize: 20,
                      )));
                    }

                    final stocks = snapshot.data!;

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: stocks.length,
                        itemBuilder: (context, index) {
                          final stock = stocks[index];
                          return Card(
                            margin: EdgeInsets.only(left: 50, right: 50, bottom: 10, top: 30),
                            child: ListTile(
                              onTap: () {
                              },
                              title: Text(stock.symbol, style: genText),
                              subtitle: Text('Rate: ${stock.rate}', style: genText),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Total Amount: ${stock.amount}', style: genText),
                                  Text('${stock.timestamp}', style: genText),
                                ]
                              ),
                            )
                          );
                        },
                      ),
                    );
                  }
                )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownMenu(List<String> items, String currencyType) {
    return _imageMap.isEmpty
        ? CircularProgressIndicator()
        : DropdownButton<String>(
            value: currencyType == 'firstcurrency' ? firstcurrency : secondcurrency,
            style: genText,
            onChanged: (value) {
              setState(() {
                if (currencyType == 'firstcurrency') {
                  firstcurrency = value!;
                } else {
                  secondcurrency = value!;
                }
              });
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    _imageMap.containsKey(value)
                        ? Image.network(
                            _imageMap[value]!,
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          )
                        : Icon(Icons.error),
                    SizedBox(width: 10),
                    Text(value),
                  ],
                ),
              );
            }).toList(),
            isExpanded: true,
          );
  }
}
