import 'package:bank_sha/models/activity_model_improved.dart';
import 'dart:math' as math;

// Function to generate random completed activities
List<ActivityModel> generateCompletedActivities(int count, {bool isActive = false}) {
  final random = math.Random();
  List<ActivityModel> result = [];
  
  for (int i = 0; i < count; i++) {
    // Generate random date in the past 30 days
    final daysAgo = random.nextInt(30) + 1;
    final date = DateTime.now().subtract(Duration(days: daysAgo));
    
    // Random hour between 8am and 6pm
    final hour = 8 + random.nextInt(11); // 8am to 6pm
    final minute = random.nextInt(60);
    final dateTime = DateTime(date.year, date.month, date.day, hour, minute);
    
    // Format date string - menggunakan \n (bukan \\n) sebagai pemisah
    final dateString = '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}\n'
                      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} WIB';
                      
    // Generate activity data
    final activityData = TrashTypesData.generateCompletedActivityData();
    
    result.add(
      ActivityModel(
        id: '${isActive ? 'A' : 'C'}${100 + i}',
        title: isActive ? 'Pengambilan Dijadwalkan' : 'Pengambilan Selesai',
        address: 'Jl. Contoh No. ${random.nextInt(100) + 1}, Jakarta',
        dateTime: dateString,
        status: isActive ? (random.nextBool() ? 'Dijadwalkan' : 'Menuju Lokasi') : 'Selesai',
        isActive: isActive,
        date: dateTime,
        trashDetails: isActive ? null : activityData['trashDetails'],
        totalWeight: isActive ? null : activityData['totalWeight'],
        totalPoints: isActive ? null : activityData['totalPoints'],
        photoProofs: isActive ? null : activityData['photoProofs'],
        completedBy: isActive ? null : activityData['completedBy'],
        notes: isActive ? null : activityData['notes'],
      )
    );
  }
  
  // Sort by date (newest first for active, oldest first for history)
  result.sort((a, b) => isActive ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
  
  return result;
}

// Helper function to get month name
String _getMonthName(int month) {
  final months = [
    'Januari', 'Februari', 'Maret', 'April', 
    'Mei', 'Juni', 'Juli', 'Agustus', 
    'September', 'Oktober', 'November', 'Desember'
  ];
  return months[month - 1];
}

// Kelas untuk mengelola data mock sampah dan icon
class TrashTypesData {
  static Map<String, String> trashIcons = {
    'Organik': 'assets/ic_trashh.png',
    'Plastik': 'assets/ic_trash.png',
    'Kertas': 'assets/ic_trash.png',
    'Kaca': 'assets/ic_trash.png',
    'Logam': 'assets/ic_trash.png',
    'Elektronik': 'assets/ic_trash.png',
    'Lainnya': 'assets/ic_trash.png',
  };

  static List<Map<String, dynamic>> mockTrashCategories = [
    {
      'type': 'Organik',
      'points_per_kg': 5,
      'description': 'Sampah sisa makanan, daun, dan material organik lainnya',
    },
    {
      'type': 'Plastik',
      'points_per_kg': 10,
      'description': 'Botol plastik, kemasan plastik, dan barang plastik lainnya',
    },
    {
      'type': 'Kertas',
      'points_per_kg': 8,
      'description': 'Kertas bekas, kardus, koran, dan bahan kertas lainnya',
    },
    {
      'type': 'Kaca',
      'points_per_kg': 15,
      'description': 'Botol kaca, pecahan kaca, dan barang kaca lainnya',
    },
    {
      'type': 'Logam',
      'points_per_kg': 25,
      'description': 'Kaleng, besi, aluminium, dan logam lainnya',
    },
    {
      'type': 'Elektronik',
      'points_per_kg': 30,
      'description': 'Barang elektronik bekas, kabel, dan peralatan elektronik lainnya',
    },
    {
      'type': 'Lainnya',
      'points_per_kg': 3,
      'description': 'Barang lain yang tidak termasuk dalam kategori di atas',
    },
  ];

  // Gambar mock untuk bukti pengambilan sampah
  static List<String> mockPhotoProofs = [
    'assets/img_profile.png',
    'assets/img_friend1.png',
    'assets/img_friend2.png',
    'assets/img_friend3.png',
    'assets/img_friend4.png',
  ];
  
  // Nama mock untuk petugas
  static List<String> mockOfficers = [
    'Ahmad Petugas',
    'Budi Petugas',
    'Siti Petugas',
    'Dewi Petugas',
    'Joko Petugas',
  ];
  
  // Catatan mock untuk pengambilan
  static List<String> mockNotes = [
    'Pengambilan berjalan lancar, semua sampah sudah disortir dengan baik oleh pengguna.',
    'Pengambilan selesai tepat waktu.',
    'Mendapatkan banyak sampah plastik yang sudah dibersihkan dengan baik.',
    'Sampah elektronik yang dikumpulkan dalam kondisi baik dan dapat didaur ulang.',
    'Pengambilan dilakukan sesuai jadwal. Pelanggan sangat kooperatif.',
    'Pengambilan dilakukan lebih cepat dari perkiraan karena sampah sudah dipersiapkan dengan baik.',
  ];
  
  // Generate data sampah acak untuk aktivitas
  static List<TrashDetail> generateRandomTrashDetails() {
    final random = math.Random();
    List<TrashDetail> result = [];
    final categories = List.from(mockTrashCategories);
    categories.shuffle();
    
    // Ambil 1-4 kategori acak
    final selectedCategories = categories.take(1 + random.nextInt(4));
    
    for (var category in selectedCategories) {
      final type = category['type'];
      final pointsPerKg = category['points_per_kg'];
      // Weight antara 1-10 kg
      final weight = 1 + random.nextInt(10);
      final points = (weight * pointsPerKg).toInt();
      
      result.add(
        TrashDetail(
          type: type,
          weight: weight,
          points: points,
          icon: trashIcons[type],
        ),
      );
    }
    
    return result;
  }
  
  // Generate data lengkap untuk aktivitas selesai
  static Map<String, dynamic> generateCompletedActivityData() {
    final random = math.Random();
    final trashDetails = generateRandomTrashDetails();
    int totalWeight = 0;
    int totalPoints = 0;
    
    for (var trash in trashDetails) {
      totalWeight += trash.weight;
      totalPoints += trash.points;
    }
    
    // Acak jumlah foto bukti (1-3)
    final photoCount = 1 + random.nextInt(3);
    mockPhotoProofs.shuffle();
    final selectedPhotos = mockPhotoProofs.take(photoCount).toList();
    
    // Acak petugas dan catatan
    mockOfficers.shuffle();
    mockNotes.shuffle();
    
    return {
      'trashDetails': trashDetails,
      'totalWeight': totalWeight,
      'totalPoints': totalPoints,
      'photoProofs': selectedPhotos,
      'completedBy': mockOfficers.first,
      'notes': mockNotes.first,
    };
  }
}
