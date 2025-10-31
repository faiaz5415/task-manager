import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/login_screen.dart';


import '../../data/service/network_caller.dart';
import '../../data/services/urls.dart';
import '../widgets/screen_background.dart';
import '../widgets/snackbar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-Up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _signUpInProgress = false;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (!EmailValidator.validate(value ?? '')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'Mobile'),
                    keyboardType: TextInputType.phone,
                    validator: (String? value) {
                      if ((value ?? '').length < 11) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if ((value?.length ?? 0) <= 6) {
                        return 'Password must be more than 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  Visibility(
                    visible: _signUpInProgress == false,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _onTapSignUpButton,
                        child: const Icon(Icons.arrow_circle_right),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pushReplacementNamed(context, LoginScreen.name);
  }

  void _clearTextFields(){
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
  }

  void _onTapSignUpButton() {
    if (_formkey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async{
    _signUpInProgress = true;
    if(mounted) {
      setState(() {});
    }

    Map<String, String> requestBody ={
      "email" : _emailController.text.trim(),
      "firstName" : _firstNameController.text.trim(),
      "lastName" : _lastNameController.text.trim(),
      "mobile" : _phoneController.text.trim(),
      "password" : _passwordController.text,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.registrationUrl, body:  requestBody);

    _signUpInProgress = false;
    if(mounted){
      setState(() {});
    }

    if (response.isSuccess){
      _clearTextFields();
      if(mounted){
        showSnackBarMessage(context, 'Registration has been successful. Please Login.');
      }
    }else {
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Registration failed!');
      }
    }
  }
}
