import 'package:aahar/data/model/order.dart';
import 'package:aahar/features/auth/login_page.dart';
import 'package:aahar/features/auth/signup_page.dart';
import 'package:aahar/features/dashboard/admin_page.dart';
import 'package:aahar/features/home/home_page.dart';
import 'package:aahar/features/order/create_order_page.dart';
import 'package:aahar/features/order/order_page.dart';
import 'package:aahar/util/routes.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => HomePage(),
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
      builder: (context, state) => OrderDashboard(),
    ),
    GoRoute(
      path: Routes.createOrder,
      builder: (context, state) => CreateOrderPage(),
    ),
    GoRoute(
      path: Routes.order,
      builder: (context, state) {
        final data = state.extra as OrderModel;
        return OrderDetailPage(order: data);
      },
    ),
  ],
);
