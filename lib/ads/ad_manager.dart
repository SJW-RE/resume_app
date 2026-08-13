// lib/ads/ad_manager.dart
import 'package:flutter/foundation.dart';

class AdManager {
  // 是否启用真实广告（生产环境启用，开发环境禁用）
  static bool get isAdEnabled => !kDebugMode;

  // 开发阶段模拟广告加载
  static Future<void> loadSplashAd() async {
    if (isAdEnabled) {
      // TODO: 加载真实的 AppOpenAd
      print('🔄 加载开屏广告');
    } else {
      print('ℹ️ 开发模式，跳过广告加载');
    }
  }

  // 开发阶段模拟激励视频
  static Future<void> showRewardedAd(VoidCallback onRewarded) async {
    if (isAdEnabled) {
      // TODO: 展示真实的 RewardedAd
      print('🔄 展示激励视频广告');
      // 模拟加载延迟
      await Future.delayed(const Duration(seconds: 2));
      onRewarded();
    } else {
      print('ℹ️ 开发模式，模拟奖励');
      // 开发模式下直接给奖励
      onRewarded();
    }
  }
}