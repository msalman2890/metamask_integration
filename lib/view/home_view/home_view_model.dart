import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metamask_wallet/core/utils/logger.dart';
import 'package:metamask_wallet/core/utils/periodic_task_manager.dart';
import 'package:metamask_wallet/model/periodic_task.dart';
import 'package:metamask_wallet/view/landing_view/landing_view_model.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:web3dart/web3dart.dart';

import '../../service/metamask_service.dart';

final homeViewProvider = Provider((ref) => HomeViewModel(ref));

final accountProvider =
    FutureProvider((ref) => ref.watch(homeViewProvider).getAccount());

final balanceProvider =
    FutureProvider.family<String, String>((ref, account) async {
  return ref.watch(homeViewProvider).getBalance(account);
});

class HomeViewModel {
  HomeViewModel(this.ref);

  final Ref ref;

  Future<String> getAccount() async {
    try {
      SessionData? session = ref.read(landingViewProvider).session;

      if (session != null) {
        String account = ref.read(metamaskServiceProvider).getAccount(session);

        return account;
      }
    } catch (e) {
      Logger.log(e.toString());
    }

    return "No Account Found!";
  }

  Future<String> getBalance(String account) async {
    try {
      var client = ref.read(landingViewProvider).web3Client;

      if (client != null) {
        EtherAmount balance =
            await ref.read(metamaskServiceProvider).getBalance(client, account);

        return balance.getValueInUnit(EtherUnit.ether).toString();
      }
    } catch (e) {
      Logger.log(e.toString());
    }

    return "-";
  }
}

final accountBalanceNotifierProvider =
    StateNotifierProvider.family<AccountBalanceNotifier, String, String>(
        (ref, account) {
  return AccountBalanceNotifier(ref, account);
});

class AccountBalanceNotifier extends StateNotifier<String> {
  AccountBalanceNotifier(this.ref, this.account) : super("0") {
    startPeriodicTask();
  }

  final Ref ref;
  final String account;

  Future<String> getBalance() async {
    try {
      var client = ref.read(landingViewProvider).web3Client;

      if (client != null) {
        EtherAmount balance =
            await ref.read(metamaskServiceProvider).getBalance(client, account);

        return balance.getValueInUnit(EtherUnit.ether).toString();
      }
    } catch (e) {
      Logger.log(e.toString());
    }

    return "-";
  }

  Future<void> startPeriodicTask() async {
    try {
      var client = ref.read(landingViewProvider).web3Client;

      if (client != null) {
        PeriodicTaskManager periodicTaskManager = PeriodicTaskManager();

        PeriodicTask periodicTask = PeriodicTask(
            callback: () async {
              String balance = await getBalance();
              state = balance;
            },
            interval: const Duration(seconds: 5),
            name: 'Account Balance');

        periodicTaskManager.addTask(periodicTask);
      }
    } catch (e) {
      Logger.log(e.toString());
    }
  }
}
