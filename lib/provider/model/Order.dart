class Orders {
  int orderId;
  String orderDate;
  String orderTime;
  double orderFullAmount;
  String userLocation;

  Orders({this.orderId, this.orderDate, this.orderTime, this.orderFullAmount, this.userLocation});

  Orders.fromJson(Map<String,dynamic> json){
    orderId = int.parse(json["order_id"]);
    orderDate = json["order_date"].toString();
    orderTime = json["order_time"].toString();
    orderFullAmount = double.parse(json["full_amount"]);
    userLocation = json["user_location"].toString();
  }
}