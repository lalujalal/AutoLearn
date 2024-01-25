import 'package:first_project/Screens/admin/admin_home.dart';
import 'package:flutter/material.dart';

class AdminSignIn extends StatefulWidget {
  const AdminSignIn({Key? key});

  @override
  State<AdminSignIn> createState() => _AdminSignInState();
}

class _AdminSignInState extends State<AdminSignIn> {
  final String hardcodedUsername = 'Admin';
  final String hardcodedPassword = 'Admin@123';

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isUsernameValid = true;
  bool isPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/admin_login.png',
                  width: 250,
                  height: 250,
                ),
                const Text(
                  'Admin Login !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    TextFormField(
                      controller: userNameController,
                      onChanged: (value) {
                        setState(() {
                          isUsernameValid = true;
                        });
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: const TextStyle(
                          color: Color(0xff435288),
                        ),
                        labelText: '  User name',
                        errorText: isUsernameValid ? null : 'Enter your name',
                        contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xff435288), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xff435288), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            isUsernameValid = false;
                          });
                          return 'Value is Empty, Enter your name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      onChanged: (value) {
                        setState(() {
                          isPasswordValid = true;
                        });
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: const TextStyle(
                          color: Color(0xff435288),
                        ),
                        labelText: ' PASSWORD',
                        hintText: '    ********',
                        suffixIcon: const Icon(Icons.remove_red_eye),
                        errorText: isPasswordValid ? null : 'Invalid password',
                        contentPadding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xff435288), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xff435288), width: 2),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            isPasswordValid = false;
                          });
                          return 'Password is required';
                        } else if (value.length < 8) {
                          setState(() {
                            isPasswordValid = false;
                          });
                          return 'Password must be at least 8 characters long';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: 65,
                      width: 330,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (userNameController.text == hardcodedUsername &&
                                passwordController.text == hardcodedPassword) {
                              // Navigate to AdminHome if credentials are correct
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (ctx1) => const AdminHome()),
                              );
                            } else {
                              // Handle incorrect credentials
                              // Show an alert box
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Login Failed'),
                                    content: const Text('Username or password is incorrect'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          'LogIn',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



