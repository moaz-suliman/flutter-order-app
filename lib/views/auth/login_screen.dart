import 'package:final_project/controllers/auth_provider.dart';
import 'package:final_project/core/constents/app_color.dart';
import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:final_project/core/utils/validator.dart';
import 'package:final_project/core/widgets/common_widget/custom_elevated_button.dart';
import 'package:final_project/core/widgets/common_widget/custom_test_form_field.dart';
import 'package:final_project/views/common/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _hasError = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f6),
      appBar: AppBar(
        backgroundColor: const Color(0xfff6f7f6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Login',
          style: AppTextstyle.h2.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Icon
              Container(
                width: screenWidth * 0.16,
                height: screenWidth * 0.16,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: screenWidth * 0.09,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              Text('Welcome back', style: AppTextstyle.h1),
              SizedBox(height: screenHeight * 0.008),
              Text(
                'Login to your account to start ordering your favorites',
                style: AppTextstyle.body,
              ),

              SizedBox(height: screenHeight * 0.03),

              // Email
              CustomTextFormField(
                controller: emailController,
                labelText: 'Email Address',
                hintText: 'user@example.com',
                validator: emailValidator,
              ),

              SizedBox(height: screenHeight * 0.02),

              // Password
              CustomTextFormField(
                controller: passwordController,
                labelText: 'Password',
                hintText: '••••••••',
                obscureText: _obscurePassword,
                hasError: _hasError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: passwordValidator,
              ),

              // Error Message
              if (_hasError)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          authProvider.errorMessage ??
                              'The password you entered is incorrect.',
                          style: AppTextstyle.h2
                              .copyWith(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: AppTextstyle.h2.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Sign In Button
              authProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColor.primary))
                  : CustomElevatedButton(
                      text: 'Sign In',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final auth = context.read<AuthProvider>();

                          final result = await auth.login(
                            emailController.text,
                            passwordController.text,
                          );

                          if (!mounted) return;

                          if (result) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          } else {
                            setState(() => _hasError = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(auth.errorMessage ?? "Login failed"))
                            );
                          }
                        } else {
                          setState(() => _hasError = true);
                        }
                      },
                    ),

              SizedBox(height: screenHeight * 0.03),

              // OR CONTINUE WITH
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: AppTextstyle.body.copyWith(fontSize: 12),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              // Google & Apple Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02),
                      ),
                      onPressed: () {},
                      child: const FaIcon(FontAwesomeIcons.google,
                          color: Colors.red),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02),
                      ),
                      onPressed: () {},
                      child: const FaIcon(FontAwesomeIcons.apple,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: AppTextstyle.body.copyWith(fontSize: 14)),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/signup'),
                    child: Text(
                      'Sign Up',
                      style: AppTextstyle.body.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}