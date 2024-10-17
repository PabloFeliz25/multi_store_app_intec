import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app_intec/providers/cart_provider.dart';

import '../../widgets/CheckOutScreen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProviderNotifier = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final totalAmount = cartProviderNotifier.calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: cartData.isEmpty
          ? Center(child: const Text('Tu carrito está vacío'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartData.length,
              itemBuilder: (context, index) {
                final productId = cartData.keys.toList()[index];
                final cartItem = cartData[productId]!;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      cartItem.imageUrl.isNotEmpty
                          ? cartItem.imageUrl[0]  // Mostrar la primera imagen
                          : 'https://via.placeholder.com/150', // Imagen por defecto
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/error.png', // Imagen local para error
                          width: 50,
                          height: 50,
                        );
                      },
                    ),
                    title: Text(cartItem.productName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad: ${cartItem.qantity}'),
                        Text('Precio: \$${(cartItem.productPrice - cartItem.discount).toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (cartItem.qantity > 1) {
                              cartProviderNotifier.decrementItem(productId);
                            } else {
                              cartProviderNotifier.removeItem(productId);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (cartItem.qantity < cartItem.stock) {
                              cartProviderNotifier.incrementItem(productId);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cartProviderNotifier.removeItem(productId);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(),
                      ),
                    );
                  },
                  child: const Text('Ir a Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
