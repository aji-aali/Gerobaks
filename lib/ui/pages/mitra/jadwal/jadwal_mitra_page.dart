import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';

class JadwalMitraPage extends StatefulWidget {
  const JadwalMitraPage({super.key});

  @override
  State<JadwalMitraPage> createState() => _JadwalMitraPageState();
}

class _JadwalMitraPageState extends State<JadwalMitraPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: greenColor,
        elevation: 0,
        title: Text(
          'Jadwal Pengambilan',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selector
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Tanggal',
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: greenColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hari ini - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: blackTextStyle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Schedule List
            Text(
              'Jadwal Hari Ini',
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 12),

            // Schedule Items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildScheduleItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(int index) {
    final schedules = [
      {
        'time': '08:00 - 09:00',
        'area': 'Jl. Merdeka Blok A',
        'customers': 15,
        'status': 'pending',
      },
      {
        'time': '09:30 - 10:30',
        'area': 'Perumahan Indah Blok B',
        'customers': 22,
        'status': 'completed',
      },
      {
        'time': '11:00 - 12:00',
        'area': 'Komplek Bumi Asri Blok C',
        'customers': 18,
        'status': 'in_progress',
      },
      {
        'time': '13:00 - 14:00',
        'area': 'Jl. Kenanga Raya',
        'customers': 12,
        'status': 'pending',
      },
      {
        'time': '14:30 - 15:30',
        'area': 'Griya Indah Blok D',
        'customers': 20,
        'status': 'pending',
      },
    ];

    final schedule = schedules[index];
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (schedule['status']) {
      case 'completed':
        statusColor = greenColor;
        statusIcon = Icons.check_circle_rounded;
        statusText = 'Selesai';
        break;
      case 'in_progress':
        statusColor = Colors.blue;
        statusIcon = Icons.access_time_rounded;
        statusText = 'Sedang Proses';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending_rounded;
        statusText = 'Menunggu';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                schedule['time'] as String,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      size: 12,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 16,
                color: greyColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule['area'] as String,
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.people_rounded,
                size: 16,
                color: greyColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${schedule['customers']} pelanggan',
                style: greyTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
