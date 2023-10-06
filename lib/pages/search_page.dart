import 'dart:math';

import 'package:blogexplorer/context/blog.dart';
import 'package:blogexplorer/models/blog.dart';
import 'package:blogexplorer/ui/blog_comp.dart';
import 'package:blogexplorer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searching = context.watch<BlogContext>().searching;
    if (searching) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final blogs = context
        .select<BlogContext, Map<String, Blog>>((value) => value.searches);
    final keys = blogs.keys;
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: min(context.width, 600)),
              child: Column(
                children: [
                  Row(
                    children: [
                      BackButton(
                        onPressed: () {
                          context.read<BlogContext>().searchClear();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                          autofocus: true,
                          onSubmitted: (val) {
                            context.read<BlogContext>().search(val);
                          },
                          decoration: InputDecoration(
                            hintText: "Type",
                            hintStyle: GoogleFonts.outfit(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return BlogComp(blog: blogs[keys.elementAt(index)]!);
                      },
                      itemCount: keys.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
