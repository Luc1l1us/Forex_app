import 'package:flutter/material.dart';

class portfoliopage extends StatefulWidget {
  const portfoliopage({super.key});

  @override
  State<portfoliopage> createState() => _portfoliopage();
}

class _portfoliopage extends State<portfoliopage> {
  int _currentpageindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('PORTFOLIO PAGE IS WORKING MAH DOOD')
        ],
      ),
    );
  }
}