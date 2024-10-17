import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app_intec/providers/cart_provider.dart';
import '../models/cart_model.dart'; // Asegúrate de tener tu modelo de carrito

class CheckoutScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider); // Obtener los productos del carrito
    final totalPrice = cartItems.values.fold(0.0, (total, item) => total + (item.productPrice * item.qantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Sección de Productos en el Carrito
            const Text(
              'Producto(s) en el Carrito',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (cartItems.isNotEmpty) ...[
              for (var item in cartItems.values)
                Card(
                  child: ListTile(
                    leading: Image.network(item.imageUrl[0]), // Mostrar la primera imagen
                    title: Text(item.productName),
                    subtitle: Text('Cantidad: ${item.qantity} | \$${item.productPrice.toStringAsFixed(2)}'),
                    trailing: Text('\$${(item.productPrice * item.qantity).toStringAsFixed(2)}'),
                  ),
                ),
            ] else
              const Center(child: Text('El carrito está vacío')),

            const SizedBox(height: 20),

            // Sección de Métodos de Pago
            const Text(
              'Seleccionar Método de Pago',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PaymentMethodSelection(),

            const SizedBox(height: 20),

            // Mostrar el Total
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Botón de Confirmación de Pago
            ElevatedButton(
              onPressed: () {
                // Aquí puedes manejar el flujo para confirmar la compra
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compra realizada con éxito')),
                );
              },
              child: const Text('Confirmar Pago'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodSelection extends StatefulWidget {
  @override
  _PaymentMethodSelectionState createState() => _PaymentMethodSelectionState();
}

class _PaymentMethodSelectionState extends State<PaymentMethodSelection> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Tarjeta de Crédito'),
          value: 'credit_card',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('PayPal'),
          value: 'paypal',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Transferencia Bancaria'),
          value: 'bank_transfer',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value;
            });
          },
        ),
        if (_selectedPaymentMethod != null)
          Text(
            'Método seleccionado: ${_getPaymentMethodLabel(_selectedPaymentMethod!)}',
            style: const TextStyle(color: Colors.green),
          ),
      ],
    );
  }

  String _getPaymentMethodLabel(String value) {
    switch (value) {
      case 'credit_card':
        return 'Tarjeta de Crédito';
      case 'paypal':
        return 'PayPal';
      case 'bank_transfer':
        return 'Transferencia Bancaria';
      default:
        return '';
    }
  }
}
