import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app_intec/Views/Models/cart_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartModel>>((ref){
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String,CartModel>>{
  CartNotifier(): super({});

  void addProductToCart(
  {
    required productName,
    required productPrice,
    required productCategory,
    required imageUrl,
    required qantity,
    required stock,
    required productId,
    required productSize,
    required discount,
    required description
}
      ){
    if(state.containsKey(productId)){
      state = {
        ...state, productId: CartModel(
            productName:state[productId]!.productName,
            productPrice:state[productId]!.productPrice,
            productCategory:state[productId]!.productCategory,
            imageUrl:state[productId]!.imageUrl,
            qantity:state[productId]!.qantity + 1,
            stock:state[productId]!.stock,
            productId:state[productId]!.productId,
            productSize:state[productId]!.productSize,
            discount:state[productId]!.discount,
            description:state[productId]!.description

        )
      };
    }else{
      state ={
        ...state ,productId: CartModel(
          productName: productName,
          productPrice: productPrice,
          productCategory: productCategory,
          imageUrl: imageUrl,
          qantity: qantity,
          stock: stock,
          productId: productId,
          productSize: productSize,
          discount: discount,
          description: description

        )
      };
    }

  }
  //remover producto del carrito
void removeItem(String productId){
    state.remove(productId);
    state = {...state};
}
  //incrementar item en el carrito
void incrementItem(String productId){
    if(state.containsKey(productId)){
      state[productId]!.qantity++;
    }
    state = {...state};
}

//derecemento

  void decrementItem(String productId){
    if(state.containsKey(productId)){
      state[productId]!.qantity--;
    }
    state = {...state};
  }

  //total del carrito

double calculateTotal(){
    double totalAmount =0.0;
    state.forEach((productId, cartItem){
      totalAmount += (cartItem.qantity * (cartItem.productPrice - cartItem.discount));
    });
    return totalAmount;
}
}