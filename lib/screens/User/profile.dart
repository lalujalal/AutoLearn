import 'package:first_project/Screens/User/previous.dart';
import 'package:first_project/Screens/User/profile_updatepass.dart';
import 'package:first_project/Screens/User/updateprofile_name.dart';
import 'package:first_project/widgets/profile_appbar.dart';
import 'package:flutter/material.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Box<User> userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<User>('user');
    openUserBox();
  }

  Future<void> openUserBox() async {
    await Hive.openBox<User>('user');
    // Set userBox in the setState callback
    setState(() {
      userBox = Hive.box<User>('user');
    });
  }

  List<String> title = ['Change name', 'Change Password', 'Logout'];
  List<IconData> icons = [Icons.person, Icons.password, Icons.logout_outlined];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 190,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ProfileAppBar(
          pageTitle: 'Profile',
          fontSize: 24,
          topAlign: 60,
          leftAlign:MediaQuery.of(context).size.width / 2 - 40,
           userBox: userBox 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: FutureBuilder<void>(
            future: Future.delayed(Duration.zero), 
          builder: (context, snapshot) {
              return Column(
                children: [
                  ProfileText(userBox: userBox),
                  const SizedBox(height: 40),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: title.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            title[index],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(icons[index]),
                          onTap: () {
                            handleTileTap(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
          },
        ),
      ),
    );
  }

  void handleTileTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UpdateName()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UpdatePassword()),
        );
        break;
      case 2:
        logoutPopup();
        break;
      default:
        break;
    }
  }

  void logoutPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel',style: TextStyle(color: Color(0xff438883))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => PreviousPage()),
                );
              },
              child: const Text('OK',style: TextStyle(color: Color(0xff438883)),),
            ),
          ],
        );
      },
    );
  }
}


