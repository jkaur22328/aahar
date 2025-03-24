import "package:aahar/features/auth/provider/auth_provider.dart";
import "package:aahar/features/dashboard/provider/dashboard_provider.dart";
import "package:aahar/firebase_options.dart";
import "package:aahar/util/router.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    Provider(create: (context) => AuthProvider()),
    // ChangeNotifierProvider(create: (context) => AuthProvider()),
    Provider(create: (context) => DashboardProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aahar',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
