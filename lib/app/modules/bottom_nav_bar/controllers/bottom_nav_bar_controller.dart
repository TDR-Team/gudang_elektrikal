import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/activity/views/activity_view.dart';
import 'package:gudang_elektrikal/app/modules/borrow_tools/views/borrow_tools_view.dart';
import 'package:gudang_elektrikal/app/modules/get_components/views/get_components_view.dart';
import 'package:gudang_elektrikal/app/modules/profile/views/profile_view.dart';

class BottomNavBarController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [
    // const HomeView(),
    const GetComponentsView(),
    const BorrowToolsView(),
    const ActivityView(),
    const ProfileView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }

  void handleCreateTodo() {
    // Your logic to handle creating a new todo
  }
}
