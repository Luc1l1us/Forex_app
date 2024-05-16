import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/therapist_provider.dart';
import 'package:sample_app/pages/login.dart';
import 'package:sample_app/pages/notifcationspage.dart';
import 'package:sample_app/pages/register.dart';
import 'package:random_avatar/random_avatar.dart';


// remove this after debugging
void main() async {
  runApp(ChangeNotifierProvider(create: (context) => TherepistProvider(),
    child: const MaterialApp(
      home: landingpage(),
    ),
  ));
}

class landingpage extends StatefulWidget {
  const landingpage({super.key});

  @override
  State<landingpage> createState() => _landingpage();
}

class _landingpage extends State<landingpage> {
  static TextStyle genText = TextStyle(
    fontFamily: 'Lexend',
  );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container( 
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xffAEADB2),
              width: 0.3
            )
          )
        ),
        child: NavigationBar(
        backgroundColor: Color.fromRGBO(255, 251, 254, 1),
        surfaceTintColor: Color.fromRGBO(255, 251, 254, 1),
        onDestinationSelected: (int index) {
          setState(() {
            _currentpageindex = index;
          });
        },
        indicatorColor: Color.fromRGBO(79, 200, 127, 1),
        selectedIndex: _currentpageindex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search'
          ),
          NavigationDestination(
            icon: Icon(Icons.handshake),
            label: 'Trade'
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet),
            label: 'Portfolio'
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),
        ],
      ),
    ),
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
                        Text(
                          'Heinrich Imperial',
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.bold  
                          ),
                        ),
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
                    // TODO change label color to green
                    label: Text('2'), //TODO Make this actual notification numbers
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
                    Text('Market Status Today', style: genText),
                    // TODO change register here to actual update
                    SizedBox(width: 100),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const register_page()));
                      }, 
                      child: Text('Last Update'),
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
