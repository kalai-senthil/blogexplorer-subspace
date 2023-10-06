import 'package:blogexplorer/context/blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class FavouriteDecider extends HookWidget {
  const FavouriteDecider({super.key, required this.blogId});
  final String blogId;
  @override
  Widget build(BuildContext context) {
    final scaleController = useAnimationController(
      duration: const Duration(
        milliseconds: 200,
      ),
    );
    final ani = useListenable(
        Tween<double>(begin: 1.0, end: 1.1).animate(scaleController));
    final isFavourite = context
        .select<BlogContext, bool>((value) => value.favs.contains(blogId));
    return IconButton(
      onPressed: () {
        if (isFavourite) {
          context.read<BlogContext>().removeFromFavs(blogId);
        } else {
          context.read<BlogContext>().addToFavs(blogId);
        }
        scaleController.forward().then((value) {
          scaleController.reverse();
        });
      },
      icon: ScaleTransition(
        scale: ani,
        child: isFavourite
            ? const Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : const Icon(
                Icons.favorite,
              ),
      ),
    );
  }
}
