//import 'dart:html';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sample_app/actions/user_provider.dart';
import 'package:sample_app/pages/privacy_policy.dart';
import '../actions/useractions.dart';

void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MaterialApp(
      home: profilepage(),
    ),
  ));
}

bool _passwordVisible = false;
class profilepage extends StatefulWidget{
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepage();
}

@override
  void initState() {
    _passwordVisible = false;
}

class _profilepage extends State<profilepage> { 
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextStyle labelstyle = TextStyle(
    fontFamily: 'Lexend',
  );

  final firstDate = DateTime(DateTime.now().year - 120);
  final lastDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              icon: Icon(Icons.arrow_back)
            ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(right: 100, left: 100, bottom: 15),
          child: Form(
            key: _form, 
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                SizedBox(width: 50),
                RandomAvatar(
                  DateTime.now().toIso8601String(),
                  height: 75,
                  width: 75,
                ),
                SizedBox(width: 20),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(right: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          }
                        )
                      ),
                    ],
                    )
                  ),
                SizedBox(width: 30),
              ],
            ),
            Text('Let\'s get you in!', 
            textScaler: TextScaler.linear(3),
            style: TextStyle(fontFamily: 'Lexend'),
            textAlign: TextAlign.justify,
            ), 
            SizedBox(height: 30),
            TextFormField(
              controller: _fname,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'First Name',
                labelStyle: labelstyle,
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Empty';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _lname,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Last Name',
                labelStyle: labelstyle,
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Empty';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'E-mail Address',
                labelStyle: labelstyle,
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Empty';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Text(
                  'Date of Birth',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                  ),
                ),
              ]
            ),
            InputDatePickerFormField(
              firstDate: firstDate,
              lastDate: lastDate,
              
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _password,
              obscureText: !_passwordVisible,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Empty';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                )
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _confirmpassword,
              obscureText: !_passwordVisible,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Empty';
                }
                if (val != _password.text) {
                  return 'Passwords do not match!';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                )
              ),
            ),
            SizedBox(height: 30),         
            SizedBox(height: 20),
              Expanded(
                child: Text('')
              ),
              Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  SizedBox(height: 20),
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
                        _form.currentState?.validate();
                        try {
                          register(_password.text, _email.text, _fname.text, _lname.text, context);
                        } catch (err) {
                          throw Exception(err);
                        }
                      },
                      child: Text('Update Profile')
                    )
                ],
              )
            )
          ],
        ),
      ),
    )
    ));
  }
}