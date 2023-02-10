class Providers {
  int providerId;
  String name;
  String email;
  int category;
  String rate;
  String location;
  String address;
  String imageUrl;
  int state;
  String password;

  Providers({this.providerId, this.name, this.email, this.category, this.rate, this.location, this.address, this.imageUrl, this.state, this.password});

  Providers.fromJson(Map<String,dynamic> json){
    providerId = int.parse(json['provider_id']);
    name = json['name'].toString();
    email = json['email'].toString();
    category = int.parse(json['category']);
    rate = json['rate'].toString();
    location = json['location'].toString();
    address = json['address'].toString();
    imageUrl = json['image_url'].toString();
    state = int.parse(json['state']);
    password = json['password'].toString();
  }

  Providers.fromJsonProfile(Map<String,dynamic> json){
    providerId = int.parse(json['provider_id']);
    name = json['name'].toString();
    email = json['email'].toString();
    address = json['address'].toString();
    imageUrl = json['image_url'].toString();
  }
}