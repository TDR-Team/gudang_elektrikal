import 'package:flutter/material.dart';
import 'package:gudang_elektrikal/app/widgets/card_job_vertical.dart';

class HorizontalCardListView extends StatelessWidget {
  const HorizontalCardListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return CardJobVertical(
            title: _getTitle(index),
            image: _getImage(index),
          );
        },
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Gratis Antar Jemput';
      case 1:
        return 'Harga Terjangkau';
      case 2:
        return 'Teknologi Canggih';
      case 3:
        return 'Mudah & Nyaman';
      default:
        return '';
    }
  }

  String _getImage(int index) {
    switch (index) {
      case 0:
        return 'assets/images/ic_delivery.png';
      case 1:
        return 'assets/images/ic_money.png';
      case 2:
        return 'assets/images/img_quality.png';
      case 3:
        return 'assets/images/ic_easy.png';
      default:
        return '';
    }
  }
}
