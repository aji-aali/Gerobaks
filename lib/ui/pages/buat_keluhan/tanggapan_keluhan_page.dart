import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:bank_sha/ui/widgets/shared/appbar.dart';

class TanggapanKeluhanPage extends StatefulWidget {
  final Map<String, dynamic> keluhanData;

  const TanggapanKeluhanPage({super.key, required this.keluhanData});

  @override
  State<TanggapanKeluhanPage> createState() => _TanggapanKeluhanPageState();
}

class _TanggapanKeluhanPageState extends State<TanggapanKeluhanPage> {
  final _formKey = GlobalKey<FormState>();
  final _tanggapanController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _tanggapanController.dispose();
    super.dispose();
  }

  void _submitTanggapan() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // In a real app, you would save this to your database
      
      // For demo purposes, we'll just go back with a success message
      Navigator.pop(context, {
        ...widget.keluhanData,
        'balasan': _tanggapanController.text,
        'status': 'Selesai',
        'tanggalBalasan': DateTime.now().toString().substring(0, 10),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: greenColor,
          content: const Text('Tanggapan berhasil dikirim!'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      appBar: const CustomAppBar(
        title: 'Kirim Tanggapan',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Keluhan Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan ID dan Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID: ${widget.keluhanData['id']}',
                          style: greyTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(widget.keluhanData['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getStatusColor(widget.keluhanData['status']).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.keluhanData['status'],
                            style: TextStyle(
                              color: _getStatusColor(widget.keluhanData['status']),
                              fontSize: 11,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Judul Keluhan
                    Text(
                      widget.keluhanData['judul'],
                      style: blackTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                    ),

                    const SizedBox(height: 8),

                    // Deskripsi
                    Text(
                      widget.keluhanData['deskripsi'],
                      style: greyTextStyle.copyWith(fontSize: 14, height: 1.5),
                    ),

                    const SizedBox(height: 16),
                    
                    // Divider
                    const Divider(),
                    
                    const SizedBox(height: 16),
                    
                    // Info tambahan
                    Row(
                      children: [
                        _buildInfoItem('Kategori', widget.keluhanData['kategori']),
                        const SizedBox(width: 16),
                        _buildInfoItem('Prioritas', widget.keluhanData['prioritas']),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Tanggapan',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Berikan tanggapan Anda terhadap keluhan ini:',
                style: greyTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // Input Tanggapan
              TextFormField(
                controller: _tanggapanController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggapan tidak boleh kosong';
                  }
                  if (value.length < 10) {
                    return 'Tanggapan minimal 10 karakter';
                  }
                  return null;
                },
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tulis tanggapan Anda di sini...',
                  hintStyle: greyTextStyle.copyWith(fontSize: 14),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: greyColor.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: greyColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: greenColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? CustomFilledButton(
                        title: 'Mengirim...',
                        onPressed: () {},
                        isLoading: true,
                      )
                    : CustomFilledButton(
                        title: 'Kirim Tanggapan',
                        onPressed: _submitTanggapan,
                      ),
              ),
              
              const SizedBox(height: 16),
              
              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: CustomTextButton(
                  title: 'Batal',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: greyTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green.shade600;
      case 'sedang diproses':
        return Colors.orange.shade600;
      case 'menunggu':
        return Colors.blue.shade600;
      default:
        return Colors.grey;
    }
  }
}
