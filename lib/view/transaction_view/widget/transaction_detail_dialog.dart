import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../../widget/custom_rich_text.dart';

class TransactionDetailDialog extends StatelessWidget {
  const TransactionDetailDialog({super.key, required this.details});
  final TransactionInformation details;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Transaction Details"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomRichText(text1: "Transaction Hash: ", text2: details.hash),
          CustomRichText(
              text1: "Block Number: ", text2: "${details.blockNumber}"),
          CustomRichText(text1: "From: ", text2: "${details.from}"),
          CustomRichText(text1: "To: ", text2: "${details.to}"),
          CustomRichText(
              text1: "Amount: ",
              text2: "${details.value.getValueInUnit(EtherUnit.ether)} ETH"),
          CustomRichText(text1: "Gas: ", text2: "${details.gas}"),
          CustomRichText(text1: "Gas Price ", text2: "${details.gasPrice}"),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"))
      ],
    );
  }
}
