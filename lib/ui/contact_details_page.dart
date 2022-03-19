import 'package:aboutyou/data/contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactDetailsPage extends StatelessWidget {
  static Route route(int contactIndex) {
    return CupertinoPageRoute(
        builder: (_) => ContactDetailsPage(contactIndex: contactIndex));
  }

  final int contactIndex;

  const ContactDetailsPage({
    required this.contactIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contacts[contactIndex]),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage:
                    NetworkImage(avatars[contactIndex] + '?size=300x300'),
                backgroundColor: Colors.grey.shade700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
