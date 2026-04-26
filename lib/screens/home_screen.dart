import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants/app_colors.dart';
import '../core/storage/local_storage.dart';
import '../core/utils/whatsapp_launcher.dart';
import '../history_screen.dart';
import '../widgets/dial_pad.dart';
import '../widgets/number_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentNumber = '';

  void _handleDial(String key) {
    if (_currentNumber.length < 15) {
      setState(() {
        _currentNumber += key;
      });
    }
  }

  void _handleBackspace() {
    if (_currentNumber.isNotEmpty) {
      setState(() {
        _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
      });
    }
  }

  void _handleLongPressBackspace() {
    setState(() {
      _currentNumber = '';
    });
  }

  Future<void> _openWhatsApp() async {
    if (_currentNumber.isEmpty || _currentNumber == '+') return;

    try {
      await WhatsAppLauncher.launchWhatsApp(_currentNumber);
      await LocalStorage.saveNumber(_currentNumber);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _navigateToHistory() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
    if (result != null) {
      setState(() {
        _currentNumber = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickWA Dialer', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _navigateToHistory,
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500, minHeight: 600),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberDisplay(number: _currentNumber),
                  SizedBox(height: 30.h),
                  DialPad(
                    onTapped: _handleDial,
                    onBackspace: _handleBackspace,
                    onLongPressBackspace: _handleLongPressBackspace,
                  ),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ElevatedButton.icon(
                      onPressed: _openWhatsApp,
                      icon: const FaIcon(FontAwesomeIcons.whatsapp),
                      label: const Text('Open WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 55.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                        textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
