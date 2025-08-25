import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';

class PengambilanListPage extends StatefulWidget {
  const PengambilanListPage({super.key});

  @override
  State<PengambilanListPage> createState() => _PengambilanListPageState();
}

class _PengambilanListPageState extends State<PengambilanListPage> {
  String selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: greenColor,
        elevation: 0,
        title: Text(
          'Daftar Pengambilan',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement filter
            },
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildFilterTab('Semua', 'all'),
                _buildFilterTab('Pending', 'pending'),
                _buildFilterTab('Proses', 'in_progress'),
                _buildFilterTab('Selesai', 'completed'),
              ],
            ),
          ),

          // Pickup List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 8,
              itemBuilder: (context, index) {
                return _buildPickupItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, String value) {
    final isSelected = selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? whiteColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? semiBold : regular,
              color: isSelected ? greenColor : greyColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickupItem(int index) {
    final pickups = [
      {
        'id': 'PU-001',
        'customer': 'Ahmad Sulaiman',
        'address': 'Jl. Merdeka No. 1, Jakarta',
        'time': '08:30',
        'type': 'Reguler',
        'status': 'pending',
      },
      {
        'id': 'PU-002',
        'customer': 'Siti Rahma',
        'address': 'Perumahan Indah Blok C2/15',
        'time': '09:15',
        'type': 'Organik',
        'status': 'completed',
      },
      {
        'id': 'PU-003',
        'customer': 'Budi Santoso',
        'address': 'Komplek Bumi Indah A5/7',
        'time': '10:00',
        'type': 'Reguler',
        'status': 'in_progress',
      },
      {
        'id': 'PU-004',
        'customer': 'Dewi Lestari',
        'address': 'Jl. Kenanga No. 45',
        'time': '10:45',
        'type': 'B3',
        'status': 'pending',
      },
      {
        'id': 'PU-005',
        'customer': 'Rudi Hermawan',
        'address': 'Griya Indah Blok D10/3',
        'time': '11:30',
        'type': 'Reguler',
        'status': 'pending',
      },
      {
        'id': 'PU-006',
        'customer': 'Maya Sari',
        'address': 'Villa Mutiara Blok E8',
        'time': '13:00',
        'type': 'Organik',
        'status': 'completed',
      },
      {
        'id': 'PU-007',
        'customer': 'Andi Wijaya',
        'address': 'Perumahan Asri Blok F12',
        'time': '14:15',
        'type': 'Reguler',
        'status': 'pending',
      },
      {
        'id': 'PU-008',
        'customer': 'Linda Sari',
        'address': 'Komplek Indah Blok G5',
        'time': '15:00',
        'type': 'B3',
        'status': 'pending',
      },
    ];

    final pickup = pickups[index];
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (pickup['status']) {
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

    Color typeColor;
    switch (pickup['type']) {
      case 'Organik':
        typeColor = greenColor;
        break;
      case 'B3':
        typeColor = Colors.red;
        break;
      default:
        typeColor = Colors.blue;
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
                pickup['id'] as String,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      pickup['type'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: typeColor,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          size: 10,
                          color: statusColor,
                        ),
                        const SizedBox(width: 2),
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
            ],
          ),
          const SizedBox(height: 8),
          Text(
            pickup['customer'] as String,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14,
                color: greyColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  pickup['address'] as String,
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: greyColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Estimasi: ${pickup['time']}',
                style: greyTextStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: View details
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: greenColor),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    'Detail',
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: pickup['status'] == 'pending'
                      ? () {
                          // TODO: Start pickup
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    pickup['status'] == 'pending' ? 'Mulai' : 'Selesai',
                    style: whiteTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
