import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:ramen_app/detail_page.dart';
import 'package:ramen_app/enum.dart';
import 'package:ramen_app/ramen_data.dart';
import 'package:ramen_app/secret.dart';
import 'package:ramen_app/sort.dart';

class RamenPage extends StatefulWidget {
  const RamenPage({super.key});

  @override
  State<RamenPage> createState() => _RamenPageState();
}

class _RamenPageState extends State<RamenPage> {
  late GooglePlace googlePlace;
  final apiKey = Secret.apiKey;
  String? photoUrl;
  double? doubleDistance;
  int? distance;
  SortState sortState = SortState.init;
  String? sortText = "近い順";
  List<RamenData> ramenList = [];
  bool isTop = false;

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

    for (var result in results!) {
      print("店名: ${result.name}");
      print("評価: ${result.rating}");
      print("レビュー数: ${result.userRatingsTotal}");
    }

    List<RamenData> fetchedRamenList = results.map((place) {
          final photoReference = place.photos?.first.photoReference;
          final goalLocation = place.geometry?.location;
          final goalLatitude = goalLocation?.lat;
          final goalLongitude = goalLocation?.lng;

          if (place.userRatingsTotal! > 900) {
            setState(() {
              isTop = true;
            });
          } else {
            setState(() {
              isTop = false;
            });
          }

          doubleDistance = Geolocator.distanceBetween(
            currentLatitude,
            currentLongitude,
            goalLatitude!,
            goalLongitude!,
          );

          distance = doubleDistance!.floor();

          if (photoReference != null) {
            photoUrl =
                "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$apiKey";
          }
          return RamenData(place.name, place.rating, photoUrl, distance,
              place.userRatingsTotal, isTop);
        }).toList();

    setState(() {
      ramenList = fetchedRamenList;
    });
  }

  void toggleSort() {
    setState(() {
      sortState = switch (sortState) {
        SortState.init => SortState.rating,
        SortState.rating => SortState.distance,
        SortState.distance => SortState.rating,
      };

      switch (sortState) {
        case SortState.rating:
          ramenList.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          sortText = "評価順";
        case SortState.distance:
          ramenList
              .sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
          sortText = "近い順";
        case SortState.init:
          break;
      }
    });
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
            Sort(
              width: width,
              onTap: () => toggleSort(),
              sortText: sortText!,
            ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    ramenName: ramen.name ?? '店名不明',
                                  ),
                                ),
                              );
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
                                  ramen.photoUrl != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.orange,
                                              width: 2.2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            child: Image.network(
                                              ramen.photoUrl!,
                                              width: width * 0.29,
                                              height: 110,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Image.asset(
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
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: width * 0.15,
                                              color: Colors.orange,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    ramen.distance != null
                                                        ? "${ramen.distance}m"
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            ),
                                            ramen.isTop == true
                                                ? Text("⭐️")
                                                : SizedBox(),
                                          ],
                                        ),
                                        SizedBox(height: 5),
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
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Transform.translate(
                                                offset: Offset(0, 10),
                                                child: Text("レビュー評価：")),
                                            Text(
                                              ramen.rating != null
                                                  ? ramen.rating!.toString()
                                                  : '',
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
                                    size: 45,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
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
