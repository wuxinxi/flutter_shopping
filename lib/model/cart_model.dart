class CartModel {
  String goodsId;
  String goodsName;
  int count;
  double price;
  String images;
  //0是未选择 1是选择
  int isCheck;

  CartModel(
      {this.goodsId,
      this.goodsName,
      this.count = 0,
      this.price = 0.0,
      this.images,
      this.isCheck = 0});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['count'] = this.count;
    data['price'] = this.price;
    data['images'] = this.images;
    data['isCheck'] = this.isCheck;
    return data;
  }

  CartModel.fromJson(Map<String, dynamic> json) {
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
    count = json['count'];
    price = json['price'];
    images = json['images'];
    isCheck = json['isCheck'];
  }

  @override
  String toString() {
    return 'CartModel{goodsId: $goodsId, goodsName: $goodsName, count: $count, price: $price, images: $images, isCheck: $isCheck}';
  }
}
