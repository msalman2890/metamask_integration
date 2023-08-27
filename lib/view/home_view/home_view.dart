import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'widget/account_address_widget.dart';
import 'widget/account_balance_widget.dart';
import 'widget/send_coin_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            const AccountBalance(),
            const AccountAddress(),
            Expanded(child: Lottie.asset("assets/animations/crypto.json")),
            const SendCoinButton(),
          ],
        ),
      ),
    );
  }
}
