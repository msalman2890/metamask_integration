import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metamask_wallet/view/transaction_view/transaction_view_model.dart';
import 'package:metamask_wallet/view/transaction_view/widget/send_button.dart';

import '../../widget/custom_textfield.dart';

class TransactionView extends ConsumerWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionProvider = ref.watch(transactionViewProvider);
    return Padding(
      padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
          bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: transactionProvider.transactionFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Transaction Details",
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
              hint: "Address",
              validator: (value) {
                return value!.length < 40 ? "Invalid Account Address" : null;
              },
              controller: transactionProvider.address,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hint: "ETH Amount",
              keyboardType: TextInputType.number,
              controller: transactionProvider.amount,
            ),
            const SizedBox(
              height: 30,
            ),
            const SendButton(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
