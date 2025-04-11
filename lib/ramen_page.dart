import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
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
  SortState sortState = SortState.init;
  String? sortText = "近い順";
  List<RamenData> ramenList = [];
  bool isTop = false;
  Uri? openGoogleMapUrl;

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

    // for (var result in results!) {
    //   print("店名: ${result.name}");
    //   print("評価: ${result.rating}");
    //   print("レビュー数: ${result.userRatingsTotal}");
    //   print("営業: ${result.openingHours?.openNow ?? false}");
    // }

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
        title: Text(
          '近くのラーメン屋一覧',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                        return RamenContainer(width: width, ramen: ramen);
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
