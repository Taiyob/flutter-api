class Product {
  String? id;
  String? productName;
  String? productCode;
  String? image;
  String? unitPrice;
  String? quantity;
  String? totalPrice;
  String? createdDate;
  Product(
      {this.id,
      this.productName,
      this.productCode,
      this.image,
      this.unitPrice,
      this.quantity,
      this.totalPrice,
      this.createdDate});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['ProductName'];
    productCode = json['ProductCode'];
    unitPrice = json['UnitPrice'];
    image = json['Img'];
    quantity = json['Qty'];
    totalPrice = json['TotalPrice'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson(){
    return {
      "Img": image,
      "ProductCode": productCode,
      "ProductName": productName,
      "Qty": quantity,
      "TotalPrice": totalPrice,
      "UnitPrice": unitPrice,
    };
  }
}
