import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/therapist_provider.dart';
import 'package:sample_app/pages/login.dart';
import 'package:sample_app/pages/register.dart';

class cookies extends StatefulWidget {
  const cookies({super.key});

  @override
  State<cookies> createState() => _cookies();
}

class _cookies extends State<cookies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset('assets/images/cookies.png'),
              ]
            ),
            Text('How we handle cookies', 
                textScaler: TextScaler.linear(3),
                style: TextStyle(fontFamily: 'Lexend'),
            ),
            Center(
              child: 
              Container(
                padding: EdgeInsets.all(50),
                child: Column(children: [
                  Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: TextStyle(fontFamily: 'Lexend')),
                  SizedBox(height: 30),
                  Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: TextStyle(fontFamily: 'Lexend')),
                ]
              ),
            )),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 200, vertical: 30),
                  backgroundColor: const Color.fromRGBO(79, 200, 127, 1),
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily:'Lexend',
                  )
                ),
                  onPressed: () {
                    try {
                      Navigator.pop(context);
                    } catch (err) {
                      throw Exception(err);
                    }
                  },
                  child: Text('Apply All')
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 200, vertical: 30),
                  backgroundColor: const Color.fromRGBO(79, 200, 127, 1),
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily:'Lexend',
                  )
                ),
                  onPressed: () {
                    try {
                      Navigator.pop(context);
                    } catch (err) {
                      throw Exception(err);
                    }
                  },
                  child: Text('Reject All')
                ),
              ],
            ),
          SizedBox(height: 30),
          Text('Privacy Notice', 
            style: TextStyle(
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold),
            ),
          ],
        )
      );
    }
}
