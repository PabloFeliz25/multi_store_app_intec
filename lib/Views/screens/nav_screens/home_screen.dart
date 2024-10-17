import 'package:flutter/material.dart';

import '../../widgets/Category_widget.dart';
import '../../widgets/banner_widget.dart';
import '../../widgets/product_screen.dart';
import '../../widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory; // Holds the selected category

  void _onCategorySelected(String? category) {
    setState(() {
      selectedCategory = category; // Update the selected category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: TopBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const BannerWidget(),
            const SizedBox(height: 10),
            CategoryWidget(onCategorySelected: _onCategorySelected),
            const SizedBox(height: 20),
            ProductsWidget(selectedCategory: selectedCategory), // Filter products
          ],
        ),
      ),
    );
  }
}

/*class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(); // Puedes cambiar esto por el contenido que desees
  }
}*/
