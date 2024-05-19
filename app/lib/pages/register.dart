//import 'dart:html';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sample_app/pages/privacy_policy.dart';
import '../actions/useractions.dart';
import 'login.dart';

bool _passwordVisible = false;
class register_page extends StatefulWidget{
  const register_page({super.key});

  @override
  State<register_page> createState() => _registerpage();
}

@override
  void initState() {
    _passwordVisible = false;
}

class _registerpage extends State<register_page> { 
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  final TextStyle labelstyle = TextStyle(
    fontFamily: 'Lexend',
  );

  final firstDate = DateTime(DateTime.now().year - 120);
  final lastDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

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
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
                      backgroundColor: const Color.fromRGBO(79, 200, 127, 1),
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily:'Lexend',
                      )
                    ),
              onPressed: () => _selectDate(context),
              child: Text("Select Date"),
            ),
            /* InputDatePickerFormField(
              firstDate: firstDate,
              lastDate: lastDate,
              onDateSubmitted: (DateTime? date) {
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
            ), */
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
            Row(
              children: [
                Expanded(
                  child: Divider()
                  ),
                Text('or'),
                Expanded(
                  child: Divider()
                  ),
              ]
            ),            
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                backgroundColor: const Color.fromRGBO(79, 200, 127, 1),
                foregroundColor: Colors.black,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily:'Lexend',
                )
              ),
              onPressed: () {
                //logic here
              },
              icon: FaIcon(FontAwesomeIcons.google), 
              label: Text('Sign in with Google'
            )),
              Expanded(
                child: Text('')
              ),
              Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By continuing, I accept TradEase'\s ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily:'Lexend',
                        )
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(color:Color.fromRGBO(79, 200, 127, 1)),
                        recognizer: TapGestureRecognizer()..onTap = () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const privacy_policy()));
                        }
                      )
                    ]
                  )),
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
                        print('Date: $selectedDate');
                        _form.currentState?.validate();
                        try {
                          register(_password.text, _email.text, _fname.text, _lname.text, selectedDate, context);
                        } catch (err) {
                          throw Exception(err);
                        }
                      },
                      child: Text('Continue')
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