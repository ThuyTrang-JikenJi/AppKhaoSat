import 'package:appkhaosat/main-screen/constants/theme.dart';
import 'package:flutter/material.dart';



class TableCellSettings extends StatelessWidget {
  final String title;
  final Function onTap;
  TableCellSettings({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap(),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: NowUIColors.text)),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.arrow_forward_ios,
                  color: NowUIColors.text, size: 14),
            )
          ],
        ),
      ),
    );
  }
}
