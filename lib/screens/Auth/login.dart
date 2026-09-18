import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/app_validation.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/mozaik_mark_icon.dart';

import '../../controllers/api_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  InputDecoration _fieldDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColor.textSecondary.withOpacity(0.8),
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(icon, size: 19, color: AppColor.greenColor),
      filled: true,
      fillColor: Colors.white.withOpacity(0.55),
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
          const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
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
          color: AppColor.scaffoldBackgroundColor,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: MozaikMarkIcon(
                      color: AppColor.greenColor,
                      size: 84,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "MOZAIK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 6,
                      color: AppColor.darkGreenColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "تعلّم بطريقة أذكى",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.textSecondary.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          cursorColor: AppColor.greenColor,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColor.textPrimary,
                          ),
                          validator: AppValidation.validateEmail,
                          decoration: _fieldDecoration(
                              Icons.mail_outline_rounded, 'البريد الإلكتروني'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          textAlign: TextAlign.right,
                          cursorColor: AppColor.greenColor,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColor.textPrimary,
                          ),
                          onChanged: (value) {
                            isPasswordValid =
                                value.isNotEmpty && value.length >= 6;
                            setState(() {});
                          },
                          validator: AppValidation.validatePassword,
                          decoration: _fieldDecoration(
                              Icons.lock_outline_rounded, 'كلمة المرور'),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPasswordValid
                                  ? AppColor.darkGreenColor
                                  : AppColor.disabledColor,
                              foregroundColor: Colors.white,
                              elevation: isPasswordValid ? 3 : 0,
                              shadowColor:
                                  AppColor.darkGreenColor.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
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
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_back_rounded,
                                          size: 18, color: Colors.white),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: AppColor.textSecondary
                                        .withOpacity(0.3))),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "أو",
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      AppColor.textSecondary.withOpacity(0.8),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                                    color: AppColor.textSecondary
                                        .withOpacity(0.3))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColor.darkGreenColor,
                              side: const BorderSide(
                                  color: AppColor.greenColor, width: 1.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            onPressed: () {
                              Get.toNamed(AppRoutes.registerRoute);
                            },
                            child: const Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.forgetPassowrdRoute);
                      },
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.greenColor,
                        ),
                      ),
                    ),
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
