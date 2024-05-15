//import 'dart:js';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/useractions.dart';
import '../actions/therapist_provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(create: (context) => TherepistProvider(),
    child: const MaterialApp(
      home: MyHome(),
    ),
    )
  );
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(79, 200, 127, 1)),
        fontFamily: 'Lexend',
        useMaterial3: true,
      ),
      home: _home(),
    );
  }
}

class _home extends StatefulWidget {
  const _home({Key? key}) : super(key: key);
  
  @override
  State<_home> createState() => _homeState();
}

class _homeState extends State<_home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text('Hotel Management System'),
        leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        actions: <Widget>[
          IconButton(
            onPressed: () {}, 
            icon: FaIcon(FontAwesomeIcons.bell))
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Employees/Therapist Employed'),
            SizedBox(height: 10),
            FutureBuilder(future: Provider.of<TherepistProvider>(context, listen: false).getTherapists,
            builder: ((context, snapshot) => 
              snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator())
              :
            Consumer<TherepistProvider>(
              child: Center(
                heightFactor: MediaQuery.of(context).size.height * 0.03,
                child: const Text('You have no employees.', style: TextStyle(fontSize: 18),),
              ),
              builder: ((context, TherepistProvider, child) => TherepistProvider.items.isEmpty
              ? child as Widget
              : Padding(
                padding: const EdgeInsets.only(top:20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: TherepistProvider.items.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: ListTile(
                          tileColor: Colors.black12,
                          title: Text(TherepistProvider.items[index]['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(TherepistProvider.items[index]['occupation']),
                              Text(TherepistProvider.items[index]['contact']),
                              Text(TherepistProvider.items[index]['department']),
                              ]),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min, 
                            children: [
                              IconButton(
                              icon: Icon(Icons.delete, color: const Color.fromARGB(255, 77, 77, 77)),
                              onPressed: ()  {
                                deleteTherapist(TherepistProvider.items[index]['id'], context);
                              }
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: const Color.fromARGB(255, 77, 77, 77)),
                              onPressed: ()  {
                                showDialog(context: context, 
                                builder: (BuildContext context) {
                                  return updateTherapist(context, TherepistProvider.items[index]['id']);
                                });
                              }
                            ),
                          ]
                          ) ,
                          onTap: () {},
                        ),
                      ),
                  )
                ),
                )))
            )),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Builder(
                      builder: (context) {
                        return addtherapist(context);
                      },
                    );
                  },
                );
                Provider.of<TherepistProvider>(context, listen: false).getTherapists;
              },
              icon: Icon(Icons.add),
              label: Text('Add Employee/Therapist'),
            ),
          ],
        ),
      ),
    )
    );
  }
}