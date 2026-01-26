import 'package:flutter/material.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';

class QrFormField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final String? errorText;
  final String fieldName;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isRequired;
  final Function(String, String) onChanged;

  const QrFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.fieldName,
    required this.onChanged,
    this.value,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.white,
              fontSize: context.sp(16),
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ]
                : null,
          ),
        ),

        SizedBox(height: context.hp(1)),

        // Text field
        TextFormField(
          initialValue: value,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: AppColors.white, fontSize: context.sp(16)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.white.withOpacity(0.6),
              fontSize: context.sp(16),
            ),
            filled: true,
            fillColor: AppColors.secondary.withOpacity(0.3),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.wp(4),
              vertical: context.hp(1.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            errorText: errorText,
            errorStyle: TextStyle(color: Colors.red, fontSize: context.sp(12)),
          ),
          onChanged: (value) => onChanged(fieldName, value),
        ),

        SizedBox(height: context.hp(2)),
      ],
    );
  }
}
