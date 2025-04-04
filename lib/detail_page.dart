import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.ramenName});
  final String ramenName;

  @override
  State<DetailPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ramenName),
      ),
    );
  }
}
