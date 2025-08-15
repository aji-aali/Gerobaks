import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/form.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:flutter/material.dart';

class SignUpBatch4Page extends StatefulWidget {
  const SignUpBatch4Page({super.key});

  @override
  State<SignUpBatch4Page> createState() => _SignUpBatch4PageState();
}

class _SignUpBatch4PageState extends State<SignUpBatch4Page> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedLocation;
  double? _selectedLat;
  double? _selectedLng;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _openMapPicker() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerPage(
          onLocationSelected: (address, lat, lng) {
            setState(() {
              _selectedLocation = address;
              _selectedLat = lat;
              _selectedLng = lng;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Logo Section
                    const SizedBox(height: 60),

                    // Logo GEROBAKS
                    Container(
                      width: 250,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Image.asset(
                        'assets/img_gerobakss.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: greenColor,
                                size: 32,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'GEROBAKS',
                                style: greeTextStyle.copyWith(
                                  fontSize: 28,
                                  fontWeight: bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    Text(
                      'Alamat & Lokasi',
                      style: blackTextStyle.copyWith(
                        fontSize: 24,
                        fontWeight: bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Langkah 4 dari 5 - Informasi Alamat',
                      style: greyTextStyle.copyWith(fontSize: 14),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Masukkan alamat dan tandai lokasi tempat tinggal Anda',
                      textAlign: TextAlign.center,
                      style: greyTextStyle.copyWith(fontSize: 14),
                    ),

                    const SizedBox(height: 30),

                    // Progress Indicator
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: greyColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Address Field
                    CustomFormField(
                      title: 'Alamat Lengkap',
                      keyboardType: TextInputType.streetAddress,
                      controller: _addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat tidak boleh kosong';
                        }
                        if (value.length < 10) {
                          return 'Alamat terlalu pendek, minimal 10 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Location Picker
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedLocation != null
                              ? greenColor
                              : greyColor.withOpacity(0.5),
                          width: _selectedLocation != null ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: _openMapPicker,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: _selectedLocation != null
                                        ? greenColor
                                        : greyColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Pilih Lokasi di Peta',
                                    style:
                                        (_selectedLocation != null
                                                ? greeTextStyle
                                                : greyTextStyle)
                                            .copyWith(
                                              fontSize: 14,
                                              fontWeight: semiBold,
                                            ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: greyColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                              if (_selectedLocation != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: greenColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Lokasi Terpilih:',
                                        style: greeTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: semiBold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedLocation!,
                                        style: blackTextStyle.copyWith(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Lat: ${_selectedLat?.toStringAsFixed(6)}, Lng: ${_selectedLng?.toStringAsFixed(6)}',
                                        style: greyTextStyle.copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Tap untuk membuka peta dan pilih lokasi tempat tinggal Anda',
                                  style: greyTextStyle.copyWith(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (_selectedLocation == null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '* Lokasi pada peta wajib dipilih',
                        style: TextStyle(color: redcolor, fontSize: 12),
                      ),
                    ],

                    const Spacer(),

                    const SizedBox(height: 30),

                    // Next Button
                    CustomFilledButton(
                      title: 'Lanjutkan',
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _selectedLocation != null) {
                          // Pass all data to next page
                          Navigator.pushNamed(
                            context,
                            '/sign-up-batch-5',
                            arguments: {
                              ...?arguments,
                              'address': _addressController.text,
                              'selectedLocation': _selectedLocation,
                              'latitude': _selectedLat,
                              'longitude': _selectedLng,
                            },
                          );
                        } else if (_selectedLocation == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Silakan pilih lokasi pada peta',
                                style: whiteTextStyle.copyWith(fontSize: 14),
                              ),
                              backgroundColor: redcolor,
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Sign In Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: greyTextStyle.copyWith(fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign-in');
                          },
                          child: Text(
                            'Sign In',
                            style: greeTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Map Picker Page
class MapPickerPage extends StatefulWidget {
  final Function(String address, double lat, double lng) onLocationSelected;

  const MapPickerPage({super.key, required this.onLocationSelected});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final _searchController = TextEditingController();
  String _selectedAddress = '';
  double _selectedLat = -7.2575; // Default Surabaya coordinates
  double _selectedLng = 112.7521;

  // Dummy search results
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _searchResults = [
          {
            'address': 'Jl. Raya Darmo No. 123, Surabaya, Jawa Timur',
            'lat': -7.2654,
            'lng': 112.7359,
          },
          {
            'address': 'Jl. Tunjungan Plaza, Surabaya, Jawa Timur',
            'lat': -7.2639,
            'lng': 112.7380,
          },
          {
            'address': 'Universitas Airlangga, Surabaya, Jawa Timur',
            'lat': -7.2709,
            'lng': 112.7801,
          },
        ];
        _isSearching = false;
      });
    });
  }

  void _selectLocation(String address, double lat, double lng) {
    setState(() {
      _selectedAddress = address;
      _selectedLat = lat;
      _selectedLng = lng;
      _searchResults = [];
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: blackColor),
        ),
        title: Text(
          'Pilih Lokasi',
          style: blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        actions: [
          if (_selectedAddress.isNotEmpty)
            TextButton(
              onPressed: () {
                widget.onLocationSelected(
                  _selectedAddress,
                  _selectedLat,
                  _selectedLng,
                );
                Navigator.pop(context);
              },
              child: Text(
                'Pilih',
                style: greeTextStyle.copyWith(fontWeight: semiBold),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari alamat...',
                hintStyle: greyTextStyle.copyWith(fontSize: 14),
                prefixIcon: Icon(Icons.search, color: greyColor),
                suffixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: greyColor.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: greenColor, width: 2),
                ),
              ),
              onChanged: _performSearch,
            ),
          ),

          // Search Results
          if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return ListTile(
                    leading: Icon(Icons.location_on, color: greyColor),
                    title: Text(
                      result['address'],
                      style: blackTextStyle.copyWith(fontSize: 14),
                    ),
                    onTap: () {
                      _selectLocation(
                        result['address'],
                        result['lat'],
                        result['lng'],
                      );
                    },
                  );
                },
              ),
            )
          else
            // Map Placeholder
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: greyColor.withOpacity(0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 64,
                          color: greyColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Peta akan ditampilkan di sini',
                          style: greyTextStyle.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap untuk menandai lokasi Anda',
                          style: greyTextStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // Crosshair/Pin in center
                  Center(child: Icon(Icons.add, size: 32, color: redcolor)),
                  // Current location button
                  Positioned(
                    bottom: 100,
                    right: 16,
                    child: FloatingActionButton.small(
                      backgroundColor: whiteColor,
                      onPressed: () {
                        _selectLocation(
                          'Lokasi Saat Ini, Surabaya, Jawa Timur',
                          -7.2575,
                          112.7521,
                        );
                      },
                      child: Icon(Icons.my_location, color: greenColor),
                    ),
                  ),
                ],
              ),
            ),

          // Selected Location Display
          if (_selectedAddress.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: greenColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: greenColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: greenColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Lokasi Terpilih',
                        style: greeTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedAddress,
                    style: blackTextStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
