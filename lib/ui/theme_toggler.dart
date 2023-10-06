import 'package:blogexplorer/context/blog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeToggler extends StatelessWidget {
  const ThemeToggler({super.key});

  @override
  Widget build(BuildContext context) {
    final mode =
        context.select<BlogContext, ThemeMode>((value) => value.themeMode);
    return IconButton(
      onPressed: () => context
          .read<BlogContext>()
          .setTheme(mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light),
      icon: Icon(
        mode == ThemeMode.dark ? Icons.sunny : Icons.nightlight_round_rounded,
      ),
    );
  }
}
