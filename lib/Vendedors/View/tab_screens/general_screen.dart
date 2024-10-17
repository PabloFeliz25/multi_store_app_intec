import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class GeneralScreen extends StatefulWidget {
  GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _categoriesList = [];
  String? productName;
  double? price; // Cambiado a tipo double
  String? category;
  double? discount; // Cambiado a tipo double
  int? quantity; // Cambiado a tipo int
  String? description;
  List<XFile>? selectedFiles;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  // Obtener las categorías de Firestore
  Future<void> _getCategories() async {
    QuerySnapshot querySnapshot = await _firebaseFirestore.collection('categories').get();
    setState(() {
      _categoriesList = querySnapshot.docs.map((doc) => doc['categoryName'] as String).toList();
    });
  }

  // Seleccionar imágenes desde la galería
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedFiles = pickedFiles;
      });
    }
  }

  // Subir imágenes a Firebase Storage
  Future<List<String>> _uploadImagesToStorage() async {
    List<String> downloadUrls = [];
    if (selectedFiles != null) {
      for (var file in selectedFiles!) {
        String fileName = file.name;
        var ref = _storage.ref().child('productos').child(fileName);
        UploadTask uploadTask = ref.putFile(File(file.path));
        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadURL);
      }
    }
    return downloadUrls;
  }

  // Subir producto a Firestore
  Future<void> _uploadProductToFirestore(List<String> imageUrls) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      try {
        await _firebaseFirestore.collection('productos').add({
          'productName': productName,
          'price': price, // Guardar como double
          'category': category,
          'discount': discount, // Guardar como double
          'quantity': quantity, // Guardar como int
          'description': description,
          'images': imageUrls,
        });
        EasyLoading.dismiss();
        _formKey.currentState?.reset();
        setState(() {
          selectedFiles = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto subido con éxito')));
      } catch (e) {
        EasyLoading.dismiss();
        print("Error al subir el producto a Firestore: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir el producto')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del producto'),
                onChanged: (value) {
                  productName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Convertir a double
                  price = double.tryParse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un precio válido';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(labelText: 'Categoría'),
                items: _categoriesList.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descuento'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Convertir a double
                  discount = double.tryParse(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Convertir a int
                  quantity = int.tryParse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese una cantidad válida';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
                onChanged: (value) {
                  description = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Seleccionar imágenes'),
              ),
              SizedBox(height: 10),
              selectedFiles != null
                  ? Text('${selectedFiles!.length} imagen(es) seleccionada(s)')
                  : Text('No hay imágenes seleccionadas'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (selectedFiles != null && selectedFiles!.isNotEmpty) {
                    List<String> imageUrls = await _uploadImagesToStorage();
                    await _uploadProductToFirestore(imageUrls);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecciona al menos una imagen')));
                  }
                },
                child: Text('Agregar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
