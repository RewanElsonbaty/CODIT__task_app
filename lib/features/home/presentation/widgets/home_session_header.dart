import 'package:flutter/material.dart';

class HomeSessionHeader extends StatelessWidget {
  const HomeSessionHeader({
    super.key,
    required this.shopName,
    required this.userName,
  });

  final String shopName;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$shopName — $userName',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}