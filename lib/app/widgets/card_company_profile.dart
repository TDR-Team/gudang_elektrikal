import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../common/styles/colors.dart';
import '../common/theme/font.dart';


class CardCompanyProfile extends StatefulWidget {
  final String image;
  final String name;
  final String address;

  const CardCompanyProfile({
    super.key,
    required this.image,
    required this.name,
    required this.address,
  });

  @override
  State<CardCompanyProfile> createState() => _CardCompanyProfileState();
}

class _CardCompanyProfileState extends State<CardCompanyProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding:
          const EdgeInsets.only(left: 8.0, top: 4.0, right: 16.0, bottom: 34.0),
      decoration: BoxDecoration(
        color: kColorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.elliptical(40, 20),
          bottomRight: Radius.elliptical(40, 20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(),
          const SizedBox(height: 8.0),
          _buildCompanyInfo(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompanyLogo(),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCompanyRating(),
                const SizedBox(height: 6.0),
                _buildCompanyName(),
                const SizedBox(height: 8.0),
                _buildCompanyAddress(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo() {
    return ClipOval(
      child: Image.asset(
        widget.image,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCompanyRating() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/star.svg',
          height: 24,
          width: 24,
        ),
        const SizedBox(width: 8.0),
        Text(
          '4.2',
          style: semiBoldText14.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyName() {
    return Text(
      widget.name,
      style: boldText18.copyWith(
        color: Colors.white,
      ),
    );
  }

  Widget _buildCompanyAddress() {
    return Text(
      widget.address,
      style: regularText14.copyWith(
        color: Colors.white,
      ),
    );
  }
}
