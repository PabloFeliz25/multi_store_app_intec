import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyLoginRegisterButton extends StatelessWidget {
   MyLoginRegisterButton({
    super.key, required this.text, this.onTap,
  });

   final String text;
   final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF4f4ff0),
                Color(0xff1e1cc9)
              ]
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(text,
            style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                )
            ),
          ),
        ),
      ),
    );
  }
}

