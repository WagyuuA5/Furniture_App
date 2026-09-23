import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonListLoader extends StatelessWidget {
  final bool isLoading;
  final int itemCount;

  const SkeletonListLoader({
    super.key,
    required this.isLoading,
    this.itemCount = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(radius: 25),
            title: const Text("Nama User yang Panjang"),
            subtitle: const Text(
              "Ini adalah deskripsi konten yang akan muncul nanti",
            ),
          );
        },
      ),
    );
  }
}
