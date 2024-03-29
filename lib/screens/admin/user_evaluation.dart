import 'package:first_project/Screens/User/statistics.dart';
import 'package:first_project/hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserEvaluation extends StatefulWidget {
  final int correctAnswersCount;
  final int incorrectAnswersCount;

  UserEvaluation({
    Key? key,
    required this.correctAnswersCount,
    required this.incorrectAnswersCount,
  }) : super(key: key);

  @override
  _UserEvaluationState createState() => _UserEvaluationState();
}

class _UserEvaluationState extends State<UserEvaluation> {
  late Box<User> userBox;
  late Box<Score> scoreBox;
  late Box<Question> questionBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<User>('user');
    scoreBox = Hive.box<Score>('score');
    questionBox = Hive.box<Question>('question');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 140,
        flexibleSpace: Ink(
          height: 130,
          decoration:const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            color: Color.fromARGB(255, 105, 105, 105),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/progress.png',
                    height: 50,
                    width: 45,
                  ),
                ),
              ),
              const SizedBox(width: 25),
              const Text(
                'User Details &\n Evaluation',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: _buildUserList(context),
    );
  }

Widget _buildUserList(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _loadUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading users: ${snapshot.error}'),
          );
        } else {
          List<User> users = snapshot.data ?? [];

          return users.isEmpty
              ? _buildNoUsersWidget()
              : _buildUsersListView(users);
        }
      },
    );
  }

  Widget _buildNoUsersWidget() {
    return const Padding(
      padding:EdgeInsets.all(18.0),
      child:Center(
        child: Text(
          'No users available.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildUsersListView(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        // Extract the first letter of the username
        String firstLetter = users[index].name.substring(0, 1).toUpperCase();
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(
              firstLetter,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(users[index].name, style: const TextStyle(color: Colors.black)),
          subtitle: Text(users[index].email, style: const TextStyle(color: Colors.black)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, users[index].userId);
                },
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart),
                onPressed: () {
                  _navigateToStatistics(context, users[index].userId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<User>> _loadUsers() async {
    try {
      // Check if the box is already open
      await Hive.openBox<User>('user');

      // Access the user box
      final Box<User> userBox = Hive.box<User>('user');

      // Load users from Hive
      List<User> users = userBox.values.toList();
      return users;
    } catch (error) {
      print('Error loading users: $error');
      return [];
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(context, userId);
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context, String userId) {
    // Delete user from Hive
    userBox.delete(userId);
    // Refresh the user list
    _reloadUsers(context);
  }

  void _reloadUsers(BuildContext context) {
    // Trigger a rebuild of the widget
    // You might want to use a state management solution for a more efficient way
    // This example uses a simplified approach for demonstration purposes
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => UserEvaluation(
          correctAnswersCount: widget.correctAnswersCount,
          incorrectAnswersCount: widget.incorrectAnswersCount,
        ),
      ),
    );
  }

  void _navigateToStatistics(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(
          scoreBox: scoreBox,
          questionBox: questionBox,
          userBox: userBox,
          correctAnswersCount: widget.correctAnswersCount,
          incorrectAnswersCount: widget.incorrectAnswersCount,
        ),
      ),
    );
  }
}