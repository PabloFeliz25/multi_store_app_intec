import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod
import '../../providers/cart_provider.dart';
import '../models/product_model.dart'; // Asegúrate de que la ruta sea correcta

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    // Inicializa el estado de favoritos
    isFavorite = widget.product.isFavorite; // Asegúrate de que tu modelo tenga esta propiedad
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Cambia el estado de favorito
    });

    // Actualiza el estado en Firestore
    FirebaseFirestore.instance.collection('productos').doc(widget.product.id).update({
      'isFavorite': isFavorite,
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderNotifier = ref.read(cartProvider.notifier); // Obteniendo el notificador del carrito

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productName),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.product.images[0], // Muestra la primera imagen
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.product.productName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '\$${widget.product.price}',
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.product.description ?? "No description available.",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Añadir el producto al carrito
                cartProviderNotifier.addProductToCart(
                  productName: widget.product.productName,
                  productPrice: widget.product.price,
                  productCategory: widget.product.category,
                  imageUrl: widget.product.images,
                  qantity: 1, // Asumimos que se agrega una unidad por clic
                  stock: widget.product.quantity,
                  productId: widget.product.id,
                  productSize: '0', // Ajusta esto según la lógica de tu aplicación
                  discount: 0.0, // Si hay algún descuento
                  description: widget.product.description,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto añadido al carrito')),
                );
              },
              child: const Text('Añadir al Carrito'),
            ),
          ],
        ),
      ),
    );
  }
}
