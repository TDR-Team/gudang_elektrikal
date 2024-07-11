import 'package:flutter/material.dart';
import '../common/styles/colors.dart';
import '../common/theme/font.dart';

class CardChatList extends StatelessWidget {
  final String name;
  final String message;
  final String avatar;
  final String time;
  final void Function()? onTap;

  const CardChatList({
    super.key,
    required this.name,
    required this.message,
    required this.avatar,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    avatar,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: semiBoldText14,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: regularText12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      time,
                      style: regularText12.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors[1],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '2',
                          style: regularText12.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
