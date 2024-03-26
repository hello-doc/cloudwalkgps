import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/home/home_bindings.dart';
import '../modules/home/home_page.dart';

class RoutesApp {
  RoutesApp._();

  static const String home = '/home';

  static final routes = [
    GetPage(
      name: RoutesApp.home,
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
  ];
}
