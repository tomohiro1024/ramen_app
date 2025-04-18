import 'package:flutter/material.dart';
import 'package:ramen_app/badgeContainer.dart';
import 'package:ramen_app/ramen_data.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.ramen,
    required this.width,
  });

  final double width;
  final RamenData ramen;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ramen.name!,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(color: Colors.cyan),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF5E1A4),
          height: height,
          width: widget.width,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: widget.width * 0.03),
                  child: BadgeContainer(
                    isOpen: widget.ramen.isOpen!,
                    width: widget.width,
                  ),
                ),
              ),
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
                      widget.ramen.photoUrl!,
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
                    buildTableRow('レビュー評価', widget.ramen.rating.toString()),
                    buildTableRow('レビュー数', widget.ramen.userRatingsTotal.toString()),
                    buildTableRow('ここからの距離', '${widget.ramen.distance}m'),
                  ],
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  launchUrl(widget.ramen.openGoogleMapUrl!,
                      mode: LaunchMode.externalApplication);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 14, horizontal: widget.width * 0.15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    "Google Mapアプリで確認",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            value,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    ],
  );
}
