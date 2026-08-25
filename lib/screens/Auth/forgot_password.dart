import 'package:flutter/material.dart';
import 'package:upgrade/app_validation.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/app_snack_bar.dart';

import '../../controllers/api_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _RegisterState();
}

class _RegisterState extends State<ForgotPassword> {
  TextEditingController codeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: Form(
            key: _formKey1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,

                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  Image.asset(
                    "lib/assests/images/ddd.png",
                  ),
                  const Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  const Text(
                    'New Password',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'lib/assests/images/icon_email.png',
                            width: 80,
                            height: 35,
                          )),
                      Container(
                        width: 260,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          cursorColor: Colors.black,
                          textAlign: TextAlign.center,
                          validator: AppValidation.validateEmail,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
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
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'lib/assests/images/icon_email.png',
                            width: 80,
                            height: 35,
                          )),
                      Container(
                        width: 140,
                        child: TextFormField(
                          cursorColor: Colors.black,
                          textAlign: TextAlign.center,
                          controller: codeController,
                          validator: AppValidation.validateEmpty,
                          decoration: InputDecoration(
                            hintText: 'Code',
                            hintStyle: TextStyle(
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
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if(AppValidation.isEmail(emailController.text)) {
                            await ApiController.requestResetPassword(
                                emailController.text, context);
                          } else {
                            showSnackBarWidget(message: "Please Enter a valid Email");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColor.darkGreenColor,
                          ),
                          width: 100,
                          child: const Center(
                              child: Text(
                            'Get Code',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'lib/assests/images/icon_password.png',
                            width: 80,
                            height: 35,
                          )),
                      Container(
                        width: 260,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          validator: AppValidation.validatePassword,
                          cursorColor: Colors.black,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            hintStyle: TextStyle(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 120,
                      ),
                      InkWell(
                        onTap: () async {
                          if (_formKey1.currentState!.validate()) {
                            await ApiController.resetPassword(
                                emailController.text,
                                codeController.text,
                                passwordController.text,
                                context);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColor.darkGreenColor,
                          ),
                          width: 220,
                          height: 40,
                          child: const Center(
                              child: Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          )),
                        ),
                      ),
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
