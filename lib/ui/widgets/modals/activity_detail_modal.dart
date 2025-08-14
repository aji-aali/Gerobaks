import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/models/activity_model_improved.dart';
import 'package:bank_sha/utils/hero_tag_generator.dart';

class ActivityDetailModal extends StatelessWidget {
  final ActivityModel activity;

  const ActivityDetailModal({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Row(
            children: [
              Text(
                'Detail Aktivitas',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: blackColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const Divider(height: 24),
          
          // Status Badge
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(activity.status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    activity.getIcon(),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activity.status,
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                      color: _getStatusColor(activity.status),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Info Section
          _buildInfoItem('Judul', activity.title),
          _buildInfoItem('Alamat', activity.address),
          _buildInfoItem('Waktu', activity.dateTime),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              if (activity.isActive && activity.status.toLowerCase() == 'menuju lokasi')
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/tracking_full');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Lacak Pengambilan'),
                  ),
                ),
              
              if (activity.isActive && activity.status.toLowerCase() == 'dijadwalkan')
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showRescheduleDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Atur Ulang Jadwal'),
                  ),
                ),
              
              if (activity.isActive)
                const SizedBox(width: 12),
              
              if (activity.isActive)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCancelConfirmationDialog(context);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      'Batalkan',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                
              if (!activity.isActive)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Tutup'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: greyTextStyle.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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
  
  void _showRescheduleDialog(BuildContext context) {
    DateTime selectedDate = activity.date;
    TimeOfDay selectedTime = TimeOfDay(hour: activity.date.hour, minute: activity.date.minute);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Atur Ulang Jadwal',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date selector
                  ListTile(
                    leading: Icon(Icons.calendar_today, color: greenColor),
                    title: Text(
                      'Tanggal',
                      style: blackTextStyle.copyWith(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: blackTextStyle.copyWith(
                        fontSize: 16, 
                        fontWeight: medium,
                      ),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: greenColor,
                                onPrimary: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                  ),
                  // Time selector
                  ListTile(
                    leading: Icon(Icons.access_time, color: greenColor),
                    title: Text(
                      'Waktu',
                      style: blackTextStyle.copyWith(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                      style: blackTextStyle.copyWith(
                        fontSize: 16, 
                        fontWeight: medium,
                      ),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: greenColor,
                                onPrimary: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (time != null) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: greyTextStyle,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Simulasi update jadwal
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Jadwal berhasil diperbarui',
                          style: whiteTextStyle,
                        ),
                        backgroundColor: greenColor,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                  ),
                  child: Text(
                    'Simpan Perubahan',
                    style: whiteTextStyle,
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }
  
  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Pembatalan',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin membatalkan aktivitas ini?',
            style: blackTextStyle.copyWith(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Tidak',
                style: greyTextStyle,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Simulasi pembatalan
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Aktivitas berhasil dibatalkan',
                      style: whiteTextStyle,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Ya, Batalkan',
                style: whiteTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
