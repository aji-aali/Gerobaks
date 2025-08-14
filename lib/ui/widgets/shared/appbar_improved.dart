import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';

class CustomAppHeaderImproved extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? imageAssetPath;
  final IconData? iconData;
  final VoidCallback? onActionPressed;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const CustomAppHeaderImproved({
    Key? key,
    required this.title,
    this.imageAssetPath,
    this.iconData,
    this.onActionPressed,
    this.actions,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actionWidgets = [];
    
    // Add primary action if specified
    if ((iconData != null || imageAssetPath != null) && onActionPressed != null) {
      actionWidgets.add(
        GestureDetector(
          onTap: onActionPressed,
          child: iconData != null
              ? Icon(iconData, color: blackColor, size: 24)
              : Image.asset(imageAssetPath!, width: 32, height: 32),
        ),
      );
    }
    
    // Add additional actions if any
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }
    
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: uicolor,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 5, 24, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: blackTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 20,
                ),
              ),
              if (actionWidgets.isNotEmpty)
                Row(
                  children: actionWidgets,
                ),
            ],
          ),
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(50 + bottomHeight);
  }
}
