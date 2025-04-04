import 'package:flutter/material.dart';

class Sort extends StatefulWidget {
  const Sort({
    super.key,
    required this.width,
    required this.onTap,
    required this.sortText,
  });
  final double width;
  final VoidCallback onTap;
  final String sortText;

  @override
  State<Sort> createState() => _SortState();
}

class _SortState extends State<Sort> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        widget.onTap();
      },
      child: AnimatedScale(
        duration: Duration(milliseconds: 100),
        scale: _isPressed ? 0.95 : 1.0,
        child: Padding(
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
                  widget.sortText,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
