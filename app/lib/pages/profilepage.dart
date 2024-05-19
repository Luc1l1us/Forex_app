//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${userProvider.user['email']}',
                                        style: TextStyle(
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                    ),
                                    Text(
                                      '${userProvider.user['First Name']} ${userProvider.user['Last Name']}',
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ]
                                );
                              }
                            }
                          )
                        ),
                        Text('Profile and Settings')
                      ],
                      )
                    ),
                    SizedBox(width: 30),
                  ],
                ),

                SizedBox(height: 30),
                Column(
                  children: [
                    SizedBox(
                      child: FutureBuilder<void>(
                        future: Provider.of<UserProvider>(context, listen: false).fetchUserFromApi(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error loading user data"));
                          } else {
                            final userProvider = Provider.of<UserProvider>(context, listen: false);
                            return 
                            Column(
                              children: [
                                SizedBox(
                                  height: 80,
                                  child: ElevatedButton.icon(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.remember_me_outlined, color: Color.fromRGBO(0, 148, 116, 1))
                                      ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showUpdateDialog(context, 'First Name', '${userProvider.user['First Name']}', (newValue) {
                                        Provider.of<UserProvider>(context, listen: false).updateFirstName(newValue);
                                      });
                                    },
                                    label: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          'First Name',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${userProvider.user['First Name']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ]
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 80,
                                  child: ElevatedButton.icon(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.remember_me_outlined, color: Color.fromRGBO(0, 148, 116, 1))
                                      ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showUpdateDialog(context, 'Last Name', '${userProvider.user['Last Name']}', (newValue) {
                                        Provider.of<UserProvider>(context, listen: false).updateLastName(newValue);
                                      });
                                    },
                                    label: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          'Last Name',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${userProvider.user['Last Name']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ]
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2),
                                SizedBox(
                                  height: 80,
                                  child: ElevatedButton.icon(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.person_outlined, color: Color.fromRGBO(0, 148, 116, 1))
                                      ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showUpdateDialog(context, 'Username', '${userProvider.user['Username']}', (newValue) {
                                        Provider.of<UserProvider>(context, listen: false).updateUsername(newValue);                                    
                                    });},
                                    label: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          'Username',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${userProvider.user['Username']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ]
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2),
                                SizedBox(
                                  height: 80,
                                  child: ElevatedButton.icon(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.email_outlined, color: Color.fromRGBO(0, 148, 116, 1))
                                      ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                        _showUpdateDialog(context, 'email', '${userProvider.user['email']}', (newValue) {
                                        Provider.of<UserProvider>(context, listen: false).updateUsername(newValue);                                    
                                    });},
                                    label: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          'Email',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${userProvider.user['email']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ]
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 80,
                                  child: ElevatedButton.icon(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.cake_outlined, color: Color.fromRGBO(0, 148, 116, 1))
                                      ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {},
                                    label: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          'Birthday',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${DateFormat('yyyy-MM-dd').format(DateTime.parse(userProvider.user['birthday']))}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ]
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
                            //TODO: update function here
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

void _showUpdateDialog(BuildContext context, String title, String currentValue, Function(String) onUpdate) {
  TextEditingController _controller = TextEditingController(text: currentValue);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update $title'),
        content: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'New $title',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onUpdate(_controller.text);
              Navigator.of(context).pop();
            },
            child: Text('Update'),
          ),
        ],
      );
    },
  );
}