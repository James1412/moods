import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/features/authentication/forgot_password_screen.dart';
import 'package:final_project/features/authentication/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeUrl = '/login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => SignupScreenState();
}

class SignupScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isObsecure = false;

  void _onContinueTap(context) {
    if (_formKey.currentState != null) {
      _formKey.currentState!.save();
      ref.read(loginProvider.notifier).login(
            _formData['email']!,
            _formData['password']!,
            context,
          );
      if (ref.watch(loginProvider).hasError) {
        return;
      }
    }
  }

  void _onPasswordEyeTap() {
    setState(() {
      _isObsecure = !_isObsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gaps.v64,
                TextFormField(
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(Sizes.size10),
                    ),
                    hintText: "Email",
                  ),
                  onSaved: (newValue) {
                    if (newValue != null) {
                      _formData['email'] = newValue.toString();
                    }
                  },
                ),
                Gaps.v20,
                TextFormField(
                  obscureText: _isObsecure ? false : true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: _onPasswordEyeTap,
                      child: Icon(
                        _isObsecure
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(Sizes.size10),
                    ),
                    hintText: "Password",
                  ),
                  onSaved: (newValue) {
                    if (newValue != null) {
                      _formData['password'] = newValue.toString();
                    }
                  },
                ),
                Gaps.v10,
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ));
                    },
                    child: const Text(
                      "Forgot password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: GestureDetector(
            onTap: () => _onContinueTap(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(Sizes.size32),
                color: Colors.black,
              ),
              child: const Center(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Sizes.size16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
