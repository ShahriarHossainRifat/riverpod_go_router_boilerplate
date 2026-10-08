import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the current network connectivity state.
enum ConnectivityStatus {
  /// Device has an active network connection.
  connected,

  /// Device has no network connection.
  disconnected,
}

/// Service for monitoring network connectivity changes.
///
/// Exposes a stream of [ConnectivityStatus] and utility methods
/// for checking the current connection state.
class ConnectivityService {
  /// Creates a [ConnectivityService] instance.
  new() : _connectivity = Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _statusController = StreamController<ConnectivityStatus>.broadcast();

  /// Stream emitting connectivity status updates.
  Stream<ConnectivityStatus> get statusStream => _statusController.stream;

  /// Initializes connectivity monitoring and emits the initial status.
  Future<void> initialize() async {
    final results = await _connectivity.checkConnectivity();
    _emitStatus(results);

    _subscription = _connectivity.onConnectivityChanged.listen(_emitStatus);
  }

  void _emitStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );
    _statusController.add(hasConnection ? .connected : .disconnected);
  }

  /// Returns whether the device is currently connected to a network.
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != .none);
  }

  /// Disposes resources used by this service.
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}

/// Provides a singleton [ConnectivityService] instance.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
});

/// Provides a stream of [ConnectivityStatus] updates.
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
});

/// Indicates whether the device is currently online.
///
/// Defaults to `true` while the connectivity state is loading
/// or unavailable.
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityStatusProvider);
  return status.maybeWhen(data: (s) => s == .connected, orElse: () => true);
});
