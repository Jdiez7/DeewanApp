import 'package:flutter/material.dart';

class refer_to_a_friend extends StatelessWidget {
  const refer_to_a_friend({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer to a friend'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('You can refer this App by copying the following link:'),
      ),
    );
  }
}
