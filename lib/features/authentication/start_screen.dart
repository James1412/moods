import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/features/authentication/login_screen.dart';
import 'package:final_project/features/authentication/signup_screen.dart';
import 'package:final_project/features/authentication/widgets/account_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends ConsumerStatefulWidget {
  static const routeUrl = '/';
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => SignupScreenState();
}

class SignupScreenState extends ConsumerState<StartScreen> {
  void _onSignupTap() {
    context.push(SignupScreen.routeUrl);
  }

  void _onLoginTap() {
    context.push(LoginScreen.routeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.v80,
              const FaIcon(
                FontAwesomeIcons.mugHot,
                size: Sizes.size52,
              ),
              Gaps.v20,
              const Text(
                "Mood tracker",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v10,
              const Opacity(
                opacity: 0.65,
                child: Text("Your very own mood tracker"),
              ),
              Expanded(
                child: Container(),
              ),
              Column(
                children: [
                  AccountButton(
                    isTextBlack: false,
                    text: 'Sign up',
                    onTap: _onSignupTap,
                  ),
                  Gaps.v10,
                  AccountButton(
                    isTextBlack: true,
                    text: 'Log in',
                    onTap: _onLoginTap,
                  ),
                  Gaps.v20,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
