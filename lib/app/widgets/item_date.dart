import 'package:flutter/material.dart';
import '../common/styles/colors.dart';

Widget itemDate(String dayName,String dayDate, bool isToday, bool hasEvent) {
  Color backgroundColor = isToday ? AppColors.primaryColors[0] : Colors.transparent;
  Color dayNameColor = isToday ? Colors.white : Colors.grey;
  Color dayDateColor = isToday ? Colors.white : Colors.black;
  Color eventSignColor = hasEvent ? AppColors.primaryColors[3] : Colors.transparent;

  return Container(
    decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12))
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8, right: 8, left: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            dayName,
            style: TextStyle(
                fontSize: 12,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: dayNameColor
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(dayDate,
            style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: dayDateColor
            ),
          ),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: eventSignColor
            ),
          )
        ],
      ),
    ),
  );
}

