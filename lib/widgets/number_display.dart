import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_colors.dart';

class NumberDisplay extends StatelessWidget {
  final String number;

  const NumberDisplay({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        number.isEmpty ? '+92 ' : number,
        style: TextStyle(
          fontSize: 42.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: number.isEmpty ? AppColors.grey.withValues(alpha: 0.5) : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
