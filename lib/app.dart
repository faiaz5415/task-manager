import 'package:flutter/material.dart';
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
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
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
              fixedSize: Size.fromWidth(double.maxFinite),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      initialRoute: SplashScreen.name,
      routes: {
        SplashScreen.name : (_) => SplashScreen(),
        LoginScreen.name : (_) => LoginScreen(),
        SignUpScreen.name : (_) => SignUpScreen(),
        MainNavBarHolderScreen.name : (_) => MainNavBarHolderScreen(),
        UpdateProfileScreen.name : (_) => UpdateProfileScreen(),
        ForgotPasswordVerifyEmailScreen.name : (_) => ForgotPasswordVerifyEmailScreen(),
        ForgotPasswordVerifyOtpScreen.name : (_) => ForgotPasswordVerifyOtpScreen(),
        SetPasswordScreen.name : (_) => SetPasswordScreen(),

      },
    );
  }
}
