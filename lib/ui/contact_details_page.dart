import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aboutyou/logic/models/contact.dart';

class ContactDetailsPage extends StatelessWidget {
  static Route route(Contact contact) {
    return CupertinoPageRoute(
        builder: (_) => ContactDetailsPage(contact: contact));
  }

  final Contact contact;

  const ContactDetailsPage({
    required this.contact,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
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
                    NetworkImage(contact.avatarUrl + '?size=300x300'),
                backgroundColor: Colors.grey.shade700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
