import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metamask_wallet/core/app_life_cycle.dart';

import 'landing_view_model.dart';
import 'widget/metamask_button.dart';

class LandingView extends ConsumerStatefulWidget {
  const LandingView({super.key});

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends ConsumerState<LandingView> {
  @override
  void initState() {
    AppLifeCycle().initializeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(initializionsProvider);
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
          body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Expanded(
              child: Image.asset(
            "assets/images/cards.png",
            fit: BoxFit.cover,
            width: double.infinity,
          )),
          const SizedBox(
            height: 50,
          ),
          Text(
            "MetaMask Integration",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text("Instant access to your MetaMask wallet",
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(
            height: 50,
          ),
          MetaMaskButton(data: data),
          const SizedBox(
            height: 30,
          ),
        ],
      ));
    });
  }
}
