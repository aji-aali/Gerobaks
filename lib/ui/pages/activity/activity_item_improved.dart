import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/models/activity_model_improved.dart';
import 'package:bank_sha/utils/activity_helpers.dart';
import 'package:bank_sha/utils/hero_tag_generator.dart';
import 'package:flutter/material.dart';

class ActivityItemImproved extends StatelessWidget {
  final ActivityModel activity;

  const ActivityItemImproved({
    super.key,
    required this.activity,
  });

  Color getStatusColor() {
    switch (activity.status.toLowerCase()) {
      case 'dibatalkan':
        return Colors.red;
      case 'dijadwalkan':
        return Colors.orange;
      case 'menuju lokasi':
        return Colors.blue;
      case 'selesai':
      default:
        return greenColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();

    return GestureDetector(
      onTap: () => showActivityDetailModal(context, activity),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                activity.getIcon(),
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.address,
                    style: greyTextStyle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.dateTime.split('\n').first,
                    style: greyTextStyle.copyWith(fontSize: 12),
                  ),
                  Text(
                    activity.dateTime.split('\n').last,
                    style: greyTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          activity.status,
                          style: blackTextStyle.copyWith(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => showActivityDetailModal(context, activity),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          'Detail',
                          style: greentextstyle2.copyWith(
                            fontWeight: medium,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
