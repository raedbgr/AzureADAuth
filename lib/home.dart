import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  late final String name;
  late final String email;

  Home({
   required this.name,
   required this.email
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(name),
            Text(email),
          ],
        ),
      ),
    );
  }
}