import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialPad extends StatelessWidget {
  final Function(String) onTapped;
  final VoidCallback onBackspace;
  final VoidCallback onLongPressBackspace;

  const DialPad({
    super.key,
    required this.onTapped,
    required this.onBackspace,
    required this.onLongPressBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        SizedBox(height: 15.h),
        _buildRow(['4', '5', '6']),
        SizedBox(height: 15.h),
        _buildRow(['7', '8', '9']),
        SizedBox(height: 15.h),
        _buildRow(['+', '0', 'backspace']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildButton(key)).toList(),
    );
  }

  Widget _buildButton(String key) {
    bool isBackspace = key == 'backspace';
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isBackspace ? onBackspace : () => onTapped(key),
        onLongPress: isBackspace ? onLongPressBackspace : null,
        borderRadius: BorderRadius.circular(50.r),
        child: Container(
          width: 65.w > 65 ? 65 : 65.w,
          height: 65.w > 65 ? 65 : 65.w,
          constraints: const BoxConstraints(maxWidth: 70, maxHeight: 70),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isBackspace ? Colors.transparent : Colors.grey.withAlpha(25),
          ),
          child: Center(
            child: isBackspace
                ? Icon(Icons.backspace_outlined, size: 24.sp, color: Colors.redAccent)
                : Text(
                    key,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
