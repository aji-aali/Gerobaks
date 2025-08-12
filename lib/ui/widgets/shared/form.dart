import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String title;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomFormField({
    super.key,
    required this.title,
    this.obscureText = false,
    this.controller,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool isObscured = false;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: blackTextStyle.copyWith(fontWeight: medium)),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            contentPadding: const EdgeInsets.all(14),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      color: greyColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class CustomFormJadwal extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final String? hintText;
  final Widget? suffixIcon;
  final VoidCallback? onTap;

  const CustomFormJadwal({
    super.key,
    required this.title,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.hintText,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: blackTextStyle.copyWith(fontSize: 14, fontWeight: medium),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          style: blackTextStyle.copyWith(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: greyTextStyle,
            filled: true,
            fillColor: lightBackgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
