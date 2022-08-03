import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OLBS'),
        centerTitle: true,

        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Center(child: Text('Are You Sure')),
                      content: const Text('Do You want to Log out'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (ctx) {
                                    return const LoginScreen();
                                  }));
                            },
                            child: const Text('yes')),
                      ],
                    );
                  });
            },
            child: const Icon(Icons.logout),
          )
        ],



      ),
      body: Placeholder(),
    );
  }
}
