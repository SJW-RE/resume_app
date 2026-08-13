import 'package:flutter/material.dart';

/// 广告占位组件（待接入真实广告 SDK）
class AdBannerWidget extends StatelessWidget {
  final String? adUnitId; // 广告单元 ID，暂时可选

  const AdBannerWidget({super.key, this.adUnitId});

  @override
  Widget build(BuildContext context) {
    // 在开发阶段显示模拟广告
    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ad_units, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              '广告位 (待接入)',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}