import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_view_model.dart';

class AccountBalance extends ConsumerWidget {
  const AccountBalance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    if (account.hasValue) {
      final balance =
          ref.watch(accountBalanceNotifierProvider(account.value ?? ""));
      return Text(
        "$balance ETH",
        style: Theme.of(context).textTheme.headlineLarge,
      );
      // return ref.watch(accountBalanceProvider(account.value!)).when(
      //     data: (data) {
      //       return Text(
      //         "$data ETH",
      //         style: Theme.of(context).textTheme.headlineLarge,
      //       );
      //     },
      //     error: (error, trace) => const SizedBox(),
      //     loading: () => const SizedBox());
    }

    return const SizedBox.shrink();
  }
}
