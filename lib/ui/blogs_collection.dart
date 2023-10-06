import 'package:blogexplorer/context/blog.dart';
import 'package:blogexplorer/ui/blog_comp.dart';
import 'package:blogexplorer/ui/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogsCollection extends StatelessWidget {
  const BlogsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select<BlogContext, bool>((value) => value.blogs.isLoading);
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final isError =
        context.select<BlogContext, bool>((value) => value.blogs.isError);
    if (isError) {
      return Center(
        child: Header(text: context.read<BlogContext>().blogs.err!),
      );
    }
    final blogs = context.read<BlogContext>().blogs.data;
    return ListView.builder(
      itemBuilder: (context, index) {
        return BlogComp(
          blog: blogs[blogs.keys.elementAt(index)]!,
        );
      },
      itemCount: blogs.keys.length,
    );
  }
}
