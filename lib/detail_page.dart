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
  String displayText = '';
  @override
  void initState() {
    super.initState();
    final String joinedText = widget.ramen.weekDayList!.join(', ');
    displayText = joinedText.replaceAll(', ', ',\n');
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: Colors.cyan,
                  ),
                  Container(
                    height: 250,
                    width: widget.width * 0.85,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                        width: 2.2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: widget.ramen.photoUrls!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: PageView.builder(
                              itemCount: widget.ramen.photoUrls!.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  widget.ramen.photoUrls![index],
                                  width: widget.width * 0.95,
                                  height: 250,
                                  fit: BoxFit.cover,
                                );
                              }),
                        )
                        : Text('画像がありません'),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.cyan,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    buildInfoRow('レビュー評価', widget.ramen.rating.toString()),
                    Divider(
                      color: Colors.orange,
                      thickness: 1,
                      height: 1,
                    ),
                    buildInfoRow(
                        'レビュー数', widget.ramen.userRatingsTotal.toString()),
                    Divider(
                      color: Colors.orange,
                      thickness: 1,
                      height: 1,
                    ),
                    buildInfoRow('ここからの距離', '${widget.ramen.distance}m'),
                    Divider(
                      color: Colors.orange,
                      thickness: 1,
                      height: 1,
                    ),
                    buildInfoRow('営業時間', displayText),
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

Widget buildInfoRow(String label, String value) {
  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ラベル側
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.orangeAccent.withOpacity(0.5),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // 値側
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
        Divider(color: Colors.orange, thickness: 1),
      ],
    ),
  );
}
