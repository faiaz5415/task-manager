import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_status_counter_provider.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager/ui/screens/set_password_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: const Size.fromWidth(double.maxFinite),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        initialRoute: SplashScreen.name,
        routes: {
          SplashScreen.name: (_) => const SplashScreen(),
          LoginScreen.name: (_) => const LoginScreen(),
          SignUpScreen.name: (_) => const SignUpScreen(),
          MainNavBarHolderScreen.name: (_) => const MainNavBarHolderScreen(),
          ForgotPasswordVerifyEmailScreen.name: (_) =>
              const ForgotPasswordVerifyEmailScreen(),
          ForgotPasswordVerifyOtpScreen.name: (_) =>
              const ForgotPasswordVerifyOtpScreen(),
          SetPasswordScreen.name: (_) => const SetPasswordScreen(),
          UpdateProfileScreen.name: (_) => const UpdateProfileScreen(),
        },
      ),
    );
  }
}
