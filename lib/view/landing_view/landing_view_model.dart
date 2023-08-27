import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metamask_wallet/core/utils/logger.dart';
import 'package:metamask_wallet/service/metamask_service.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_models.dart';
import 'package:walletconnect_flutter_v2/apis/web3app/web3app.dart';
import 'package:web3dart/web3dart.dart';

final landingViewProvider = Provider((ref) => LandingView(ref));

final initializionsProvider = FutureProvider<bool>((ref) async {
  return ref.watch(landingViewProvider).initializeWeb3Services();
});

final connectionProvider = FutureProvider<SessionData?>((ref) async {
  return ref.watch(landingViewProvider).connectToMetaMask();
});

class LandingView {
  LandingView(this.ref);

  final Ref ref;
  Web3App? web3App;
  Web3Client? web3Client;

  SessionData? session;

  Future<bool> initializeWeb3Services() async {
    try {
      var services = await ref.read(metamaskServiceProvider).initialize();

      web3App = services?.$1;
      web3Client = services?.$2;

      web3App?.signEngine.onSessionEvent.subscribe((args) {
        Logger.log("Topic: ${args?.topic}", name: "Session Event");
        Logger.log("Id: ${args?.id}", name: "Session Event");
        Logger.log("Name: ${args?.name}", name: "Session Event");
        Logger.log("Data: ${args?.data}", name: "Session Event");
      });

      web3App!.registerEventHandler(
          chainId: "eip155:1",
          event: "chainChanged",
          handler: (msg, data) {
            Logger.log("chainChanged");
            Logger.log("Message: $msg", name: "Chain Changed");
            Logger.log("Data: $data", name: "Chain Changed");
          });
      web3App!.registerEventHandler(
          chainId: "eip155:1",
          event: "accountsChanged",
          handler: (msg, data) {
            Logger.log("Message: $msg", name: "Accounts Changed");
            Logger.log("Data: $data", name: "Accounts Changed");
          });
      web3App!.registerEventHandler(
          chainId: "eip155:1",
          event: "eth_sendTransaction",
          handler: (msg, data) {
            Logger.log("Message: $msg", name: "Eth Send Transaction");
            Logger.log("Data: $data", name: "Eth Send Transaction");
          });

      web3Client?.pendingTransactions().listen((event) {
        Logger.log("Event: $event", name: "Pending Transaction");
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<SessionData?> connectToMetaMask() async {
    ConnectResponse response =
        await ref.read(metamaskServiceProvider).connectWallet(web3App!);
    session = await ref
        .read(metamaskServiceProvider)
        .launchMetamaskToAuthenticateAndConnect(response);

    return session;
  }
}
