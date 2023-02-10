class User{

  int id;
  String userName;
  String email;
  String imageUrl;
  String password;

  User({this.id,this.userName,this.email,this.imageUrl,this.password});

  User.fromJson(Map<String,dynamic> json){
    id = int.parse(json['user_id']);
    userName = json['name'] as String;
    email = json['email'] as String;
    imageUrl = json['image_url'] as String;
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}