import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metamask_wallet/view/transaction_view/widget/transaction_detail_dialog.dart';
import 'package:web3dart/web3dart.dart';

import '../transaction_view_model.dart';

class SendButton extends ConsumerWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TransactionViewModel transactionProvider =
        ref.watch(transactionViewProvider);
    return ElevatedButton(
        onPressed: () {
          onSend(transactionProvider, context);
        },
        child: const Text("Send"));
  }

  Future<void> onSend(
      TransactionViewModel transactionProvider, BuildContext context) async {
    // proceed with the transaction
    TransactionInformation? details =
        await transactionProvider.sendAndListenTransactions();

    //close the transaction bottomsheet
    Navigator.pop(context);

    //display the transaction details dialog if data is not null
    if (details != null) {
      _showTransactionDetailDialog(context, details);
    }
  }

  void _showTransactionDetailDialog(
      BuildContext context, TransactionInformation details) {
    showAdaptiveDialog(
        context: context,
        builder: (context) {
          return TransactionDetailDialog(details: details);
        });
  }
}
