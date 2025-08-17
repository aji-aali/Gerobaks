import 'package:bank_sha/ui/widgets/shared/appbar.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/pages/activity/activity_content.dart';
import 'package:intl/intl.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  DateTime? selectedDate;

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _resetFilter() {
    setState(() {
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      appBar: CustomAppHeader(
        title: 'Activity',
        imageAssetPath: 'assets/ic_calender.png',
        onActionPressed: _pickDate,
      ),
      body: Column(
        children: [
          if (selectedDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Filter: ${DateFormat('d MMMM yyyy', 'id_ID').format(selectedDate!)}',
                      style: blackTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilter,
                    child: Text(
                      'Reset Filter',
                      style: greeTextStyle.copyWith(fontWeight: medium),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: ActivityContent(selectedDate: selectedDate)),
        ],
      ),
    );
  }
}
