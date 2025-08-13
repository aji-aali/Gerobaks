import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';

class InformasiDetailModal extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String content;
  final List<Map<String, String>> additionalInfo;

  const InformasiDetailModal({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.content,
    required this.additionalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          
          // Header image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Content area with padding
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: semiBold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Description/subtitle
                Text(
                  description,
                  style: greyTextStyle.copyWith(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Main content
                Text(
                  content,
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Additional Information Section
                if (additionalInfo.isNotEmpty) ...[
                  Text(
                    'Informasi Tambahan',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // List of additional info items
                  ...additionalInfo.map((info) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info['label'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: medium,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          info['value'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
                
                // Bottom spacing
                const SizedBox(height: 20),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: greenColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
