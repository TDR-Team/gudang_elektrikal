import 'package:flutter/material.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';

import 'package:gudang_elektrikal/app/common/theme/font.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: <Color>[
                  kColorScheme.primary,
                  kColorScheme.primary.withOpacity(0.6),
                  kColorScheme.primary.withOpacity(0.3),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/img_splash.png',
                width: MediaQuery.sizeOf(context).width / 2,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Version 1.0.0',
                    style: mediumText16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
