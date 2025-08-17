# 🚛 Gerobaks

<div align="center">

![Gerobaks Logo](assets/img_gerobakss.png)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.8-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange.svg)](https://flutter.dev/)
[![Status](https://img.shields.io/badge/Status-Development-yellowgreen.svg)]()

**Solusi Cerdas untuk Pengelolaan Sampah Berkelanjutan**

</div>

---

## 📱 Tentang Gerobaks

Gerobaks adalah aplikasi mobile berbasis Flutter yang bertujuan untuk menciptakan lingkungan yang bersih dan berkelanjutan melalui pengelolaan sampah yang efisien. Aplikasi ini memungkinkan pengguna untuk:

- 🔄 Menjadwalkan pengambilan sampah secara rutin
- 📊 Melacak proses pengambilan sampah secara real-time
- 💰 Mendapatkan poin rewards dari aktivitas daur ulang
- 📝 Melihat riwayat aktivitas pengelolaan sampah
- 🗺️ Memantau area layanan di wilayah sekitar
- 🔔 Menerima notifikasi real-time

## ✨ Fitur Utama

### 🏠 Halaman Utama
- Dashboard informatif dengan data pengelolaan sampah
- Carousel informasi interaktif dengan animasi slide up
- Tampilan saldo poin dan status level pengguna
- Real-time clock dan sistem greeting berdasarkan waktu

### 🗺️ Tracking
- Pelacakan real-time petugas pengambilan sampah
- Estimasi waktu kedatangan
- Rute pengambilan sampah dengan visualisasi peta
- Fitur full screen untuk tampilan peta yang lebih jelas

### 💰 Sistem Rewards
- Penukaran poin dengan berbagai hadiah menarik
- Peringkat dan level berdasarkan kontribusi pengelolaan sampah
- Riwayat perolehan dan penggunaan poin

### 📊 Wilayah Layanan
- Peta interaktif area layanan
- Filter wilayah berdasarkan jenis layanan
- Informasi detail area cakupan

### 📱 Fitur Tambahan
- Notifikasi sistem dengan suara kustom
- Multi-bahasa (Indonesia & Inggris)
- Fitur buat keluhan dan laporan masalah
- Profil pengguna yang dapat diperbarui

## 🛠️ Teknologi

Gerobaks dibangun dengan teknologi modern:

- **Framework**: [Flutter](https://flutter.dev/)
- **Bahasa**: [Dart](https://dart.dev/)
- **State Management**: [Flutter Bloc](https://bloclibrary.dev/)
- **Mapping**: Flutter Map & Flutter Polyline Points
- **UI Components**: Custom Material Design & Google Fonts
- **Notifikasi**: Flutter Local Notifications
- **Animasi**: Carousel Slider & Custom Animations
- **Formatting**: Intl & Flutter Multi Formatter
- **API Integration**: HTTP & Flutter dotenv

## 🏗️ Arsitektur Aplikasi

Gerobaks menggunakan arsitektur yang bersih dan modular:

```
lib/
  ├── blocs/            # BLoC untuk state management
  ├── models/           # Model data
  ├── services/         # Services untuk API, notifikasi, dll
  ├── shared/           # Shared utilities (themes, constants)
  └── ui/
      ├── pages/        # Halaman aplikasi
      └── widgets/      # Reusable widgets
```

## 🚀 Memulai

### Prasyarat

- Flutter SDK 3.8.1 atau lebih tinggi
- Dart SDK 3.8 atau lebih tinggi
- Android Studio / VS Code
- Emulator atau perangkat fisik

### Instalasi

1. Clone repository
   ```bash
   git clone https://github.com/aji-aali/Gerobaks.git
   ```

2. Masuk ke direktori proyek
   ```bash
   cd Gerobaks
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Konfigurasi file .env (jika diperlukan)
   ```
   ORS_API_KEY=your_api_key_here
   ```

5. Jalankan aplikasi
   ```bash
   flutter run
   ```

## 📊 Program Green City

Program Green City adalah inisiatif Gerobaks bekerja sama dengan pemerintah kota untuk menciptakan lingkungan perkotaan yang lebih bersih dan hijau. Melalui program ini, kami mengajak seluruh masyarakat untuk berpartisipasi aktif dalam pemilahan sampah dan mendukung upaya daur ulang.

- 🎯 **Target**: Pengurangan sampah perkotaan hingga 30% dalam 2 tahun
- 🤝 **Cara Berpartisipasi**: Pilah sampah, gunakan layanan Gerobaks, ajak teman dan keluarga
- 🏆 **Rewards**: Sertifikat digital, diskon layanan, dan hadiah eksklusif

## 🔮 Fitur Mendatang

- [ ] Integrasi pembayaran digital
- [ ] Sistem komunitas dan forum diskusi
- [ ] Analisis dampak lingkungan personal
- [ ] Gamifikasi lebih lanjut
- [ ] Ekspansi ke kota-kota baru (Samarinda pada September 2025)

## 📝 Misi Kami

- Mengurangi beban tempat pembuangan akhir (TPA)
- Meningkatkan kesadaran masyarakat dalam memilah sampah
- Mendukung gerakan daur ulang dan pengelolaan sampah berkelanjutan

## 📄 Lisensi

Proyek ini dilisensikan di bawah lisensi MIT - lihat file LICENSE untuk detail lebih lanjut.

## 👥 Kontributor

- [aji-aali](https://github.com/aji-aali) - Developer Lead

---

<div align="center">

### Mari ubah sampah menjadi berkah. Bersama Gerobaks, wujudkan lingkungan yang lestari!

</div>
