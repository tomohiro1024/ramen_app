import 'package:flutter/material.dart';

class RamenPage extends StatefulWidget {
  const RamenPage({super.key});

  @override
  State<RamenPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RamenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('近くのラーメン屋一覧'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
