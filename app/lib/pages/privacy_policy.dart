import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/actions/therapist_provider.dart';
import 'package:sample_app/pages/login.dart';
import 'package:sample_app/pages/register.dart';


// remove this after debugging
void main() async {
  runApp(ChangeNotifierProvider(create: (context) => TherepistProvider(),
    child: const MaterialApp(
      home: privacy_policy(),
    ),
  ));
}

class privacy_policy extends StatefulWidget {
  const signuplogin({super.key});

  @override
  State<privacy_policy> createState() => _privacypolicy();
}

class _privacypolicy extends State<privacy_policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        
      )
    );
  }
}
