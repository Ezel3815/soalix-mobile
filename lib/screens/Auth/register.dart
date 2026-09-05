import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/app_validation.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/resources.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  bool isPasswordValid = false;
  bool isLoading = false;

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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Form(
            key: _formKey1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Image.asset(
                    "lib/assests/images/ddd.png",
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _fieldWrapper(
                    child: TextFormField(
                      controller: usernameController,
                      cursorColor: AppColor.greenColor,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColor.textPrimary,
                      ),
                      validator: AppValidation.validateEmpty,
                      decoration: _fieldDecoration('Username'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _fieldWrapper(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppColor.greenColor,
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
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppColor.greenColor,
                      controller: confirmEmailController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColor.textPrimary,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Filed Required";
                        }
                        if (value.trim().toLowerCase() !=
                            emailController.text.trim().toLowerCase()) {
                          return "Emails do not match";
                        }
                        return null;
                      },
                      decoration: _fieldDecoration('Confirm Email'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _fieldWrapper(
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      cursorColor: AppColor.greenColor,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColor.textPrimary,
                      ),
                      validator: AppValidation.validatePassword,
                      onChanged: (value) {
                        isPasswordValid =
                            AppValidation.validatePassword(value) == null;
                        setState(() {});
                      },
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
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey1.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                await ApiController.register(
                                    usernameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    context);
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.textSecondary,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Text(
                          'Sign in',
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
