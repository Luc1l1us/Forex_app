import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/user_provider.dart';
import 'package:sample_app/firebase_options.dart';
import 'package:sample_app/model/stockdatamodel.dart';
import 'package:sample_app/pages/home.dart';
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
  await Firebase.initializeApp(); 
  runApp(ChangeNotifierProvider(create: (context) => UserProvider(),
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
  int _currentpageindex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      home(),
      searchpage(),
      TradePage(),
      //portfoliopage(),
      profilepage(),
    ];
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
            label: 'Rate Exchange'
          ),
          /* NavigationDestination(
            icon: Icon(Icons.wallet),
            label: 'Portfolio'
          ), */
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),
        ],
      ),
    ),
      body: _pages[_currentpageindex]
    );
  }
}
