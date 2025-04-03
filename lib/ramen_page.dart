import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ramen_app/sort.dart';

class RamenPage extends StatefulWidget {
  const RamenPage({super.key});

  @override
  State<RamenPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RamenPage> {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    searchPosition();
  }

  Future searchPosition() async {
    // 現在地の取得
    final currentPosition = await _determinePosition();
    final currentLatitude = currentPosition.latitude;
    final currentLongitude = currentPosition.longitude;
    print('現在地の緯度: $currentLatitude, 経度: $currentLongitude');
  }

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
              Sort(width: width),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTapDown: (_) => setState(() => _isPressed = true),
                      onTapUp: (_) => setState(() => _isPressed = false),
                      onTapCancel: () => setState(() => _isPressed = false),
                      onTap: () {
                        // ここにタップ時の処理を追加
                      },
                      child: AnimatedScale(
                        duration: Duration(milliseconds: 100),
                        scale: _isPressed ? 0.95 : 1.0,
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
                      ),
                    )

                    // Positioned(
                    //   top: 0,
                    //   right: 10,
                    //   child: Icon(
                    //     Icons.star,
                    //     size: 30,
                    //     color: Colors.black,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('位置情報を許可してください！');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('位置情報を許可してください！');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('位置情報を許可してください！');
  }

  return await Geolocator.getCurrentPosition();
}
