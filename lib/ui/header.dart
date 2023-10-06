import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.text, this.widget = const SizedBox()});
  final String text;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          widget,
        ],
      ),
    );
  }
}
