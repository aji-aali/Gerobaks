import 'package:flutter/material.dart';
import 'skeleton_loader.dart';

/// A collection of skeleton loaders for common UI patterns
class SkeletonItems {
  
  /// Skeleton for text
  static Widget text({
    double width = double.infinity, 
    double height = 14,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    return Padding(
      padding: margin,
      child: SkeletonLoader(
        width: width,
        height: height,
      ),
    );
  }
  
  /// Skeleton for a card
  static Widget card({
    double? width,
    double height = 120,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(vertical: 8),
    double borderRadius = 12,
  }) {
    return Padding(
      padding: margin,
      child: SkeletonLoader(
        width: width ?? double.infinity,
        height: height,
        borderRadius: borderRadius,
      ),
    );
  }
  
  /// Skeleton for a circle (avatar, icon, etc)
  static Widget circle({
    double size = 48,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    return Padding(
      padding: margin,
      child: SkeletonLoader(
        width: size,
        height: size,
        borderRadius: size / 2,
      ),
    );
  }
  
  /// Skeleton for list item with leading icon/avatar and title/subtitle
  static Widget listItem({
    double? width,
    double height = 64,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(vertical: 8),
  }) {
    return Padding(
      padding: margin,
      child: Row(
        children: [
          circle(size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                text(height: 16),
                const SizedBox(height: 8),
                text(width: 150, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Skeleton for data tile with title, content and optional icon
  static Widget dataTile({
    bool showIcon = true,
    double? width,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(vertical: 8),
  }) {
    return Padding(
      padding: margin,
      child: Row(
        children: [
          if (showIcon) ...[
            circle(size: 32),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                text(width: 100, height: 12),
                const SizedBox(height: 8),
                text(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Skeleton for grid items
  static Widget grid({
    required int crossAxisCount, 
    int itemCount = 6,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double spacing = 16,
    double childAspectRatio = 1.0,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => SkeletonLoader(
        borderRadius: 12,
      ),
    );
  }
}
