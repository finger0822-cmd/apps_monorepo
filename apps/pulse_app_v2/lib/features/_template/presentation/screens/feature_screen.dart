// 画面用。Provider を watch し UseCase のみ呼ぶ。data を import しない。
// コピー後: feature → <feature_name> に置換し、実装を追加する。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 当 feature のメイン画面。ref.watch で Provider から UseCase を取得して利用する。
class FeatureScreen extends ConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(child: Text('FeatureScreen placeholder')),
    );
  }
}
