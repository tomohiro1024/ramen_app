import 'package:flutter/material.dart';

class BadgeContainer extends StatefulWidget {
  const BadgeContainer({
    super.key,
    required this.isOpen,
    required this.width,
  });
  final bool isOpen;
  final double width;

  @override
  State<BadgeContainer> createState() => _BadgeState();
}

class _BadgeState extends State<BadgeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: widget.isOpen == true ? widget.width * 0.15 : widget.width * 0.21,
      color: widget.isOpen == true ? Colors.orange : Colors.grey,
      child: Align(
        alignment: Alignment.center,
        child: Text(widget.isOpen == true ? "営業中" : '営業時間外',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
