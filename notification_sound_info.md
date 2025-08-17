# Notifikasi Sound Files

Beberapa perangkat Android mungkin memiliki dukungan yang terbatas untuk file WAV. File MP3 biasanya merupakan pilihan yang lebih kompatibel.

Untuk memastikan notifikasi suara berfungsi, sebaiknya gunakan file MP3 dengan spesifikasi:
- Bitrate: 128kbps
- Sample rate: 44.1kHz
- Mono atau stereo
- Durasi pendek (1-3 detik)

Lokasi file suara:
- Android: android/app/src/main/res/raw/notification_sound.mp3
- iOS: ios/Runner/Resources/notification_sound.mp3

Cara konversi file WAV ke MP3:
1. Gunakan aplikasi konversi audio seperti Audacity, Adobe Audition, atau online converter
2. Pastikan file sudah dalam format yang benar dan penamaan yang konsisten
