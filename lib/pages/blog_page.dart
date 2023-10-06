import 'dart:math';

import 'package:blogexplorer/context/blog.dart';
import 'package:blogexplorer/ui/blog_img.dart';
import 'package:blogexplorer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final blog = context.read<BlogContext>().blogs.data[id];
    if (blog == null) {
      Future.delayed(
          const Duration(milliseconds: 200), Navigator.of(context).pop);
      return const SizedBox();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: min(
                  context.width,
                  1200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const BackButton(),
                        Text(
                          blog.title,
                          style: GoogleFonts.outfit(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlogImage(url: blog.imageUrl),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
