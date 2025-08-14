import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';

class CustomAppHeaderImproved extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? imageAssetPath;
  final IconData? iconData;
  final VoidCallback? onActionPressed;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showIconWithTitle; // Tampilkan ikon di sebelah judul
  final String? titleIconAsset; // Ikon yang ditampilkan di sebelah judul

  const CustomAppHeaderImproved({
    Key? key,
    required this.title,
    this.imageAssetPath,
    this.iconData,
    this.onActionPressed,
    this.actions,
    this.bottom,
    this.showIconWithTitle = false,
    this.titleIconAsset,
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
              : Container(
                  padding: const EdgeInsets.all(4), // Padding untuk memperbaiki alignment
                  child: Image.asset(
                    imageAssetPath!,
                    width: 24,  // Ukuran ikon yang lebih kecil dan konsisten
                    height: 24, 
                    fit: BoxFit.contain, // Pastikan ikon pas dalam container
                  ),
                ),
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
              // Title with optional icon
              Expanded(
                child: showIconWithTitle && titleIconAsset != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: blackTextStyle.copyWith(
                              fontWeight: semiBold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                            titleIconAsset!,
                            width: 24,
                            height: 24,
                          ),
                        ],
                      )
                    : Text(
                        title,
                        style: blackTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 20,
                        ),
                      ),
              ),
              if (actionWidgets.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: actionWidgets.map((widget) {
                    // Add spacing between action icons
                    return Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: widget,
                    );
                  }).toList(),
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
