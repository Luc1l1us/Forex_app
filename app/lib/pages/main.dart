import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../actions/useractions.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _username,
              decoration: InputDecoration(
                labelText: 'Enter your username',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter your email',
              ),
              controller: _email,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter your password',
              ),
              controller: _password,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  try {
                    register(_username.text, _email.text, _password.text);
                  } catch (err) {
                    throw Exception(err);
                  }
                },
                child: Text('Register'))
          ],
        ),
      ),
    );
  }
}
