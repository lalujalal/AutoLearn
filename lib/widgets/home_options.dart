import 'package:first_project/Screens/User/previous.dart';
import 'package:first_project/Screens/admin/add_chapter.dart';
import 'package:flutter/material.dart';

class AdminButtonWithDesign extends StatelessWidget {
  final String imageUrl;
  final String label;

  AdminButtonWithDesign({
    required this.imageUrl,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
         if (label == 'Add Chapters') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const AddChapter(),
          ));
         }else if (label == 'Log Out') {
          logoutPopup(context);
         }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color.fromARGB(255, 105, 105, 105),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Positioned(
                top: 5,
                left: 60,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 114, 114, 114),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: 25,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 114, 114, 114),
                  ),
                ),
              ),
              Positioned(
                right: 1,
                bottom: 5,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 114, 114, 114),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset(
                        imageUrl,
                        height: 35,
                        width: 35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logoutPopup(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:const Text('Logout Confirmation'),
        content:const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child:const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => PreviousPage()),
              );
            },
            child:const Text('OK'),
          ),
        ],
      );
    },
  );
}
