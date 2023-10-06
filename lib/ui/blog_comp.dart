import 'package:blogexplorer/context/blog.dart';
import 'package:blogexplorer/models/blog.dart';
import 'package:blogexplorer/pages/blog_page.dart';
import 'package:blogexplorer/ui/blog_img.dart';
import 'package:blogexplorer/ui/favourite_decider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BlogComp extends StatelessWidget {
  const BlogComp({super.key, required this.blog});
  final Blog blog;
  @override
  Widget build(BuildContext context) {
    final onlyFavs = context.select<BlogContext, bool>((v) => v.onlyFavs);
    final favs = context.select<BlogContext, Set<String>>((v) => v.favs);

    if ((onlyFavs ? favs.contains(blog.id) : true)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlogPage(
                  id: blog.id,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlogImage(url: blog.imageUrl),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 6,
                    child: Text(
                      blog.title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  FavouriteDecider(
                    blogId: blog.id,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
