import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isFirstCheck = true;

  void init(BuildContext context) {
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _handleConnectivityChange(context, results);
    });
  }

  void _handleConnectivityChange(BuildContext context, List<ConnectivityResult> results) {
    // If any of the results indicate no connection
    bool isOnline = results.any((result) => result != ConnectivityResult.none);
    
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 10),
              Text("No internet connection"),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(days: 1), // Keep it visible until online
        ),
      );
    } else {
      if (!_isFirstCheck) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Back online"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
    _isFirstCheck = false;
  }

  void dispose() {
    _subscription?.cancel();
  }
}

final connectivityService = ConnectivityService();
