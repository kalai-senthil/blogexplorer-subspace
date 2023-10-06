import 'package:blogexplorer/context/blog.dart';
import 'package:blogexplorer/models/blog.dart';
import 'package:blogexplorer/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BlogAdapter());
  Hive.registerAdapter(ThemeModeAdapter());
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BlogContext(),
        )
      ],
      child: Consumer<BlogContext>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: FToastBuilder(),
            navigatorKey: navigatorKey,
            title: 'Blog Explorer',
            theme: value.themeMode == ThemeMode.dark
                ? ThemeData.dark(
                    useMaterial3: true,
                  )
                : ThemeData(
                    useMaterial3: true,
                  ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
