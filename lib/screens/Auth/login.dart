import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/app_validation.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';

import '../../controllers/api_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _RegisterState();
}

class _RegisterState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  bool loading = false;
  bool isPasswordValid = false;

  onTapLogin() async {
    setState(() {
      loading = true;
    });
    await ApiController.login(
        emailController.text, passwordController.text, context);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: AppColor.textSecondary,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: AppColor.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColor.greenColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  Widget _fieldWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: AppColor.scaffoldBackgroundColor,
            image: DecorationImage(
              image: AssetImage('lib/assests/images/background_5.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    "lib/assests/images/ddd.png",
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign in to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _fieldWrapper(
                    child: TextFormField(
                      cursorColor: AppColor.greenColor,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColor.textPrimary,
                      ),
                      validator: AppValidation.validateEmail,
                      decoration: _fieldDecoration('Email'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _fieldWrapper(
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      cursorColor: AppColor.greenColor,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColor.textPrimary,
                      ),
                      onChanged: (value) {
                        isPasswordValid =
                            value.isNotEmpty && value.length >= 6;
                        setState(() {});
                      },
                      validator: AppValidation.validatePassword,
                      decoration: _fieldDecoration('Password'),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPasswordValid
                            ? AppColor.greenColor
                            : AppColor.disabledColor,
                        foregroundColor: Colors.white,
                        elevation: isPasswordValid ? 3 : 0,
                        shadowColor: AppColor.greenColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: loading
                          ? null
                          : () {
                              if (_formKey1.currentState!.validate()) {
                                onTapLogin();
                              }
                            },
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.forgetPassowrdRoute);
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.greenColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.textSecondary,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.registerRoute);
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.greenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
