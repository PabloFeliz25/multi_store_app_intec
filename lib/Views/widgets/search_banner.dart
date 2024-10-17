import 'package:flutter/material.dart';

class SearchBanner extends StatelessWidget {
  const SearchBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.16,
      child: Stack(
        children: [
          Image.asset(
            'assets/icons/searchbanner.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 48.0,
            top: 68.0,
            child: SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Look for something...',
                  hintStyle: const TextStyle(
                    color: Color(0xff7f7f7f),
                    fontSize: 14.0,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 60,
            child: InkWell(
              onTap: () {
                // Add your search functionality here
              },
              child: Image.asset(
                'assets/icons/search.png',
                width: 70,
                height: 70,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}