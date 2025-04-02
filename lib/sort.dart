import 'package:flutter/material.dart';

class Sort extends StatefulWidget {
  const Sort({super.key, required this.width});
  final double width;

  @override
  State<Sort> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Sort> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.width * 0.02),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(1, 1),
            ),
          ],
        ),
        height: 35,
        width: widget.width * 0.35,
        child: Row(
          children: [
            SizedBox(width: widget.width * 0.02),
            Icon(Icons.sort),
            SizedBox(width: widget.width * 0.05),
            Text(
              '近い順',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
