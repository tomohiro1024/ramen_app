import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ramen_app/detail_page.dart';
import 'package:ramen_app/enum.dart';
import 'package:ramen_app/ramen_container.dart';
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
  SortState sortState = SortState.distance;
  String? sortText = "近い順";
  List<RamenData> ramenList = [];
  bool isTop = false;
  Uri? openGoogleMapUrl;
  String? message = '';
  bool isExist = false;
  String _version = '';

  @override
  void initState() {
    super.initState();
    searchPosition();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${packageInfo.version}';
      print('Version: $_version');
    });
  }

  Future searchPosition() async {
    Position currentPosition;

    try {
      currentPosition = await _determinePosition();
    } catch (e) {
      currentPosition = Position(
        latitude: 35.681236,
        longitude: 139.767125,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 1.0,
      );
    }

    // 現在地の取得
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

    final results = response?.results;

    setState(() {
      isExist = results?.isNotEmpty ?? false;
    });

    if (isExist == false) {
      return;
    }

    final maxUserRatingsTotal = results!
        .where((place) => place.userRatingsTotal != null)
        .map((place) => place.userRatingsTotal!)
        .fold<int>(0, (prev, curr) => curr > prev ? curr : prev);

    List<RamenData> fetchedRamenList = results.map((place) {
      final photoReference = place.photos?.first.photoReference;
      final goalLocation = place.geometry?.location;
      final goalLatitude = goalLocation?.lat;
      final goalLongitude = goalLocation?.lng;
      final isOpen = place.openingHours?.openNow;

      // GoogleMapアプリを開くURLを生成
      String rootUrl =
          'https://www.google.com/maps/dir/?api=1&origin=$currentLatitude,$currentLongitude&destination=$goalLatitude,$goalLongitude&travelmode=walking';

      openGoogleMapUrl = Uri.parse(rootUrl);

      if (maxUserRatingsTotal == place.userRatingsTotal) {
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
          place.userRatingsTotal, isTop, isOpen, openGoogleMapUrl);
    }).toList();

    setState(() {
      ramenList = fetchedRamenList;
    });
  }

  void toggleSort() {
    setState(() {
      sortState = switch (sortState) {
        SortState.distance => SortState.rating,
        SortState.rating => SortState.review,
        SortState.review => SortState.distance,
      };

      switch (sortState) {
        case SortState.rating:
          ramenList.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          sortText = "評価順";
        case SortState.distance:
          ramenList
              .sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
          sortText = "近い順";
        case SortState.review:
          ramenList.sort((a, b) =>
              (b.userRatingsTotal ?? 0).compareTo(a.userRatingsTotal ?? 0));
          sortText = "レビュー数順";
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ramen_dining,
              color: Colors.deepOrange,
            ),
            SizedBox(width: width * 0.02),
            Text(
              '近くのラーメン屋一覧',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
      body: isExist == true
          ? Container(
              color: Color(0xFFF5E1A4),
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Visibility(
                    visible: ramenList.isNotEmpty,
                    child: Row(
                      children: [
                        Sort(
                          width: width,
                          onTap: () => toggleSort(),
                          sortText: sortText!,
                        ),
                        Spacer(),
                        Text(
                          "バージョン: $_version",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: ramenList.isNotEmpty
                        ? ListView.builder(
                            itemCount: ramenList.length,
                            itemBuilder: (context, index) {
                              final ramen = ramenList[index];
                              return RamenContainer(width: width, ramen: ramen);
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SpinKitPouringHourGlass(
                                  color: Colors.deepOrange,
                                  size: 40,
                                ),
                                SizedBox(height: 20),
                                Text('検索中...'),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitPouringHourGlass(
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                  SizedBox(height: 20),
                  Text('検索中...'),
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
