# Custom Dialog Gerobaks

Custom dialog untuk aplikasi Gerobaks dengan tema warna putih-hijau sesuai brand. Komponen ini mengganti dialog bawaan Flutter dengan desain yang lebih sesuai dengan tema aplikasi.

## Fitur

- Desain yang konsisten dengan tema aplikasi (putih-hijau)
- Animasi yang halus dan responsif
- Support untuk berbagai jenis dialog (info, success, error, konfirmasi, loading)
- Support untuk custom content
- Styling yang lebih modern dan eye-catching

## Cara Penggunaan

### 1. Dialog Helper (Cara Paling Mudah)

DialogHelper adalah utility class yang menyediakan berbagai method untuk menampilkan dialog secara cepat:

```dart
// Info Dialog
DialogHelper.showInfoDialog(
  context: context,
  title: 'Informasi',
  message: 'Ini adalah pesan informasi untuk pengguna.',
  buttonText: 'OK',
  icon: Icons.info_outline, // Opsional
);

// Success Dialog
DialogHelper.showSuccessDialog(
  context: context,
  title: 'Berhasil',
  message: 'Operasi telah berhasil dilakukan.',
  buttonText: 'Lanjutkan',
);

// Error Dialog
DialogHelper.showErrorDialog(
  context: context,
  title: 'Error',
  message: 'Terjadi kesalahan saat memproses permintaan.',
  buttonText: 'Coba Lagi',
);

// Confirmation Dialog (returns Future<bool>)
bool confirmed = await DialogHelper.showConfirmDialog(
  context: context,
  title: 'Konfirmasi',
  message: 'Apakah Anda yakin ingin melanjutkan?',
  confirmText: 'Ya',
  cancelText: 'Tidak',
  icon: Icons.help_outline, // Opsional
);

if (confirmed) {
  // Lakukan sesuatu jika user mengkonfirmasi
}

// Delete Confirmation Dialog
bool willDelete = await DialogHelper.showDeleteConfirmDialog(
  context: context,
  title: 'Hapus Item',
  message: 'Item yang dihapus tidak dapat dikembalikan.',
);

// Loading Dialog
DialogHelper.showLoadingDialog(
  context: context,
  message: 'Memproses...',
);

// Jangan lupa untuk menutup loading dialog
DialogHelper.closeDialog(context);
```

### 2. Custom Dialog (Untuk Kasus Lebih Kompleks)

Untuk kasus yang memerlukan lebih banyak kustomisasi, Anda dapat menggunakan `CustomDialog` langsung:

```dart
showDialog(
  context: context,
  builder: (context) => CustomDialog(
    title: 'Judul Dialog',
    content: 'Konten dialog yang ingin ditampilkan...',
    positiveButtonText: 'Setuju',
    negativeButtonText: 'Batal',
    onPositivePressed: () {
      // Handling saat tombol positif ditekan
      Navigator.pop(context);
    },
    onNegativePressed: () {
      // Handling saat tombol negatif ditekan
      Navigator.pop(context);
    },
    icon: Icons.info_outline, // Opsional: ikon untuk ditampilkan
    isLoading: false, // Opsional: status loading pada tombol positif
  ),
);
```

### 3. Dialog dengan Custom Content

Untuk konten yang lebih kompleks, Anda dapat menggunakan parameter `customContent`:

```dart
showDialog(
  context: context,
  builder: (context) => CustomDialog(
    title: 'Pilih Tanggal',
    customContent: SizedBox(
      height: 200,
      child: CalendarDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2030),
        onDateChanged: (date) {
          // Handle date selection
        },
      ),
    ),
    positiveButtonText: 'Pilih',
    negativeButtonText: 'Batal',
    onPositivePressed: () {
      Navigator.pop(context);
    },
    onNegativePressed: () {
      Navigator.pop(context);
    },
  ),
);
```

### 4. Dialog dengan Loading State

Dialog dapat menampilkan loading indicator pada tombol positif:

```dart
bool isLoading = false;

showDialog(
  context: context,
  builder: (BuildContext dialogContext) {
    return StatefulBuilder(
      builder: (context, setState) {
        return CustomDialog(
          title: 'Simpan Data',
          content: 'Simpan perubahan yang telah dilakukan?',
          positiveButtonText: 'Simpan',
          negativeButtonText: 'Batal',
          isLoading: isLoading,
          onPositivePressed: () async {
            // Aktifkan loading state
            setState(() {
              isLoading = true;
            });
            
            // Lakukan operasi async
            await Future.delayed(const Duration(seconds: 2));
            
            // Tutup dialog
            Navigator.pop(dialogContext);
          },
          onNegativePressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  },
);
```

## Contoh Implementasi di Aplikasi

Berikut adalah contoh penggantian dialog bawaan dengan custom dialog:

```dart
// Sebelum:
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    title: Text('Versi Alpha'),
    content: Text('Fitur masih dalam pengembangan.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
      ),
    ],
  ),
);

// Sesudah:
DialogHelper.showInfoDialog(
  context: context,
  title: 'Versi Alpha',
  message: 'Fitur masih dalam pengembangan.',
  buttonText: 'OK',
);
```

## Referensi

Untuk melihat contoh lebih lengkap, lihat file `dialog_example_page.dart` yang berisi semua variasi dialog yang tersedia.
