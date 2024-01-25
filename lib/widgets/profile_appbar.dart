import 'dart:io';
import 'package:first_project/hive/hive.dart';
import 'package:first_project/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAppBar extends StatefulWidget {
  final String pageTitle;
  final double fontSize;
  final double topAlign;
  final double leftAlign;
  final Box<User> userBox;

  const ProfileAppBar({
    required this.pageTitle,
    required this.fontSize,
    required this.topAlign,
    required this.leftAlign,
    required this.userBox,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _pickedImage = null; // Initialize _pickedImage to null
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: const TopBar(),
        ),
        Positioned(
          bottom: 20,
          left: 140,
          child: GestureDetector(
            onTap: () {
              _pickImage();
            },
            child: ClipOval(
              child: Container(
                color: Colors.white,
                height: 94,
                width: 97,
                child: _pickedImage != null
                    ? Image.file(
                        File(_pickedImage!.path),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/demoimg.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
        Positioned(
          top: widget.topAlign,
          left: widget.leftAlign,
          child: Text(
            widget.pageTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }
}

class ProfileText extends StatelessWidget {
  final Box<User> userBox;

  const ProfileText({
    Key? key,
    required this.userBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = userBox.values.firstOrNull;

    return currentUser != null
        ? Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  currentUser.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  currentUser.email,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          )
        : const Center(
            child: Text(
              'User not found',
              style: TextStyle(fontSize: 16),
            ),
          );
  }
}
