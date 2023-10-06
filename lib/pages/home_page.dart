import 'dart:math';

import 'package:blogexplorer/context/blog.dart';
import 'package:blogexplorer/main.dart';
import 'package:blogexplorer/pages/search_page.dart';
import 'package:blogexplorer/ui/blogs_collection.dart';
import 'package:blogexplorer/ui/header.dart';
import 'package:blogexplorer/ui/theme_toggler.dart';
import 'package:blogexplorer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogContext>().setToastContext(navigatorKey.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final loading =
            context.select<BlogContext, bool>((value) => value.loading);
        return Center(
          child: loading
              ? const CircularProgressIndicator()
              : ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: min(context.width, 600),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Header(
                        text: "Blogs",
                        widget: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return const SearchPage();
                                  },
                                ));
                              },
                              icon: const Icon(
                                Icons.search_rounded,
                              ),
                            ),
                            const ThemeToggler(),
                            IconButton(
                              onPressed:
                                  context.read<BlogContext>().showOnlyFavs,
                              icon: const Icon(
                                Icons.favorite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: BlogsCollection(),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
