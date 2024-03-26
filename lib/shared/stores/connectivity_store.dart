import '../enums/status_connection_enum.dart';
import '../utils/custom_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityStore extends GetxController {
  ConnectivityStore();

  // * Variables
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------
  final Connectivity _connectivity = Connectivity();

  // * Observables
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  /// Controll status of connection
  final _statusConnection = StatusConnection.none.obs;
  StatusConnection get statusConnection => _statusConnection.value;
  set statusConnection(StatusConnection value) => _statusConnection.value = value;

  // * Getters
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  bool get isConnected => statusConnection != StatusConnection.none;

  // * Actions
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    _hasConnection();
    _statusConnection.bindStream(
      _connectivity.onConnectivityChanged.map(
        (connectivityResult) {
          final StatusConnection status = _returnCurrentState(connectivityResult);

          LoggerApp.info('[STREAM] -> Status of connection: $status');
          LoggerApp.info('[STREAM] -> is connected: ${status != StatusConnection.none}');

          return status;
        },
      ),
    );
    super.onInit();
  }

  Future<bool> _hasConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final status = _returnCurrentState(result);

      LoggerApp.info('[INITIAL STATUS] -> Status of connection: $statusConnection');
      LoggerApp.info('[INITIAL STATUS] -> Is connected: ${statusConnection != StatusConnection.none}');
      return status != StatusConnection.none;
    } catch (e, s) {
      LoggerApp.error('Erro ao verificar rede', e, s);
      return false;
    }
  }

  StatusConnection _returnCurrentState(List<ConnectivityResult> connectivityResult) {
    // Mobile network available.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return StatusConnection.mobile;
    }

    // Wi-fi is available.
    // Note for Android:
    // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
    else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return StatusConnection.wifi;
    }

    // Ethernet connection available.
    else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return StatusConnection.ethernet;
    }

    // Vpn connection active.
    // Note for iOS and macOS:
    // There is no separate network interface type for [vpn].
    // It returns [other] on any device (also simulator)
    else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return StatusConnection.vpn;
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      return StatusConnection.bluetooth;
    }

    return StatusConnection.none;
  }

  @override
  void onClose() {
    _statusConnection.close();
    super.onClose();
  }
}
