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
                    height: 35,
                  ),
                  Image.asset(
                    "lib/assests/images/ddd.png",
                  ),
                  const Text(
                    'Welcome',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'lib/assests/images/icon_username.png',
                            width: 80,
                            height: 35,
                          )),
                      Container(
                        width: 260,
                        child: TextFormField(
                          controller: usernameController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.name,
                          textAlign: TextAlign.center,
                          validator: AppValidation.validateEmpty,
                          decoration: InputDecoration(
                            hintText: 'Username',
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
                          cursorColor: Colors.black,
                          controller: emailController,
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
                          cursorColor: Colors.black,
                          controller: confirmEmailController,
                          textAlign: TextAlign.center,
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
                          decoration: InputDecoration(
                            hintText: 'Confirm Email',
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
                          obscureText: true,
                          controller: passwordController,
                          cursorColor: Colors.black,
                          textAlign: TextAlign.center,
                          validator: AppValidation.validatePassword,
                          onChanged: (value) {
                            isPasswordValid =
                                AppValidation.validatePassword(value) == null;
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
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
                        width: 100,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: isPasswordValid
                              ? AppColor.greenColor
                              : AppColor.disabledColor,
                        ),
                        width: 220,
                        height: 40,
                        child: InkWell(
                          onTap: isLoading
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
                          child: Center(
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(
                        width: 140,
                      ),
                      const Center(
                          child: Text(
                        'If You Have Account',
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
                          Get.back();
                          // Navigator.of(context).pushReplacement(MaterialPageRoute(
                          //     builder: (context) => const Login()));
                        },
                        child: const Text(
                          'Sign in',
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
