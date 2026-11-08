import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class SelectAccountTypeChips extends StatefulWidget {
  final Function(String) accountType;
  final String? type;
  const SelectAccountTypeChips({
    super.key,
    required this.accountType,
    this.type,
  });

  @override
  State<SelectAccountTypeChips> createState() => _SelectAccountTypeChipsState();
}

class _SelectAccountTypeChipsState extends State<SelectAccountTypeChips> {
  late String _selectedType;
  @override
  void initState() {
    if (widget.type == null) {
      _selectedType = '';
    } else {
      _selectedType = widget.type!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          tr('Account type ※'),
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            widget.accountType('普通');
            setState(() {
              _selectedType = '普通';
            });
          },
          child: Chip(
            label: Text(
              tr('Usually'),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: _selectedType == '普通'
                ? kPrimaryColor
                : Colors.black26,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            widget.accountType('当座');
            setState(() {
              _selectedType = '当座';
            });
          },
          child: Chip(
            label: Text(
              tr('Current'),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: _selectedType == '当座'
                ? kPrimaryColor
                : Colors.black26,
          ),
        ),
      ],
    );
  }
}
