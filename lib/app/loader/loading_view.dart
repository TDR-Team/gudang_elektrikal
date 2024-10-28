import 'package:flutter/material.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';

class LoadingView extends StatelessWidget {
  static const String route = '/loader';

  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: kColorScheme.primary,
        ),
      ),
    );
  }
}
