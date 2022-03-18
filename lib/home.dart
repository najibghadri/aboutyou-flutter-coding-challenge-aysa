import 'package:aboutyou/contacts.dart';
import 'package:aboutyou/grouped_list_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GroupedListView<String, String>(
          items: contacts,
          mapToGroup: (String contact) {
            return contact.characters.first;
          },
          itemBuilder: (BuildContext context, String contact, int index) {
            return ListTile(
              onTap: () {},
              title: Text(contact),
              leading: CircleAvatar(
                backgroundColor: Colors.brown.shade800,
                child: Text(contact.characters.first),
              ),
            );
          },
          groupHeaderBuilder: (BuildContext context, group, _) {
            return ListTile(
              leading: Text(group),
            );
          },
          preceedingWidgets: [
            ListTile(
              onTap: () {},
              title: const Text('Create new contact'),
              leading: const CircleAvatar(child: Icon(Icons.person_add)),
            ),
            ListTile(
              onTap: () {},
              title: const Text('Pin contact'),
              leading: const CircleAvatar(child: Icon(Icons.person_pin)),
            ),
          ],
          succeedingWidgets: [
            ListTile(
              onTap: () {},
              title: const Text('Backup all contacts'),
              leading: const CircleAvatar(child: Icon(Icons.upload)),
            ),
            ListTile(
              onTap: () {},
              title: const Text('Import contacts'),
              leading: const CircleAvatar(child: Icon(Icons.download)),
            ),
          ],
        ),
      ),
    );
  }
}
