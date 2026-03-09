import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/login_controller.dart';
import 'package:tournament_freefire/log_sign/sign_Up.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/free.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back 👋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  textfiled(
                    obscureText: false,
                    Controller: loginController.emailController,
                    hintText: "Enter your Email",
                    title: "Email",
                  ),
                  const SizedBox(height: 20),

                  textfiled(
                    obscureText: true,
                    Controller: loginController.passwordController,
                    hintText: "Enter your Password",
                    title: "Password",
                  ),
                  const SizedBox(height: 30),

                  Obx(() => loginController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.orange)
                      : LogsignButton(
                    onTap: loginController.loginWithEmail,
                    title: "Login",
                  )),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: loginController.loginWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/google_logo.png",
                            height: 40, width: 30),
                        const SizedBox(width: 10),
                        const Text(
                          "Continue with Google",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Get.to(() =>  SignUPScreen());
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
