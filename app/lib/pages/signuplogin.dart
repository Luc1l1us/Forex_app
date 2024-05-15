import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/therapist_provider.dart';
import 'package:sample_app/pages/login.dart';
import 'package:sample_app/pages/register.dart';


// remove this after debugging
void main() async {
  runApp(ChangeNotifierProvider(create: (context) => TherepistProvider(),
    child: const MaterialApp(
      home: signuplogin(),
    ),
  ));
}

class signuplogin extends StatefulWidget {
  const signuplogin({super.key});

  @override
  State<signuplogin> createState() => _signuplogin();
}

class _signuplogin extends State<signuplogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Text('')
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Text('Investing Made Easier!', 
                  textScaler: TextScaler.linear(3),
                  style: TextStyle(fontFamily: 'Lexend'),
                  ),
                  SizedBox(height: 50),
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)));
                        }, 
                        child: Text('Log in', 
                        style: TextStyle(
                          fontFamily:'Lexend')
                          ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          backgroundColor: const Color.fromRGBO(79, 200, 127, 1),
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const register_page()));
                        }, 
                        child: Text('Register'),
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
                    ],
                  ),
                  SizedBox(height: 30),
                  Text('Reminder: When you invest, your capital is at risk'),
                  SizedBox(height: 30)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
