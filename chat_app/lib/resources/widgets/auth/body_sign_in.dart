import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/controllers/firebase_auth_controller.dart';
import 'package:chat_app/views/auth/sign_up_screen.dart';

import '../../constants.dart';
import 'auth_button.dart';
import 'auth_text_input.dart';

class BodySignIn extends StatelessWidget {
  final TextEditingController emailEditingController;
  final TextEditingController passwordEditingController;

  const BodySignIn(
      {Key? key,
      required this.emailEditingController,
      required this.passwordEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          AuthTextInput(
            controller: emailEditingController,
            lableText: "Email",
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 30),
          AuthTextInput(
            controller: passwordEditingController,
            lableText: "Password",
            keyboardType: TextInputType.text,
            obscure: true,
          ),
          const SizedBox(height: 30),
          AuthButton(
              onTap: () {
                context.read<FirebaseAuthController>().signInWithEmailAndPassword(
                    email: emailEditingController.text.trim(),
                    password: passwordEditingController.text.trim());
              },
              title: "Sign In"),
          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                "Do not have an account? ",
                style: txtRegular(14),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen()));
                  },
                  child: Text(
                    "Sign Up",
                    style: txtSemiBold(18, primaryColor),
                  ))
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const Expanded(child: Divider(color: secondaryColor)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "OR",
                  style: txtBold(16),
                ),
              ),
              const Expanded(child: Divider(color: secondaryColor)),
            ],
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () async {
              await context.read<FirebaseAuthController>().signInWithGoogle();
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: secondaryColor, width: 0.5)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      googleIcon,
                      width: 30,
                      height: 30,
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                              "Sign in with Google",
                              style: txtMedium(24, Colors.blue),
                            )))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
