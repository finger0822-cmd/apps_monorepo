import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../core/services/subscription_service.dart';

/// サブスクリプション購入用のペイウォール画面。
/// モーダル（showModalBottomSheet）で表示する想定。
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  /// オファー取得中は true
  bool _loading = true;

  /// 取得したオファー（null の場合は未取得または取得失敗）
  Offering? _offering;

  /// 取得失敗時のメッセージ
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  /// RevenueCat からオファー一覧を取得する
  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) {
        setState(() {
          _offering = offerings.current;
          _loading = false;
          _errorMessage = offerings.current == null ? 'オファーを読み込めませんでした' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _offering = null;
          _errorMessage = 'オファーを読み込めませんでした';
        });
      }
    }
  }

  /// 購入・復元エラーがユーザーキャンセルかどうか
  bool _isCancelledError(PurchasesError error) {
    return error.code == PurchasesErrorCode.purchaseCancelledError ||
        error.readableErrorCode == 'purchases_cancelled';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プレミアム'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null && _offering == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey.shade600),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }
    // PaywallView を表示（offering が null でもパッケージ仕様に従って表示を試みる）
    return PaywallView(
      offering: _offering,
      displayCloseButton: false,
      onPurchaseCompleted: (customerInfo, storeTransaction) {
        ref.read(subscriptionProvider.notifier).reload();
      },
      onRestoreCompleted: (customerInfo) {
        ref.read(subscriptionProvider.notifier).reload();
      },
      onPurchaseError: (error) {
        if (_isCancelledError(error)) return;
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('エラーが発生しました')));
        }
      },
      onRestoreError: (error) {
        if (_isCancelledError(error)) return;
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('エラーが発生しました')));
        }
      },
      onDismiss: () => Navigator.of(context).pop(context),
    );
  }
}
