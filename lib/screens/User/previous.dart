import 'package:first_project/screens/admin/admin_previous.dart';
import 'package:first_project/screens/user/user_signIn.dart';
import 'package:flutter/material.dart';

class PreviousPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding:const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/welcomelogo.png',
              height: 250.0, 
            ),
            // Moto Text
            const Text(
              'Empowering Automotive Enthusiasts through our Learning platform.',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const UserLogIn()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child:const SizedBox(
                width: 300.0,
                height: 65.0,
                child:Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const Text('Go to admin'),
               TextButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminPreviousPage()),
                    );
                  },
                child:const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

