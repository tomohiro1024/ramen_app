import 'package:google_place/google_place.dart';

class RamenData {
  String? name;
  double? rating;
  String? photoUrl;
  int? distance;
  int? userRatingsTotal;
  bool? isTop;
  bool? isOpen;
  Uri? openGoogleMapUrl;
  List<String>? weekDayList;
  List<String>? photoUrls;
  RamenData(
    this.name,
    this.rating,
    this.photoUrl,
    this.distance,
    this.userRatingsTotal,
    this.isTop,
    this.isOpen,
    this.openGoogleMapUrl,
    this.weekDayList,
    this.photoUrls,
  );
}
