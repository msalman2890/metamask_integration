import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:metamask_wallet/core/utils/custom_toast.dart';
import 'package:metamask_wallet/core/utils/logger.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3dart/web3dart.dart';

import '../core/utils/constants.dart';
import '../model/transaction.dart';

final metamaskServiceProvider = Provider((ref) => MetaMaskServiceImpl());

abstract class MetaMaskService {
  Future<(Web3App, Web3Client)?> initialize();

  Future<ConnectResponse> connectWallet(Web3App web3App);

  Future<SessionData?> launchMetamaskToAuthenticateAndConnect(
      ConnectResponse response);

  String getAccount(SessionData session);

  Future<EtherAmount> getBalance(Web3Client client, String account);

  Future<String> sendTransaction(
      Web3Client client, EthereumTransaction transaction);
}

class MetaMaskServiceImpl extends MetaMaskService {
  // deeplink url to open MetaMask app for authentication
  String deepLinkUrl = 'metamask://wc?uri=';

  int oneEthInWei = 1000000000000000000;

  // method to initialize the web3 client and app to connect with the wallet
  @override
  Future<(Web3App, Web3Client)?> initialize() async {
    try {
      // initialization of walletconnect v2 web3 app with projectID
      Web3App web3App = await Web3App.createInstance(
        projectId: "PROJECT_URL",
        metadata: const PairingMetadata(
          name: web3AppName,
          description: web3AppDescription,
          url: web3AppURL,
          icons: [web3AppIcon],
        ),
      );

      // initialization of web3 client
      Web3Client client = Web3Client(rpcUrl, http.Client());

      return (web3App, client);
    } on WalletConnectError catch (e) {
      Logger.log(e.message, name: "WalletConnectError");
      CustomToast.show(e.message, true);
    } catch (e) {
      Logger.log(e.toString(), name: "Catch Error");
      CustomToast.show(e.toString(), true);
    }
    return null;
  }

  // method to build the app connection to the MetaMask wallet
  @override
  Future<ConnectResponse> connectWallet(Web3App web3App) async {
    ConnectResponse response = await web3App.connect(
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: [
            'eip155:1',
          ],
          methods: [
            'personal_sign',
            'eth_sign',
            'eth_signTransaction',
            'eth_signTypedData',
            'eth_sendTransaction',
          ],
          events: [
            'chainChanged',
            'accountsChanged',
          ],
        ),
      },
    );

    return response;
  }

  // method to launch the MetaMask app usig the deeplink for session connection
  @override
  Future<SessionData?> launchMetamaskToAuthenticateAndConnect(
      ConnectResponse response) async {
    try {
      final String encodedUrl = Uri.encodeComponent('${response.uri}');

      // creating the deeplink
      deepLinkUrl = deepLinkUrl + encodedUrl;

      // launching the MetaMask app
      await launchUrlString(
        deepLinkUrl,
        mode: LaunchMode.externalApplication,
      );

      // fetch the current session details
      SessionData sessionData = await response.session.future;

      return sessionData;
    } catch (e) {
      Logger.log(e.toString());
      CustomToast.show(e.toString(), true);
    }
    return null;
  }

  @override
  String getAccount(SessionData session) {
    var account = NamespaceUtils.getAccount(
      session.namespaces.values.first.accounts.first,
    );

    return account;
  }

  @override
  Future<EtherAmount> getBalance(Web3Client client, String account) async {
    var amount = await client.getBalance(EthereumAddress.fromHex(account));
    return amount;
  }

  // method to initiate a transaction between two addresses
  @override
  Future<String> sendTransaction(
      Web3Client client, EthereumTransaction transaction) async {
    // create credentials
    var credential = EthPrivateKey.createRandom(Random.secure());

    //get transaction.value in wei
    int amount = (double.parse(transaction.value) * oneEthInWei).toInt();

    // transform a transaction object with the required details
    Transaction trans = Transaction(
      from: EthereumAddress.fromHex(transaction.from),
      to: EthereumAddress.fromHex(transaction.to),
      value: EtherAmount.fromInt(EtherUnit.wei, amount),
    );

    // get the currect chainID in which the transaction will be performed
    int chainID = (await client.getChainId()).toInt();

    //perform transaction and get the transaction hash
    String transactionHash =
        await client.sendTransaction(credential, trans, chainId: chainID);

    return transactionHash;
  }

  // method to fetch transaction details using hash
  Future<TransactionInformation?> getTransactionDetails(
      Web3Client client, String transactionHash) async {
    TransactionInformation? details =
        await client.getTransactionByHash(transactionHash);

    return details;
  }

  // method to fetch transaction receipt using hash
  // but keep in mind receipt will be null until the
  // transaction will be completed
  Future<TransactionReceipt?> getTransactionReceipt(
      Web3Client client, String transactionHash) async {
    TransactionReceipt? receipt =
        await client.getTransactionReceipt(transactionHash);

    return receipt;
  }
}
