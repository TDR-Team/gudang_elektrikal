import 'package:flutter/material.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

class CardJobVertical extends StatelessWidget {
  // final JobData job;
  final String image;
  final String title;
  final void Function()? onTap;
  const CardJobVertical({
    super.key,
    // required this.job,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      // height: 100,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.lightBlue,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 7,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildImageContainer(),
          // _buildJobDetails(),
          const SizedBox(height: 6),
          _buildDetailCard()
        ],
      ),
    );
  }

  _buildDetailCard() {
    return Container(
      height: 64,
      width: 140,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        color: Colors.lightBlue,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: semiBoldText14.copyWith(
          color: Colors.white,
        ),
        overflow: TextOverflow.clip,
        maxLines: 3,
      ),
    );
  }

  _buildImageContainer() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Image.asset(
          image,
          height: 120,
          // width: 120,
          fit: BoxFit.fitHeight,
          // loadingBuilder: (context, child, loadingProgress) {
          //   if (loadingProgress == null) {
          //     return child;
          //   } else {
          //     return Shimmer.fromColors(
          //       baseColor: const Color.fromARGB(255, 148, 148, 148),
          //       highlightColor: const Color.fromARGB(255, 102, 95, 95),
          //       child: Container(
          //         width: 120,
          //         height: 120,
          //         decoration: BoxDecoration(
          //           color: Colors.grey.withOpacity(0.5),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //       ),
          //     );
          //   }
          // },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.image_not_supported,
                size: 90,
                color: Color.fromARGB(255, 53, 53, 53),
              ),
            );
          },
        ),
      ),
    );
  }

  // _buildJobDetails() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '${job.position}, ${job.title}',
  //           overflow: TextOverflow.ellipsis,
  //           style: semiBoldText14,
  //         ),
  //         const SizedBox(
  //           height: 4,
  //         ),
  //         _buildDateRow(),
  //         const SizedBox(
  //           height: 4,
  //         ),
  //         _buildLocationRow()
  //       ],
  //     ),
  //   );
  // }

  // _buildLocationRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       SvgPicture.asset(
  //         'assets/icons/ic_location_job.svg',
  //         height: 14,
  //         width: 14,
  //         colorFilter: const ColorFilter.mode(
  //           Colors.red,
  //           BlendMode.srcIn,
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 6.0,
  //       ),
  //       Expanded(
  //         child: Text(
  //           job.location.name ?? "",
  //           overflow: TextOverflow.ellipsis,
  //           style: regularText12.copyWith(
  //             color: const Color(0xFF666666),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // _buildDateRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       SvgPicture.asset(
  //         'assets/icons/ion_calendar.svg',
  //         height: 14,
  //         width: 14,
  //       ),
  //       const SizedBox(
  //         width: 6.0,
  //       ),
  //       Expanded(
  //         child: Text(
  //           formatCompactDate(job.startAt),
  //           style: mediumText12.copyWith(
  //             color: const Color(0xFF666666),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
