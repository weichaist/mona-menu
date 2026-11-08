import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/size_config.dart';

class PostFilterChips extends StatefulWidget {
  const PostFilterChips({
    super.key,
    required this.onTap,
    required this.categories,
    required this.filterCategory,
  });
  final Function(String) onTap;
  final List<String> categories;
  final String filterCategory;

  @override
  State<PostFilterChips> createState() => _PostFilterChipsState();
}

class _PostFilterChipsState extends State<PostFilterChips> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: getScreenWidth(),
      margin: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: kPrimaryLightColor.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              widget.onTap(widget.categories[index]);
            },
            child: Chip(
              label: Text(
                widget.categories[index],
                style: TextStyle(
                  color:
                      widget.categories.indexOf(widget.filterCategory) == index
                      ? Colors.white
                      : kPrimaryColor,
                ),
              ),
              backgroundColor:
                  widget.categories.indexOf(widget.filterCategory) == index
                  ? kPrimaryColor
                  : kPrimaryLightColor,
            ),
          );
        },
      ),
    );
  }
}
