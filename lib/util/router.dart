import 'package:go_router/go_router.dart';
import 'package:testapp/features/auth/login_page.dart';
import 'package:testapp/features/auth/signup_page.dart';
import 'package:testapp/features/dashboard/admin_dashboard.dart';
import 'package:testapp/features/dashboard/dashboard.dart';
import 'package:testapp/util/routes.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => DashboardPage(),
    ),
    GoRoute(
      path: Routes.admin,
      builder: (context, state) => AdminDashboard(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: Routes.signup,
      builder: (context, state) => SignUpPage(),
    ),
  ],
);
