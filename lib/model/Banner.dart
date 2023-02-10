class Banners {
  int bannerId;
  String imageUrl;

  Banners(this.bannerId, this.imageUrl);

  Banners.fromJson(Map<String,dynamic> json){
    bannerId = int.parse(json["banner_id"]);
    imageUrl = json["image_url"].toString();
  }
}