import 'package:flutter/material.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/utils/string_utils.dart';


class BottomBarTotal extends StatelessWidget {
  final double totalPrice;
  final bool isInputValid;
  final Function() onButtonClicked;
  final String buttonTitle;
  final bool isLoading;
  const BottomBarTotal({
    super.key,
    required this.totalPrice,
    required this.isInputValid,
    required this.onButtonClicked,
    required this.buttonTitle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Harga',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                formatCurrency(totalPrice),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: isInputValid ? Colors.white : Colors.grey,
              borderRadius: BorderRadius.circular(50),
            ),
            child: InkWell(
              onTap: isInputValid ? onButtonClicked : null,
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_checkout,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 5),
                    isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.lightBlue,
                            ),
                          )
                        : Text(
                            buttonTitle,
                            style: semiBoldText14.copyWith(
                              color: Colors.blue,
                            ),
                            // style: TextStyle(
                            //   fontSize: 20,
                            //   fontWeight: FontWeight.w400,
                            //   color: Colors.black,
                            // ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
