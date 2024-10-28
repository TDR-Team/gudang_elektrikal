import 'package:gudang_elektrikal/app/modules/notification/notification.dart';

class ScheduleDailyPuhNotifHelper {
  static void scheduleDailyPushNotifHelper(
    String? name,
    int? id,
  ) {
    // Set the times for 08:00 and 16:00 WIB.
    DateTime now = DateTime.now();

    // Schedule for 08:00
    DateTime morningNotification = DateTime(
      now.year,
      now.month,
      now.day,
      8, // 08:00 AM
      0,
      0,
    );

    // If the time for today has passed, schedule for the next day
    if (morningNotification.isBefore(now)) {
      morningNotification = morningNotification.add(const Duration(days: 1));
    }

    // Schedule for 16:00
    DateTime afternoonNotification = DateTime(
      now.year,
      now.month,
      now.day,
      16,
      0,
      0,
    );

    if (afternoonNotification.isBefore(now)) {
      afternoonNotification =
          afternoonNotification.add(const Duration(days: 1));
    }

    // Schedule the notifications
    NotificationService.scheduleNotification(
      id ?? 0,
      'Stok komponen sudah mau habis',
      'Ayo re-stok pada komponen $name sebelum habis',
      morningNotification,
    );

    // NotificationService.scheduleNotification(
    //   1,
    //   'Stok komponen sudah mau habis',
    //   'Ayo re-stok pada komponen  $name sebelum habis',
    //   afternoonNotification,
    // );
  }
}
