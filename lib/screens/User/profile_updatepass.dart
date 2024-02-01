import 'package:first_project/widgets/profile_appBar.dart';
import 'package:flutter/material.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  late Box<User> userBox;

  @override
  void initState() {
    super.initState();
    Hive.openBox<User>('user');
    userBox = Hive.box<User>('user');
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 190,
        flexibleSpace:  ProfileAppBar(
          pageTitle: 'Update Password',
          fontSize: 18,
          topAlign: 60,
          leftAlign:MediaQuery.of(context).size.width / 2 - 40,
          userBox: userBox,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                 ProfileText(userBox: userBox,),
                const SizedBox(height: 50),
                TextFormField(
                  controller: newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: const TextStyle(
                      color: Color(0xff666666),
                    ),
                    labelText: 'NEW PASSWORD',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    hintText: '  Enter the new password here',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      gapPadding: 5,
                      borderSide: const BorderSide(
                        color: Color(0xff1D327E),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xff1D327E),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_formKey.currentState?.validate() ?? false)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'This field should not be empty',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xff438883),fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          User? user = userBox.values.firstOrNull;
                          if (user != null) {
                            user.password = newPasswordController.text;
                            user.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                                content: Text('Password updated successfully'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Color(0xff438883),fontSize: 18,fontWeight: FontWeight.bold),
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