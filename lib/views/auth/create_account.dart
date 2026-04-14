import 'package:final_project/controllers/auth_provider.dart'; 
import 'package:final_project/core/constents/app_color.dart';
import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:final_project/core/utils/validator.dart';
import 'package:final_project/core/widgets/common_widget/custom_elevated_button.dart';
import 'package:final_project/core/widgets/common_widget/custom_test_form_field.dart';
import 'package:final_project/views/common/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f6),
      appBar: AppBar(
        backgroundColor: const Color(0xfff6f7f6),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Account',
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
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              Text('Join us', style: AppTextstyle.h1),
              SizedBox(height: screenHeight * 0.008),
              Text(
                'Enter your details to get started with mobile ordering.',
                style: AppTextstyle.body,
              ),

              SizedBox(height: screenHeight * 0.03),

              //  Full Name
              CustomTextFormField(
                controller: nameController,
                labelText: 'Full Name',
                hintText: 'Enter your name',
                validator: fullNameValidator
              ),

              SizedBox(height: screenHeight * 0.02),

              //  Email
              CustomTextFormField(
                controller: emailController,
                labelText: 'Email Address',
                hintText: 'name@example.com',
                validator: emailValidator
              ),

              SizedBox(height: screenHeight * 0.02),

              //  Password
              CustomTextFormField(
                
                labelText: 'Password',
                hintText: 'Create a password',
                obscureText: _obscurePassword,
                controller: passwordController,
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
                validator: passwordValidator
              ),

              SizedBox(height: screenHeight * 0.02),

              //  Confirm Password
              CustomTextFormField(
                labelText: 'Confirm Password',
                hintText: 'Repeat password',
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                validator: (value) => confirmPasswordValidator(
                  value,
                  passwordController.text, 
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              //  Create Account Button
              CustomElevatedButton(
                text: 'Create Account',
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    final authProvider = context.read<AuthProvider>();
                    final result = await authProvider.register(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                        );

                        if (result) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProvider.errorMessage ?? "Registration failed"))
                        );
                      }
                  }
                },
              ),

              SizedBox(height: screenHeight * 0.03),

              //  Already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: AppTextstyle.body.copyWith(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      'Login',
                      style: AppTextstyle.body.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}