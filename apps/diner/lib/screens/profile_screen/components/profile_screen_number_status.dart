import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class ProfileScreenNumberStatus extends StatelessWidget {
  final String topNumber;
  final String bottomDescription;
  final bool? isCurrency;
  final VoidCallback? onTap;
  const ProfileScreenNumberStatus({
    super.key,
    required this.topNumber,
    required this.bottomDescription,
    this.isCurrency,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    topNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      bottomDescription,
                      style: const TextStyle(
                        color: kBodyTextColor,
                        fontSize: 10.8,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
