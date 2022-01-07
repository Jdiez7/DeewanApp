import 'package:flutter/material.dart';

class my_account extends StatelessWidget {
  const my_account({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('I have no idea yet what we put here'),
      ),
    );
  }
}
