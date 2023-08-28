import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metamask_wallet/core/utils/constants.dart';
import 'package:metamask_wallet/core/utils/custom_loading.dart';
import 'package:metamask_wallet/core/utils/custom_toast.dart';
import 'package:metamask_wallet/core/utils/utils.dart';

import '../../home_view/home_view.dart';
import '../landing_view_model.dart';

class MetaMaskButton extends ConsumerWidget {
  const MetaMaskButton({super.key, required this.data});

  final AsyncValue<bool> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return data.when(
        data: (data) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  connectWallet(ref);
                },
                child: const Text("Connect to MetaMask")),
          );
        },
        error: (e, trace) => const SizedBox(),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }

  Future<void> connectWallet(WidgetRef ref) async {
    Loading.show();

    if (!await Utils.isAppInstalled(metamaskAppUriScheme)) {
      Loading.hide();
      CustomToast.show(launchError, true);
      return;
    }

    ref.listenManual(connectionProvider, (prev, next) {
      if (next.hasValue && next.value != null) {
        Loading.hide();
        Navigator.push(ref.context,
            MaterialPageRoute(builder: (context) => const HomeView()));
      } else {
        Loading.hide();
      }
    }, onError: (error, trace) {
      Loading.hide();
      CustomToast.show("Something went wrong", true);
    });
  }
}
