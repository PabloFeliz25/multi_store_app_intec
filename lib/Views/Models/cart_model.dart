class CartModel{
  final String productName;
  final double productPrice;
  final String productCategory;
  final List<dynamic> imageUrl;
  int qantity;
  final int stock;
  final String productId;
  final String productSize;
  final double discount;
  final String description;

  CartModel(
      {required this.productName,
        required this.productPrice,
        required this.productCategory,
        required this.imageUrl,
        required this.qantity,
        required this.stock,
        required this.productId,
        required this.productSize,
        required this.discount,
        required this.description
      });
}