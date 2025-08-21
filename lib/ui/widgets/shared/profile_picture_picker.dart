import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';

class ProfilePicturePicker extends StatelessWidget {
  final String currentPicture;
  final Function(String) onPictureSelected;

  const ProfilePicturePicker({
    Key? key,
    required this.currentPicture,
    required this.onPictureSelected,
  }) : super(key: key);

  void _showPictureOptions(BuildContext context) {
    final List<String> availablePictures = [
      'assets/img_friend1.png',
      'assets/img_friend2.png',
      'assets/img_friend3.png',
      'assets/img_profile.png',
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Foto Profil',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availablePictures.map((picture) {
                  return GestureDetector(
                    onTap: () {
                      onPictureSelected(picture);
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(picture),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage(currentPicture),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () => _showPictureOptions(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: greenColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: whiteColor,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
