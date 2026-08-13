// lib/pages/splash_screen.dart
import 'package:flutter/material.dart';
import '../ads/ad_manager.dart';
import '../ads/splash_ad_widget.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 确保在首帧绘制后再加载广告，避免不必要的重建
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAdAndNavigate();
    });
  }

  Future<void> _loadAdAndNavigate() async {
    try {
      // 加载开屏广告（占位）
      await AdManager.loadSplashAd();
    } catch (e) {
      // 打印错误，但不阻塞跳转
      print('开屏广告加载失败: $e');
    } finally {
      // 无论广告加载成功或失败，2秒后都跳转
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashAdWidget(),
    );
  }
}