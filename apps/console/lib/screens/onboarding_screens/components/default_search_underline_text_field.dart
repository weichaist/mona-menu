import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class DefaultSearchUnderlineTextField extends StatelessWidget {
  final Function onChanged;
  final String hintText;
  final bool enabled;
  final bool autofocus;
  const DefaultSearchUnderlineTextField({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        autofocus: autofocus,
        enabled: enabled,
        style: const TextStyle(color: kRestaurantColor, fontSize: 18),
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kRestaurantColor),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kRestaurantColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kRestaurantColor),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: kRestaurantColor),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          hintText: hintText,
        ),
        cursorColor: kRestaurantColor,
        onChanged: (val) => onChanged(val),
      ),
    );
  }
}
