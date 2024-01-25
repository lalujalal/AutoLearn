import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            Container(
            decoration:const BoxDecoration(
              color:  Color(0xff6A6C73),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
              )
            ),
          ),
          const Positioned(
            top: -20,left: 60,
            child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 125, 126, 128),
            radius: 60,
            )),
            const Positioned(
            top: 25,right: 50,
            child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 125, 126, 128),
            radius: 30,
            )),
            const Positioned(
            bottom: -20,right: 20,
            child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 125, 126, 128),
            radius: 40,
            )),
            const Positioned(
            top: 38,left: -20,
            child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 125, 126, 128),
            radius: 35,
            )),
          ],
        ); 
  }
}