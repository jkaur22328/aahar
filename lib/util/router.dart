import 'package:aahar/data/model/order.dart';
import 'package:aahar/features/auth/login_page.dart';
import 'package:aahar/features/auth/model/user_model.dart';
import 'package:aahar/features/auth/signup_page.dart';
import 'package:aahar/features/dashboard/dashboard_page.dart';
import 'package:aahar/features/home/home_page.dart';
import 'package:aahar/features/order/create_order_page.dart';
import 'package:aahar/features/order/order_page.dart';
import 'package:aahar/features/profile/profile_page.dart';
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
      path: Routes.profile,
      builder: (context, state) {
        final data = state.extra as UserModel?;
        return ProfilePage(user: data!);
      },
    ),
    GoRoute(
      path: Routes.admin,
      builder: (context, state) {
        return const DashboardPage();
      },
    ),
    GoRoute(
      path: Routes.createOrder,
      builder: (context, state) => CreateOrderPage(),
    ),
    GoRoute(
      path: Routes.order,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final order = data['order'] as OrderModel;
        final userData = data['user'] as UserModel?;
        return OrderDetailPage(
          order: order,
          user: userData!,
        );
      },
    ),
  ],
);
