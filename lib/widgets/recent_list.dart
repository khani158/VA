import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/recent_number.dart';
import '../core/constants/app_colors.dart';

class RecentList extends StatelessWidget {
  final List<RecentNumber> recentNumbers;
  final Function(String) onSelect;
  final Function(String) onDelete;
  final Function(String) onWhatsApp;

  const RecentList({
    super.key,
    required this.recentNumbers,
    required this.onSelect,
    required this.onDelete,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    if (recentNumbers.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(
            'No recent numbers',
            style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentNumbers.length,
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
      itemBuilder: (context, index) {
        final item = recentNumbers[index];
        return ListTile(
          onTap: () => onSelect(item.number),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          title: Text(
            item.number,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
          ),
          subtitle: Text(
            _formatTime(item.timestamp),
            style: TextStyle(color: AppColors.grey, fontSize: 12.sp),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.whatsapp, color: AppColors.primary),
                onPressed: () => onWhatsApp(item.number),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => onDelete(item.number),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}';
  }
}
