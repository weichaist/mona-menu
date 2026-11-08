import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:reorderables/reorderables.dart';

class ReorderableCategoryTileColumn extends StatefulWidget {
  final List<String> categoryList;
  final Function(List<String>) afterReordered;
  final Function(int) onTap;
  final int currentCategoryIndex;
  const ReorderableCategoryTileColumn({
    super.key,
    required this.categoryList,
    required this.afterReordered,
    required this.onTap,
    required this.currentCategoryIndex,
  });
  @override
  State<ReorderableCategoryTileColumn> createState() =>
      _ReorderableCategoryTileColumnState();
}

class _ReorderableCategoryTileColumnState
    extends State<ReorderableCategoryTileColumn> {
  void _onReorder(int oldIndex, int newIndex) async {
    setState(() {
      String category = widget.categoryList.removeAt(oldIndex);
      widget.categoryList.insert(newIndex, category);
      widget.afterReordered(widget.categoryList);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.isNotEmpty) {
      return ReorderableColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        onReorder: _onReorder,
        children: <Widget>[
          for (final category in widget.categoryList)
            Column(
              key: ValueKey(category),
              children: [
                ListTile(
                  onTap: () {
                    widget.onTap(widget.categoryList.indexOf(category));
                  },
                  dense: true,
                  minLeadingWidth: 9,
                  title: Text(category),
                  leading: const Icon(Icons.menu, color: kRestaurantLightColor),
                  trailing:
                      widget.currentCategoryIndex ==
                          widget.categoryList.indexOf(category)
                      ? const Icon(
                          CupertinoIcons.circle_fill,
                          size: 12,
                          color: kRestaurantColor,
                        )
                      : const Icon(CupertinoIcons.circle, size: 12),
                ),
                const Divider(color: kRestaurantColor, height: 0),
              ],
            ),
        ],
      );
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            'カテゴリを\n作成しましょう!',
            textAlign: TextAlign.center,
            style: TextStyle(color: kRestaurantColor),
          ),
        ),
      );
    }
  }
}
