import 'package:flutter/material.dart';

import 'package:aboutyou/logic/models/contact.dart';

class ContactListItem extends StatelessWidget {
  ContactListItem({
    required this.contact,
    required this.isPinned,
    this.onTap,
    this.onPinTap,
    Key? key,
  }) : super(key: key);

  final Contact contact;
  final bool isPinned;
  void Function()? onTap;
  void Function()? onPinTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(contact.name),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade700,
        backgroundImage: NetworkImage(
          contact.avatarUrl + '?size=100x100',
        ),
      ),
      trailing: IconButton(
        onPressed: onPinTap,
        icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
      ),
    );
  }
}
