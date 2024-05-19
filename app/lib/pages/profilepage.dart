import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sample_app/actions/user_provider.dart';

void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MaterialApp(
      home: profilepage(),
    ),
  ));
}

class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<profilepage> {
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    if (!userProvider.isUserLoaded) {
                      return CircularProgressIndicator();
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 50),
                            RandomAvatar(
                              DateTime.now().toIso8601String(),
                              height: 75,
                              width: 75,
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProvider.user['email'] ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '${userProvider.user['First Name'] ?? ''} ${userProvider.user['Last Name'] ?? ''}',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                                Text('Profile and Settings')
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        _buildProfileOption(
                          context,
                          'First Name',
                          userProvider.user['First Name'] ?? '',
                          userProvider.updateFirstName,
                        ),
                        _buildProfileOption(
                          context,
                          'Last Name',
                          userProvider.user['Last Name'] ?? '',
                          userProvider.updateLastName,
                        ),
                        _buildProfileOption(
                          context,
                          'Username',
                          userProvider.user['Username'] ?? '',
                          userProvider.updateUsername,
                        ),
                        _buildProfileOption(
                          context,
                          'Email',
                          userProvider.user['email'] ?? '',
                          (newValue) {
                            // Assume we have a method for updating email
                            userProvider.updateEmail(newValue);
                          },
                        ),
                        _buildProfileOption(
                          context,
                          'Birthday',
                          userProvider.user['birthday'] != null
                              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(userProvider.user['birthday']))
                              : '',
                          null,
                        ),
                      ],
                    );
                  },
                ),
                Expanded(child: Text('')),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 200, vertical: 30),
                          backgroundColor: const Color.fromRGBO(250, 128, 114, 1),
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lexend',
                          ),
                        ),
                        onPressed: () {
                          Provider.of<UserProvider>(context, listen: false).deleteUser(context);
                        },
                        child: Text('Delete Profile'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String title, String currentValue, Function(String)? onUpdate) {
    return SizedBox(
      height: 80,
      child: ElevatedButton.icon(
        icon: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.person_outlined, color: Color.fromRGBO(0, 148, 116, 1)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onUpdate != null
            ? () {
                _showUpdateDialog(context, title, currentValue, onUpdate);
              }
            : null,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    currentValue,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, String title, String currentValue, Function(String) onUpdate) {
    TextEditingController _controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update $title'),
          content: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'New $title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onUpdate(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
