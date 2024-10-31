import 'package:get/get.dart';

class DetailActivityController extends GetxController {
  String formatUser(String user) {
    return user.split(" ").first;
  }

  String formatItemType(String itemType) {
    switch (itemType) {
      case 'components':
        return 'Komponen';
      case 'tools':
        return 'Alat';
      default:
        return itemType;
    }
  }

  String formatActionType(String actionType) {
    switch (actionType) {
      case 'add':
        return 'menambahkan';
      case 'edit':
        return 'mengubah';
      case 'delete':
        return 'menghapus';
      case 'take':
        return 'mengambil';
      case 'borrow':
        return 'meminjam';
      case 'return':
        return 'mengembalikan';
      default:
        return actionType;
    }
  }
}
