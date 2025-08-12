import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';

class CustomDividerLayout extends StatelessWidget {
  final String title;

  const CustomDividerLayout({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: greyColor, // pastikan greyColor ada di theme
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'or',
              style: greyTextStyle.copyWith(
                fontSize: 14,
              ), // pastikan greyTextStyle tersedia
            ),
          ),
          Expanded(child: Divider(thickness: 1, color: greyColor)),
        ],
      ),
    );
  }
}
