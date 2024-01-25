import 'package:first_project/widgets/home_options.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: 150,
              width: double.infinity,
              decoration:const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/settings.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child:const Center(
                child: Text(
                      'Home Admin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 38,
                        color: Colors.white,
                        fontWeight: FontWeight.w900, 
                      ),
                    ),
              )
            ),
            Padding(
              padding: const  EdgeInsets.all(30),
              child: Column(
              children: [
                const SizedBox(height: 10,),
                AdminButtonWithDesign(
                  imageUrl: 'assets/images/chapter.png',
                  label: 'Add Chapters', 
                ),
                const SizedBox(height: 20),
                AdminButtonWithDesign(
                  imageUrl:'assets/images/edit.png' ,
                  label: 'Update Tutorials',
                ),
                const SizedBox(height: 20),
                AdminButtonWithDesign(
                  imageUrl: 'assets/images/quest.png',
                  label: 'Update Questions',
                ),
                const SizedBox(height: 20),
                AdminButtonWithDesign(
                  imageUrl: 'assets/images/progress.png',
                  label: 'User Details &\n Students Evaluation',
                ),
                const SizedBox(height: 20),
                AdminButtonWithDesign(
                  imageUrl: 'assets/images/logout.png',
                  label: 'Log Out',
                ),
              ],
             ),
          ),
        ],
      ),
    );
  }
}


