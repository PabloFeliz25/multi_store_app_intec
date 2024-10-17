import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app_intec/Controllers/auth_controller.dart';
import 'package:multi_store_app_intec/Views/screens/authentication_screens/login_screen.dart';
import 'package:multi_store_app_intec/Views/screens/main_screen.dart';
import 'package:multi_store_app_intec/Views/widgets/my_login_register_button.dart';
import 'package:multi_store_app_intec/Views/widgets/my_textform_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String response = await _authController.registerNewUser(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response)),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Color(0XFF0D120E),
                        fontSize: 23.0,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyTextFormField(
                    controller: nameController,
                    obscureText: false,
                    prefixIcon: Icons.person,
                    hintText: 'Your full name',
                    labelText: 'Enter your Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  MyTextFormField(
                    controller: emailController,
                    obscureText: false,
                    prefixIcon: Icons.mail,
                    hintText: 'user@email.com',
                    labelText: 'Enter your Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  MyTextFormField(
                    controller: passwordController,
                    obscureText: true,
                    prefixIcon: Icons.password,
                    hintText: 'Your password',
                    labelText: 'Enter your password',
                    suffixIcon: Icons.remove_red_eye,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : MyLoginRegisterButton(
                    text: 'Register',
                    onTap: registerUser,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an Account?',
                        style: GoogleFonts.lato(),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  LoginScreen()),
                          );
                        },
                        child: Text(
                          'Login here!',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e1cc9),
                            ),
                          ),
                        ),
                      )
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