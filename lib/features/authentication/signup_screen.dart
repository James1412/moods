import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/features/authentication/view_models/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const String routeUrl = '/signup';
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isObsecure = false;
  late bool _isValid = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email = "";
  String _password = "";
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  String? _emailValidator(String? value) {
    final regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (value != null) {
      if (!regExp.hasMatch(value)) {
        return "Email not valid";
      }
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value != null) {
      if (value.length < 8) {
        return "Password must be longer than 8 characters";
      }
    }
    return null;
  }

  void _autoValidate() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _isValid = true;
        setState(() {});

        _formKey.currentState!.save();
      } else {
        _isValid = false;
        setState(() {});
      }
    }
  }

  void _onPasswordEyeTap() {
    setState(() {
      _isObsecure = !_isObsecure;
    });
  }

  Future<void> _onCreateAccountTap() async {
    if (_email.isEmpty || _password.isEmpty || !_isValid) return;
    ref.read(signUpForm.notifier).state = {
      "email": _email,
      "password": _password,
    };
    await ref.read(signUpProvider.notifier).signUp(context);
    if (ref.watch(signUpProvider).hasError) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(signUpProvider).isLoading) {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign up",
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => _emailValidator(value),
                  onChanged: (value) => _autoValidate(),
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
                  controller: _passwordController,
                  obscureText: _isObsecure ? false : true,
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => _passwordValidator(value),
                  onChanged: (value) => _autoValidate(),
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: GestureDetector(
            onTap: _onCreateAccountTap,
            child: AnimatedOpacity(
              opacity: _isValid && !_isLoading ? 1 : 0.4,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.size32),
                  color: Colors.black,
                ),
                child: const Center(
                  child: Text(
                    "Create account",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.size16,
                    ),
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
