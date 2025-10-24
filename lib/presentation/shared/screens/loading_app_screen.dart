import 'package:flutter/material.dart';

class LoadingAppScreen extends StatelessWidget {
  static const String routeName = 'loading';

  const LoadingAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
