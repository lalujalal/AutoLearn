import 'dart:io';

import 'package:flutter/material.dart';

class ChapterEditButton extends StatelessWidget {
  final String iconImageUrl;
  final String buttonText;
  final Widget chapterScreen;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final bool showEditButton;
  final bool showDeleteButton;

  ChapterEditButton({
    required this.iconImageUrl,
    required this.buttonText,
    required this.chapterScreen,
    required this.onEditPressed,
    required this.onDeletePressed,
    this.showEditButton = false,
    this.showDeleteButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => chapterScreen,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xffE4DDDD),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.file(
              File(iconImageUrl),
              width: 75,
              height: 70,
            ),
            Text(
              buttonText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            if (showEditButton || showDeleteButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (showEditButton)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEditPressed,
                      
                    ),
                  if (showDeleteButton)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDeletePressed,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}