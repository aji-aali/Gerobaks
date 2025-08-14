class TrashDetail {
  final String type; // Jenis sampah (Organik, Plastik, Kertas, dll)
  final int weight; // Berat dalam kg
  final int points; // Poin yang diberikan
  final String? icon; // Icon untuk jenis sampah

  TrashDetail({
    required this.type,
    required this.weight,
    required this.points,
    this.icon,
  });
}

class ActivityModel {
  final String id;
  final String title;
  final String address;
  final String dateTime;
  final String status;
  final bool isActive;
  final DateTime date;
  
  // Data tambahan untuk pengambilan selesai
  final List<TrashDetail>? trashDetails;
  final int? totalWeight;  // dalam kg
  final int? totalPoints;
  final List<String>? photoProofs;
  final String? completedBy;
  final String? notes;

  ActivityModel({
    required this.id,
    required this.title,
    required this.address,
    required this.dateTime,
    required this.status,
    required this.isActive,
    required this.date,
    this.trashDetails,
    this.totalWeight,
    this.totalPoints,
    this.photoProofs,
    this.completedBy,
    this.notes,
  });

  // Helper method untuk mendapatkan kategori dari status
  String getCategory() {
    switch (status.toLowerCase()) {
      case 'dijadwalkan':
        return 'Dijadwalkan';
      case 'menuju lokasi':
        return 'Menuju Lokasi';
      case 'selesai':
        return 'Selesai';
      case 'dibatalkan':
        return 'Dibatalkan';
      default:
        return 'Lainnya';
    }
  }

  // Helper method untuk icon
  String getIcon() {
    switch (status.toLowerCase()) {
      case 'dijadwalkan':
        return 'assets/ic_calender_search.png';
      case 'menuju lokasi':
        return 'assets/ic_truck_otw.png';
      case 'selesai':
        return 'assets/ic_check.png';
      case 'dibatalkan':
        return 'assets/ic_trash.png';
      default:
        return 'assets/ic_trash.png';
    }
  }
}

// Data contoh aktivitas
List<ActivityModel> sampleActivities = [
  ActivityModel(
    id: '001',
    title: 'Menuju Lokasi Pengambilan',
    address: 'Jl Kenangan No. 12',
    dateTime: '27 Agustus 2025\n08:00 WIB',
    status: 'Menuju Lokasi',
    isActive: true,
    date: DateTime(2025, 8, 27, 8, 0),
  ),
  ActivityModel(
    id: '002',
    title: 'Dijadwalkan',
    address: 'Jl Kenangan No. 12',
    dateTime: '28 Agustus 2025\n14:30 WIB',
    status: 'Dijadwalkan',
    isActive: true,
    date: DateTime(2025, 8, 28, 14, 30),
  ),
  ActivityModel(
    id: '003',
    title: 'Pengambilan Dibatalkan',
    address: 'Jl Kenangan No. 12',
    dateTime: '26 Agustus 2025\n10:00 WIB',
    status: 'Dibatalkan',
    isActive: false,
    date: DateTime(2025, 8, 26, 10, 0),
  ),
  ActivityModel(
    id: '004',
    title: 'Pengambilan Selesai',
    address: 'Jl Kenangan No. 12',
    dateTime: '25 Agustus 2025\n09:00 WIB',
    status: 'Selesai',
    isActive: false,
    date: DateTime(2025, 8, 25, 9, 0),
    trashDetails: [
      TrashDetail(
        type: 'Organik',
        weight: 5,
        points: 25,
        icon: 'assets/ic_trash.png',
      ),
      TrashDetail(
        type: 'Plastik',
        weight: 3,
        points: 30,
        icon: 'assets/ic_trash.png',
      ),
      TrashDetail(
        type: 'Kertas',
        weight: 2,
        points: 15,
        icon: 'assets/ic_trash.png',
      ),
    ],
    totalWeight: 10,
    totalPoints: 70,
    photoProofs: [
      'assets/img_profile.png', // Placeholder gambar
      'assets/img_profile.png', // Placeholder gambar
    ],
    completedBy: 'Ahmad Petugas',
    notes: 'Pengambilan berjalan lancar, semua sampah sudah disortir dengan baik oleh pengguna.',
  ),
  ActivityModel(
    id: '005',
    title: 'Pengambilan Selesai',
    address: 'Jl Kenangan No. 12',
    dateTime: '24 Agustus 2025\n11:00 WIB',
    status: 'Selesai',
    isActive: false,
    date: DateTime(2025, 8, 24, 11, 0),
    trashDetails: [
      TrashDetail(
        type: 'Organik',
        weight: 3,
        points: 15,
        icon: 'assets/ic_trash.png',
      ),
      TrashDetail(
        type: 'Elektronik',
        weight: 1,
        points: 25,
        icon: 'assets/ic_trash.png',
      ),
    ],
    totalWeight: 4,
    totalPoints: 40,
    photoProofs: [
      'assets/img_profile.png', // Placeholder gambar
    ],
    completedBy: 'Budi Petugas',
    notes: 'Pengambilan selesai tepat waktu.',
  ),
  ActivityModel(
    id: '006',
    title: 'Pengambilan Selesai',
    address: 'Jl Kenangan No. 12',
    dateTime: '23 Agustus 2025\n10:00 WIB',
    status: 'Selesai',
    isActive: false,
    date: DateTime(2025, 8, 23, 10, 0),
  ),
  ActivityModel(
    id: '007',
    title: 'Dijadwalkan',
    address: 'Jl Melati No. 45',
    dateTime: '30 Agustus 2025\n09:00 WIB',
    status: 'Dijadwalkan',
    isActive: true,
    date: DateTime(2025, 8, 30, 9, 0),
  ),
];
