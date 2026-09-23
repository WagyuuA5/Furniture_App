import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkWrapper extends StatelessWidget {
  final Widget child;
  const NetworkWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          StreamBuilder<List<ConnectivityResult>>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final results = snapshot.data!;
              final hasInternet = !results.contains(ConnectivityResult.none);
              if (hasInternet) return const SizedBox.shrink();
              
              return Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.wifi_off, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Koneksi terputus. Periksa internet Anda.',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
