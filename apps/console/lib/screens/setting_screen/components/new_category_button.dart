import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/screens/setting_screen/components/build_category_bottom_sheet.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';

class NewCategoryButton extends StatefulWidget {
  final Function(String) onCreate;
  final List<String> categories;
  const NewCategoryButton({
    super.key,
    required this.onCreate,
    required this.categories,
  });

  @override
  State<NewCategoryButton> createState() => _NewCategoryButtonState();
}

class _NewCategoryButtonState extends State<NewCategoryButton> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [kDefaultShadow],
      ),
      child: ListTile(
        dense: true,
        onTap: () async {
          final newCategory = await buildCategoryBottomSheet(null);
          if (newCategory != null) {
            if (!widget.categories.contains(newCategory)) {
              widget.onCreate(newCategory);
              _controller.clear();
            } else {
              buildGetSnackbar('カテゴリはすでに追加されました', 'テゴリエラー');
            }
          }
        },
        title: const Text('新しいカテゴリを追加'),
        subtitle: Text('カテゴリ数: ${widget.categories.length}'),
        trailing: const Icon(
          CupertinoIcons.add_circled,
          color: kRestaurantColor,
        ),
      ),
    );
  }
}
