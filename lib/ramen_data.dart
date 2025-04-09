class RamenData {
  String? name;
  double? rating;
  String? photoUrl;
  int? distance;
  int? userRatingsTotal;
  bool? isTop;
  bool? isOpen;
  Uri? openGoogleMapUrl;
  RamenData(
    this.name,
    this.rating,
    this.photoUrl,
    this.distance,
    this.userRatingsTotal,
    this.isTop,
    this.isOpen,
    this.openGoogleMapUrl,
  );
}
