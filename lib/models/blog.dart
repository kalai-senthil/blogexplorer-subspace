import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'blog.g.dart';

@HiveType(typeId: 0)
class Blog {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String imageUrl;
  @HiveField(2)
  final String title;

  Blog({
    required this.id,
    required this.imageUrl,
    required this.title,
  });

  factory Blog.fromJSON(Map data) {
    return Blog(
      id: data['id'],
      imageUrl: data['image_url'],
      title: data['title'],
    );
  }
}
