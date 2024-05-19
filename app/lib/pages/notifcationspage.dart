import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/user_provider.dart';

// remove this after debugging
void main() async {
  runApp(ChangeNotifierProvider(create: (context) => UserProvider(),
    child: const MaterialApp(
      home: notificationpage(),
    ),
  ));
}

class notificationpage extends StatefulWidget {
  const notificationpage({super.key});

  @override
  State<notificationpage> createState() => _notificationpage();
}

class _notificationpage extends State<notificationpage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static TextStyle genText = TextStyle(
    fontFamily: 'Lexend',
  );
  int _currentpageindex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        actions: <Widget>[
            IconButton(
              onPressed: () {
                // TODO make a settings options here?
                Navigator.pop(context);
              }, 
              icon: Icon(Icons.more_horiz_outlined)
            ),
        ],
      ),
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
      body: Column(
        children: [
          Container(
            color: Colors.white, 
            child: TabBar(
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 5.0, 
                  color: Color.fromRGBO(79, 200, 127, 1), 
                ),
                insets: EdgeInsets.symmetric(horizontal: 255), 
              ),
              indicatorColor: Color.fromRGBO(79, 200, 127, 1), 
              indicatorWeight: 4.0, 
              labelColor: Color.fromRGBO(79, 200, 127, 1), 
              unselectedLabelColor: Colors.grey, 
              labelStyle: genText,
              tabs: [
                Tab(text: 'General'),
                Tab(text: 'Applications'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  color: Colors.white, 
                  child: 
                  Center( // Add condition like if content is 0 then display a text file png
                    child: Text('General Content')
                    ),
                ),
                Container(
                  color: Colors.white, 
                  child: Center(
                    child: Text('Applications Content')
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
