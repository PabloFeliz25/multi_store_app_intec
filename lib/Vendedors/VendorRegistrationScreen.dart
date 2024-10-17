import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  _VendorRegistrationScreenState createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Controladores para los campos del formulario
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _rncController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Variables para la imagen
  File? _image;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  // Función para seleccionar imagen desde la galería
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(); // Subir la imagen una vez seleccionada
    }
  }

  // Función para subir imagen a Firebase Storage y obtener la URL de descarga
  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        String uid = _firebaseAuth.currentUser!.uid;
        Reference storageRef = _firebaseStorage
            .ref()
            .child('vendor_images/$uid/${DateTime.now()}.jpg');
        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl; // Guardar la URL de la imagen
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen subida exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Función para enviar los detalles del vendedor
  Future<void> _submitVendorDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        String uid = _firebaseAuth.currentUser!.uid;

        // Crear el mapa de datos del vendedor
        Map<String, dynamic> vendorData = {
          'vendorId': uid,
          'approved': false,
          'businessName': _businessNameController.text,
          'city': _cityController.text,
          'country': _countryController.text,
          'email': _emailController.text,
          'image': _imageUrl, // Usar la URL de la imagen subida
          'phoneNumber': _phoneNumberController.text,
          'rnc': _rncController.text,
          'tax': _taxController.text,
        };

        // Guardar los datos del vendedor en Firestore
        await _firebaseFirestore.collection('vendors').doc(uid).set(vendorData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Detalles del vendedor enviados correctamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Vendedor"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Registra tu Negocio',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _businessNameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Negocio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del negocio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'Ciudad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su ciudad';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: 'País',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su país';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Número de Teléfono',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su número de teléfono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _rncController,
                  decoration: InputDecoration(
                    labelText: 'RNC',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.account_balance),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su RNC';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _taxController,
                  decoration: InputDecoration(
                    labelText: 'Número de Impuestos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su número de impuestos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // Image Picker
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Seleccionar Imagen'),
                    ),
                    const SizedBox(width: 10),
                    _image != null
                        ? const Text('Imagen Seleccionada')
                        : const Text('No se seleccionó imagen'),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitVendorDetails,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    'Enviar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
