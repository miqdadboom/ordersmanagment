import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionBanner extends StatefulWidget {
  const InternetConnectionBanner({super.key});

  @override
  State<InternetConnectionBanner> createState() =>
      _InternetConnectionBannerState();
}

class _InternetConnectionBannerState extends State<InternetConnectionBanner> {
  bool _hasConnection = true;
  late final Connectivity _connectivity;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        _hasConnection = result != ConnectivityResult.none;
      });
    });
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      _hasConnection = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasConnection) return const SizedBox.shrink();
    return MaterialBanner(
      content: const Text(
        'Internet Connection Error',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
