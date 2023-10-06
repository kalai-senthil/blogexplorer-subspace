import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:blogexplorer/models/blog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataModel<T> {
  T data;
  bool isLoading;
  bool isError;
  String? err;
  DataModel({required this.data, this.isError = false, this.isLoading = true});
}

class BlogContext with ChangeNotifier {
  bool searching = false;
  ThemeMode themeMode = ThemeMode.light;
  FToast fToast = FToast();
  bool offline = false;
  Box? appBox;
  bool loading = true;
  Set<String> favs = {};
  Map<String, Blog> searches = {};
  DataModel<Map<String, Blog>> blogs = DataModel(
    data: {},
  );
  BlogContext() {
    init();
  }
  void setToastContext(BuildContext context) {
    fToast.init(context);
  }

  void searchClear() {
    showToast(msg: "Search cleared");
    searches.clear();
    notifyListeners();
  }

  void setTheme(ThemeMode mode) async {
    String msg = '';
    switch (mode) {
      case ThemeMode.light:
        msg = 'Light Mode Toggled';
        break;
      case ThemeMode.dark:
        msg = 'Dark Mode Toggled';
        break;
      default:
    }
    showToast(msg: msg);
    themeMode = mode;
    await appBox?.put("theme", mode);
    notifyListeners();
  }

  void listenForFavs() async {
    if (appBox != null) {
      favs = Set.from(jsonDecode(appBox?.get("favs", defaultValue: [])));
      themeMode = appBox?.get("theme", defaultValue: ThemeMode.light);
      appBox?.watch(key: "favs").listen((event) {
        favs = Set.from(jsonDecode(event.value));
        notifyListeners();
      });
    }
  }

  void addToFavs(String id) async {
    try {
      if (appBox != null) {
        favs.add(id);
        await appBox?.put("favs", jsonEncode(favs.toList()));
        showToast(msg: "Added to Favourites");
      }
    } catch (e) {
      showToast(msg: "Unable to add Favourites");
    } finally {}
  }

  bool onlyFavs = false;
  void showOnlyFavs() {
    onlyFavs = !onlyFavs;
    notifyListeners();
    showToast(msg: "Favourites Filter ${onlyFavs ? 'Applied' : 'Removed'}");
  }

  void search(String val) {
    if (val.isEmpty) {
      showToast(msg: "Empty value");
      searches.clear();
      notifyListeners();
      return;
    }
    searching = true;
    notifyListeners();
    final keys = blogs.data.keys;
    searches.clear();
    for (int i = 0; i < keys.length; i++) {
      Blog? blog = blogs.data[keys.elementAt(i)];
      if (blog != null &&
          blog.title.toLowerCase().contains(val.toLowerCase())) {
        searches.putIfAbsent(keys.elementAt(i), () => blog);
      }
    }
    searching = false;
    showToast(msg: "Searching done");
    notifyListeners();
  }

  void removeFromFavs(String id) async {
    try {
      if (appBox != null) {
        favs.remove(id);
        await appBox?.put("favs", jsonEncode(favs.toList()));
        showToast(msg: "Removed from Favourites");
      }
    } catch (e) {
      showToast(msg: "Unable to remove Favourites");
    } finally {}
  }

  Future<bool> hasInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    bool hasNot = connectivityResult == ConnectivityResult.none;
    offline = hasNot;
    if (offline) {
      showToast(msg: "Offline, Using cached values");
    }
    notifyListeners();
    return !hasNot;
  }

  void init() async {
    try {
      appBox = await Hive.openBox("app");
      listenForFavs();
    } catch (e) {
      showToast(msg: "Error initialing Local DB");
    } finally {
      loading = false;
      notifyListeners();
    }
    fetchBlogs();
  }

  void showToast({required String msg}) {
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black,
        ),
        child: Text(
          msg,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void fetchBlogs() async {
    if (!await hasInternet()) {
      blogs.data = await appBox?.get("blogs", defaultValue: []);
    }
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';
    blogs.isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        Map resData = jsonDecode(response.body);
        resData['blogs'].forEach((blogMap) {
          Blog blog = Blog.fromJSON(blogMap);
          blogs.data.putIfAbsent(blog.id, () => blog);
        });
        await appBox?.put("blogs", blogs.data);
        showToast(msg: "Blogs Loaded");
      } else {
        showToast(msg: "Unable to retrieve blogs");
      }
    } catch (e) {
      blogs.isError = true;
      blogs.err = '$e';
      showToast(msg: "Error loading blogs");
    } finally {
      blogs.isLoading = false;
      notifyListeners();
    }
  }
}
