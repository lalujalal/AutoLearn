import 'package:first_project/hive/hive.dart';
import 'package:first_project/screens/User/user_signIn.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  
  final TextEditingController nameController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final userBox =Hive.box<User>('user');
   @override
  void initState() {
    super.initState();
   userBox; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              const Text('Lets Create!',textAlign: TextAlign.center,style: TextStyle(
              fontSize: 35,
              color: Colors.black,
              fontWeight: FontWeight.w900,
                ),),
              Image.asset("assets/images/user_create.png",
              width: 180,
              height: 180,),
              const SizedBox(height: 20,),
               Form(
                key: _formKey,
                 child: Column(
                  children:[
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                        color: Color(0xff435288),
                      ),
                      labelText: 'YOUR NAME',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xff435288), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xff435288), width: 2),
                      ),
                    ),
                    validator:(value){
                      if (value == null || value.isEmpty) {
                      return 'Value is Empty,Enter your name';
                      } else {
                      return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                        color: Color(0xff435288),
                      ),
                      labelText: 'YOUR EMAIL',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xff435288), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xff435288), width: 2),
                      ),
                    ),
                    validator: (value) {
                       if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                        return 'Enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                        color: Color(0xff435288),
                      ),
                      labelText: 'CHOOSE YOUR PASSWORD',
                      hintText: 'Eg:Lal@123',
                      suffixIcon:const Icon(Icons.remove_red_eye),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xff435288), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
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
                        } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])').hasMatch(value)) {
                        return 'Password must contain at least 1 capital letter and 1 number';
                        } else {
                         return null;
                        }
                    },
                  ),
                  const SizedBox(height: 10,),
                  const Text('Must have at least 8 characters, 1 capital letter and 1 number.'),
                  const SizedBox(height: 35,),
                   SizedBox(
                    height: 50,
                    width: 330,
                        child: ElevatedButton(
                          onPressed: ()async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if(nameController.text.isNotEmpty&&emailController.text.isNotEmpty&&passwordController.text.isNotEmpty){  
                             await signUp();
                            
                            }}
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 53, 51, 51),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children:[
                               const Text('Already Have Account?'),
                               TextButton(onPressed: (){
                                 Navigator.push(context,MaterialPageRoute(builder: (context) =>const UserLogIn()),);
                               }, 
                               child:const Text('Sign In',
                               style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                    ),))
                  ])
                ]),
               )
          ]),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    
    if (_formKey.currentState?.validate() ?? false) {
    
      if(nameController.text.isNotEmpty&&emailController.text.isNotEmpty&&passwordController.text.isNotEmpty){  
      final String userId = DateTime.now().millisecondsSinceEpoch.toString();
      final String name = nameController.text.trim();
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
  
      final User newUser = User(userId: userId,name: name, email: email, password: password);
      print(newUser);
      userBox.put(userId, newUser);

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const UserLogIn()));
      
    }else {
      const errormssg = 'user name or pass word is incorrect';
      showDialog(
        context: context,
        builder: (ctx1) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(errormssg),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx1).pop();
                },
                child: const Text('Close'),
              )
            ],
          );
      },
    );
  }
 }}
}