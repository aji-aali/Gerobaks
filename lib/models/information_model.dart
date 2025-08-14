class InformationModel {
  final String image;
  final String title;
  final String description;
  final String detailTitle;
  final String detailDescription;
  final List<String> detailPoints;
  final String buttonText;
  final String? buttonRoute;

  InformationModel({
    required this.image,
    required this.title,
    required this.description,
    required this.detailTitle,
    required this.detailDescription,
    required this.detailPoints,
    this.buttonText = 'Lihat Selengkapnya',
    this.buttonRoute,
  });
}

// Data untuk informasi carousel
List<InformationModel> informationList = [
  InformationModel(
    image: 'assets/img_pesut.jpeg',
    title: 'Halo, Samarinda',
    description: 'Kami akan segera hadir di Kota Samarinda, Stay Tuned!',
    detailTitle: 'Gerobaks Hadir di Samarinda',
    detailDescription: 'Kabar gembira bagi warga Samarinda! Gerobaks akan segera hadir di kota Anda dengan berbagai layanan terbaik untuk pengelolaan sampah.',
    detailPoints: [
      'Layanan penjemputan sampah langsung dari rumah Anda',
      'Pemilahan sampah organik dan anorganik',
      'Penukaran sampah dengan poin rewards',
      'Pantau jadwal pengambilan sampah secara real-time',
    ],
    buttonText: 'Daftar Sekarang',
    buttonRoute: '/register',
  ),
  InformationModel(
    image: 'assets/img_gerobaks.png',
    title: 'Fitur Baru',
    description: 'Nikmati pengalaman baru menggunakan aplikasi Gerobaks!',
    detailTitle: 'Fitur Baru Gerobaks',
    detailDescription: 'Kami terus berinovasi untuk memberikan pengalaman terbaik. Berikut adalah fitur-fitur terbaru yang telah kami kembangkan:',
    detailPoints: [
      'Notifikasi real-time untuk pengingat jadwal pengambilan',
      'Tracking truk pengangkut sampah secara langsung',
      'Sistem poin reward yang lebih menguntungkan',
      'Laporan statistik penggunaan dan dampak lingkungan',
      'Pembayaran dengan berbagai metode yang lebih mudah',
    ],
    buttonText: 'Coba Sekarang',
  ),
  InformationModel(
    image: 'assets/img_card3.png',
    title: 'Green City',
    description: 'Bersama Gerobaks menuju kota yang lebih hijau dan bersih',
    detailTitle: 'Program Green City',
    detailDescription: 'Gerobaks berkomitmen untuk mendukung program Green City dengan berbagai inisiatif lingkungan yang berkelanjutan.',
    detailPoints: [
      'Pengurangan emisi karbon melalui rute pengambilan yang efisien',
      'Program daur ulang sampah menjadi produk bernilai ekonomi',
      'Edukasi pengelolaan sampah untuk masyarakat',
      'Kolaborasi dengan pemerintah kota untuk menciptakan lingkungan yang lebih bersih',
      'Dukungan untuk bank sampah lokal dan UMKM daur ulang',
    ],
    buttonText: 'Bergabung dengan Gerakan',
    buttonRoute: '/green-city',
  ),
];
