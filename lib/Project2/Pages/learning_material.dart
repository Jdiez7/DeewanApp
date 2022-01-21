import 'package:flutter/material.dart';

class learning_material extends StatelessWidget {
  const learning_material({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Material'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Here we want to add a link'),
      ),
    );
  }
}
