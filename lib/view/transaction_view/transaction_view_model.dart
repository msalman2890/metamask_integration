import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metamask_wallet/core/utils/custom_loading.dart';
import 'package:metamask_wallet/core/utils/custom_toast.dart';
import 'package:metamask_wallet/core/utils/logger.dart';
import 'package:metamask_wallet/core/utils/periodic_task_manager.dart';
import 'package:metamask_wallet/model/periodic_task.dart';
import 'package:metamask_wallet/model/transaction.dart';
import 'package:metamask_wallet/view/landing_view/landing_view_model.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3dart/web3dart.dart';

import '../../service/metamask_service.dart';
import '../home_view/home_view_model.dart';

final transactionViewProvider = Provider((ref) => TransactionViewModel(ref));

class TransactionViewModel {
  TransactionViewModel(this.ref);

  final Ref ref;

  TextEditingController address = TextEditingController(),
      amount = TextEditingController();

  final GlobalKey<FormState> transactionFormKey = GlobalKey<FormState>();

  Future<String?> _sendTransaction() async {
    try {
      String? account = ref.read(accountProvider).value;

      if (account == null) return null;

      EthereumTransaction transaction = EthereumTransaction(
          from: account, to: address.text, value: amount.text);

      SessionData? session = ref.read(landingViewProvider).session;
      Web3Client? web3client = ref.read(landingViewProvider).web3Client;

      if (web3client == null || session == null) return null;

      return await ref
          .read(metamaskServiceProvider)
          .sendTransaction(web3client, transaction);
    } catch (e) {
      Logger.log(e.toString(), name: "Catch Error");
      CustomToast.show(e.toString(), true);
    }

    return null;
  }

  Future<TransactionReceipt?> _getTransactionReceipt(String hash) async {
    try {
      Web3Client? web3client = ref.read(landingViewProvider).web3Client;

      if (web3client == null) return null;

      return await ref
          .read(metamaskServiceProvider)
          .getTransactionReceipt(web3client, hash);
    } catch (e) {
      Logger.log(e.toString(), name: "Catch Error");
      CustomToast.show(e.toString(), true);
    }

    return null;
  }

  Future<TransactionInformation?> _getTransactionDetails(String hash) async {
    try {
      Web3Client? web3client = ref.read(landingViewProvider).web3Client;

      if (web3client == null) return null;

      return await ref
          .read(metamaskServiceProvider)
          .getTransactionDetails(web3client, hash);
    } catch (e) {
      Logger.log(e.toString(), name: "Catch Error");
      CustomToast.show(e.toString(), true);
    }

    return null;
  }

  Future<TransactionInformation?> sendAndListenTransactions() async {
    Loading.show();
    bool isValid = transactionFormKey.currentState!.validate();

    if (!isValid) return null;

    final String? hash = await _sendTransaction();

    Loading.hide();
    amount.clear();
    address.clear();

    if (hash != null) {
      Logger.log("Transaction Hash: $hash");
      CustomToast.show(
          "Transaction has been initiated successfully. You will be notified once it is completed",
          false);

      TransactionInformation? details = await _getTransactionDetails(hash);

      PeriodicTaskManager().addTask(PeriodicTask(
          name: "Transaction Receipt # $hash",
          interval: const Duration(seconds: 30),
          callback: () async {
            TransactionReceipt? receipt = await _getTransactionReceipt(hash);
            if (receipt != null && receipt.transactionHash.isNotEmpty) {
              PeriodicTaskManager().removeTask(
                  "Transaction Receipt # ${receipt.transactionHash}");
              CustomToast.show(
                  "Transaction with the hash (${receipt.transactionHash}) completed successfully.",
                  false);
            }
          }));

      return details;
    }
    return null;
  }
}
