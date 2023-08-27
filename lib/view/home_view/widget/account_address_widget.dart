import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metamask_wallet/core/extensions/string_extension.dart';

import '../home_view_model.dart';

class AccountAddress extends ConsumerWidget {
  const AccountAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    return account.when(
        data: (data) {
          return Text(
            data.trimFromMiddle(15),
            style: Theme.of(context).textTheme.labelSmall,
          );
        },
        error: (error, trace) => const SizedBox(),
        loading: () => const SizedBox());
  }
}
