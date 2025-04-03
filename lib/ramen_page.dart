import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:ramen_app/ramen_data.dart';
import 'package:ramen_app/secret.dart';
import 'package:ramen_app/sort.dart';

class RamenPage extends StatefulWidget {
  const RamenPage({super.key});

  @override
  State<RamenPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RamenPage> {
  late GooglePlace googlePlace;
  final apiKey = Secret.apiKey;
  List<RamenData> ramenList = [];
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

    googlePlace = GooglePlace(apiKey);

    var response = await googlePlace.search.getNearBySearch(
      Location(lat: currentLatitude, lng: currentLongitude),
      1500,
      language: 'ja',
      type: "restaurant",
      keyword: "ラーメン",
      rankby: RankBy.Distance,
    );

    if (response == null) {
      print("Error: getNearBySearchに失敗しました");
      return;
    }

    final results = response.results;

    List<RamenData> fetchedRamenList = results?.map((place) {
          return RamenData(place.name);
        }).toList() ??
        [];

    setState(() {
      ramenList = fetchedRamenList;
    });

    // for (var place in results!) {
    //   print("店名: ${place.name}, 住所: ${place.geometry?.location?.lat}");
    // }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Sort(width: width),
            SizedBox(height: 15),
            Expanded(
              child: ramenList.isNotEmpty
                  ? ListView.builder(
                      itemCount: ramenList.length,
                      itemBuilder: (context, index) {
                        final ramen = ramenList[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: width * 0.02),
                          child: GestureDetector(
                            onTap: () {
                              // ここにタップ時の処理を追加
                            },
                            child: Container(
                              height: 140,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 25),
                                        Text(
                                          ramen.name ?? '店名不明',
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
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator()), // データがない場合
            ),
          ],
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
