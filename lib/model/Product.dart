class Product{
  int productId;
  String name;
  double price;
  int quantity;
  String imageUrl;
  int providerId;

  Product({this.productId, this.name, this.price, this.quantity, this.imageUrl,this.providerId});

  Product.fromJsonUser(Map<String,dynamic> json){
    productId = int.parse(json["product_id"]);
    name = json["name"].toString();
    price = double.parse(json["price"]);
    quantity = int.parse(json["quantity"]);
    imageUrl = json["image_url"].toString();
    providerId = int.parse(json["provider_id"]);
  }

  Product.fromJsonProvider(Map<String,dynamic> json){
    productId = int.parse(json["product_id"]);
    quantity = int.parse(json["quantity"]);
    name = json["name"].toString();
    imageUrl = json["image_url"].toString();
  }
}