import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app_intec/providers/cart_provider.dart';


class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen ({super.key});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){

            //anadir el producto al carrito
            _cartProvider.addProductToCart(productName: productName,
                productPrice: productPrice,
                productCategory: productCategory,
                imageUrl: imageUrl,
                qantity: qantity,
                stock: stock,
                productId: productId,
                productSize: productSize,
                discount: discount,
                description: description)
          },
          child: Text('Add To Cart'),
        ),
      ),

    );
  }
}
