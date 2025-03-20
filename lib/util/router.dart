import 'package:aahar/features/auth/login_page.dart';
import 'package:aahar/features/auth/signup_page.dart';
import 'package:aahar/features/dashboard/admin_page.dart';
import 'package:aahar/features/dashboard/dashboard.dart';
import 'package:aahar/features/order/create_order_page.dart';
import 'package:aahar/util/routes.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => AdminPage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: Routes.signup,
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: Routes.admin,
      builder: (context, state) => AdminPage(),
    ),
    GoRoute(
      path: Routes.createOrder,
      builder: (context, state) => CreateOrderPage(),
    ),
  ],
);
