import 'package:flutter/material.dart';

import '../../transaction_view/transaction_view.dart';

class SendCoinButton extends StatelessWidget {
  const SendCoinButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        icon: const Icon(Icons.currency_bitcoin),
        onPressed: () {
          _openTransactionBottomSheet(context);
        },
        label: const Text("Send Coin"));
  }

  void _openTransactionBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff18171b),
      builder: (context) {
        return const TransactionView();
      },
    );
  }
}
