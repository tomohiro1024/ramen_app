import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.ramenName,
    required this.photoUrl,
    required this.width,
    required this.rating,
    required this.userRatingsTotal,
    required this.distance,
  });
  final String ramenName;
  final String photoUrl;
  final double width;
  final double rating;
  final int userRatingsTotal;
  final int distance;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ramenName,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange,
                    width: 2.2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    widget.photoUrl,
                    width: widget.width * 0.95,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Table(
                border: TableBorder.all(color: Colors.orange),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  buildTableRow('レビュー評価', widget.rating.toString()),
                  buildTableRow('レビュー数', widget.userRatingsTotal.toString()),
                  buildTableRow('ここからの距離', '${widget.distance}m'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TableRow buildTableRow(String label, String value) {
  return TableRow(
    children: [
      Container(
        color: Colors.orangeAccent.withValues(alpha: 0.5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          value,
          style: TextStyle(fontSize: 15),
        ),
      ),
    ],
  );
}
