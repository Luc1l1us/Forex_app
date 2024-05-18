import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/therapist_provider.dart';
import 'package:sample_app/pages/cookies.dart';
import 'package:sample_app/pages/privacy_policy.dart';
import '../actions/useractions.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'register.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider(create: (context) => TherepistProvider(),
    child: const MaterialApp(
      home: MyApp(),
    ),
  ));
}

bool _passwordVisible = false;

@override
  void initState() {
    _passwordVisible = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
          padding: EdgeInsets.all(100),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Ready to Trade?', 
            textScaler: TextScaler.linear(5),
            style: TextStyle(fontFamily: 'Lexend'),
            textAlign: TextAlign.justify,
            ),            
            SizedBox(height: 30),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Email',
                prefixIcon: Icon(Icons.email)
              ),
              controller: _email,
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
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Color.fromRGBO(79, 200, 127, 1),
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
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Forgot Password?",
                    style: 
                      TextStyle(
                        color:Color.fromRGBO(79, 200, 127, 1),
                        fontFamily: 'Lexend'
                      ),
                    recognizer: TapGestureRecognizer()..onTap = () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const register_page()));
                    }
                  )
                ]
            )),
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
                // TODO: Get SHA1 footprint to use this
                //logic here
              },
              icon: FaIcon(FontAwesomeIcons.google), 
              label: Text('Sign in with Google'
            )),
            SizedBox(height: 30),
            /*RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: "Not yet Registered?  "
                ),
                TextSpan(
                  text: "Register",
                  style: TextStyle(color:Color.fromRGBO(79, 200, 127, 1)),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const register_page()));
                  }
                )
              ]
            )),*/
            SizedBox(height: 50),
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
                        try {
                          login(_password.text, _email.text, context);
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
    );
  }
}