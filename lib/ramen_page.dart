import 'package:flutter/material.dart';

class RamenPage extends StatefulWidget {
  const RamenPage({super.key});

  @override
  State<RamenPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RamenPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('近くのラーメン屋一覧'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: Color(0xFFF5E1A4),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: width * 0.02),
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
                  width: width * 0.35,
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.02),
                      Icon(Icons.sort),
                      SizedBox(width: width * 0.05),
                      Text(
                        '近い順',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 140,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(1, 0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.03),
                      Image.asset(
                        'assets/images/sample.png',
                        width: width * 0.29,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: width * 0.03),
                      SizedBox(
                        width: width * 0.47,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 25),
                            Text(
                              "埼玉ラーメン埼玉ラーメン埼玉ラーメン埼玉ラーメン",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Transform.translate(
                                    offset: Offset(0, 10),
                                    child: Text("レビュー評価：")),
                                Text(
                                  "4.0",
                                  style: TextStyle(
                                    fontSize: 45,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 50,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
