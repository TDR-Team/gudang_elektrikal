// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/loader/loading_view.dart';
import 'package:gudang_elektrikal/app/modules/components/views/get_components_view.dart';
import 'package:gudang_elektrikal/app/modules/login/views/forgot_password_view.dart';
import 'package:gudang_elektrikal/app/modules/tools/bindings/tools_binding.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/get_tools_view.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/tools_view.dart';

import '../modules/history/views/history_view.dart';
import '../modules/components/bindings/components_binding.dart';
import '../modules/components/views/components_view.dart';
import '../modules/components/views/list_components_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOADING;

  static final routes = [
    GetPage(
      name: _Paths.LOADING,
      page: () => const LoadingView(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.TOOLS,
      page: () => const ToolsView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.GET_TOOLS,
      page: () => const GetToolsView(),
      binding: ToolsBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.COMPONENTS,
      page: () => const ComponentsView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.LIST_COMPONENTS,
      page: () => const ListComponentsView(),
      binding: ComponentsBinding(),
    ),
    GetPage(
      name: _Paths.GET_COMPONENTS,
      page: () => const GetComponentsView(),
      binding: ComponentsBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
