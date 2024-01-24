import 'package:flutter/material.dart';
// import 'package:first_project/Screens/User/bottomnav.dart';
// import 'package:first_project/Screens/User/user_signUp.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';

class UserLogIn extends StatefulWidget {
  const UserLogIn({super.key});

  @override
  State<UserLogIn> createState() => _UserLogInState();
}

class _UserLogInState extends State<UserLogIn> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Box<User> userBox;

  @override
  void initState() {
    super.initState();
    openUserBox();
  }

  Future<void> openUserBox() async {
    await Hive.openBox<User>('user');
    setState(() {
      userBox = Hive.box<User>('user');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/usersignin.png',
                width: 250,
                height: 250,
              ),
              const Text(
                'User Login !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: const TextStyle(
                            color: Color(0xff435288),
                          ),
                          labelText: '  User name',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color(0xff435288), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color(0xff435288), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Value is Empty,Enter your name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: const TextStyle(
                            color: Color(0xff435288),
                          ),
                          labelText: ' PASSWORD',
                          hintText: '********',
                          suffixIcon: const Icon(Icons.remove_red_eye),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 12),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color(0xff435288), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color(0xff435288), width: 2),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 65,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      signIn();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 53, 51, 51),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Do not Have Any Account?'),
                    TextButton(
                      onPressed: () {
                        // Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(
                        //         builder: (ctx) => const UserSignUpScreen()));
                      },
                      child: const Text('Sign Up',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String enteredName = userNameController.text.trim();
      final String enteredPassword = passwordController.text.trim();

      // Retrieve all users from the database using the existing userBox
      final List<User> allUsers = userBox.values.cast<User>().toList();

      User? matchingUser;
      try {
        matchingUser = allUsers.firstWhere(
          (user) =>
              user.name == enteredName && user.password == enteredPassword,
        );
      } catch (e) {
        matchingUser = null;
      }

      if (matchingUser != null) {
        // Successfully signed in, navigate to the home page
        final String userId = matchingUser.userId;
        print('Successfully signed in with userId: $userId');
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (ctx) => const BottomNav()));
      } else {
        // Display an error message
        const errorMessage = 'Username or password is incorrect';
        showDialog(
          context: context,
          builder: (ctx1) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx1).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}