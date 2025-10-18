import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';
import '../widgets/photo_picker_detector.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';




  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromUpdateProfile: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Update Profile',
                      style: TextTheme.of(context).titleLarge,
                    ),
                    const SizedBox(height: 24),
                    PhotoPickerField(
                      onTap: _pickImage,
                      selectedPhoto: _selectedImage,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Email'),
                    ),
                    TextFormField(
                      controller: _firstNameTEController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'First Name'),
                    ),
                    TextFormField(
                      controller: _lastNameTEController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Last Name'),
                    ),
                    TextFormField(
                      controller: _mobileTEController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Mobile'),
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Password'),
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: Icon(Icons.done_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
  }
}
