import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/storage/local_storage.dart';
import '../core/utils/whatsapp_launcher.dart';
import '../models/recent_number.dart';
import '../widgets/recent_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<RecentNumber> _recentNumbers = [];

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    final recents = await LocalStorage.getRecentNumbers();
    setState(() {
      _recentNumbers = recents;
    });
  }

  Future<void> _deleteRecent(String number) async {
    await LocalStorage.deleteNumber(number);
    _loadRecents();
  }

  Future<void> _openWhatsApp(String number) async {
    try {
      await WhatsAppLauncher.launchWhatsApp(number);
      await LocalStorage.saveNumber(number);
      if (!mounted) return;
      _loadRecents();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Numbers'),
        elevation: 0,
      ),
      body: _recentNumbers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64.sp, color: Colors.grey.withValues(alpha: 0.3)),
                  SizedBox(height: 16.h),
                  const Text('History is empty', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadRecents,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: RecentList(
                  recentNumbers: _recentNumbers,
                  onSelect: (n) => Navigator.pop(context, n),
                  onDelete: _deleteRecent,
                  onWhatsApp: _openWhatsApp,
                ),
              ),
            ),
    );
  }
}
