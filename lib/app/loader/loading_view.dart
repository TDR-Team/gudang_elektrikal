import 'package:flutter/material.dart';

import '../common/styles/colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorScheme.primary,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primaryColors[0]),
      ),
    );
  }
}
