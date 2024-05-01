import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/useractions.dart';
import 'package:sample_app/actions/therapist_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyHome());
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _home(),
    );
  }
}

class _home extends StatefulWidget {
  const _home({super.key});
  @override
  State<_home> createState() => _homeState();
}

class _homeState extends State<_home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(100),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Employees/Therapist Employed'),
            SizedBox(height: 10),
            //FutureBuilder(future: Provider.of<TherapistProvider>(context, listen: false), builder: builder)
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                AlertDialog alertDialog = await addtherapist(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alertDialog;
                  });
              }, 
              icon: Icon(Icons.add), 
              label: Text('Add Employee/Therapist')
              ),
          ],
        ),
      ),
    )
    );
  }
}