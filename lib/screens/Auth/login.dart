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
    setState(() {
      loading = false;
    });
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
              fit: BoxFit.fill, // يمكنك تعديل هذا الخيار حسب الحاجة
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisSize: MainAxisSize.min,

                children: [
                  const SizedBox(
                    height: 45,
                  ),
                  Image.asset(
                    "lib/assests/images/ddd.png",
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  const Text(
                    'Sign in to continue',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'lib/assests/images/icon_email.png',
                            width: 80,
                            height: 35,
                          )),
                      SizedBox(
                        width: 260,
                        child: TextFormField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          controller: emailController,
                          validator: AppValidation.validateEmail,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            fillColor: AppColor.greyColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            constraints: const BoxConstraints(
                              maxHeight: 60,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'lib/assests/images/icon_password.png',
                            width: 80,
                            height: 35,
                          )),
                      SizedBox(
                        width: 260,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          cursorColor: Colors.black,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            isPasswordValid =
                                value.isNotEmpty && value.length >= 6;
                            setState(() {});
                          },
                          validator: AppValidation.validatePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            fillColor: AppColor.greyColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: loading
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey1.currentState!.validate()) {
                            onTapLogin();
                          }
                        },
                        child: loading
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: isPasswordValid
                                      ? AppColor.greenColor
                                      : AppColor.darkGreenColor,
                                ),
                                width: 220,
                                height: 40,
                                child: const Center(
                                    child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                )),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                      ),
                      Center(
                          child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.forgetPassowrdRoute);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const ForgotPassword()));
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                      ),
                      const Center(
                          child: Text(
                        'Don`t have an account ?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                          child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.registerRoute);
                          // Navigator.of(context).pushReplacement(MaterialPageRoute(
                          //     builder: (context) => const Register()));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
