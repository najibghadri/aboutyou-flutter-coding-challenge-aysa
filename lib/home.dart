import 'package:aboutyou/contacts.dart';
import 'package:aboutyou/grouped_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedContacts = useState(<String>[]);
    final filteredContacts = useState(<String>[]);

    useEffect(() {
      // To use huge list of 5000 users comment out the following line:
      contacts = contacts.sublist(0, 50);

      contacts.sort();
      sortedContacts.value = contacts;
      filteredContacts.value = contacts;
    }, []);

    final textController = useTextEditingController();
    final focusNode = useFocusNode();
    final searchIsActive = useState(false);

    useEffect(() {
      focusListener() {
        searchIsActive.value = focusNode.hasFocus;
      }

      focusNode.addListener(focusListener);
      return () => focusNode.removeListener(focusListener);
    }, []);

    useEffect(() {
      filterSearch() {
        filteredContacts.value = sortedContacts.value
            .where((contact) => contact
                .toLowerCase()
                .contains(textController.text.toLowerCase()))
            .toList(growable: false);
      }

      textController.addListener(filterSearch);
      return () => textController.removeListener(filterSearch);
    }, []);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextField(
          controller: textController,
          focusNode: focusNode,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            icon: Icon(Icons.search, color: Colors.white),
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white60),
          ),
        ),
        actions: searchIsActive.value
            ? [
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  onPressed: () {
                    textController.clear();
                    focusNode.unfocus();
                  },
                )
              ]
            : null,
      ),
      body: SafeArea(
        child: Scrollbar(
          radius: const Radius.circular(10),
          child: GroupedListView<String, String>(
            needsSorting: false,
            items: filteredContacts.value,
            mapToGroup: (String contact) {
              return contact.characters.first;
            },
            itemBuilder: (BuildContext context, String contact, int index) {
              return ListTile(
                onTap: () {},
                title: Text(contact),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade700,
                  backgroundImage: NetworkImage(
                    avatars[index],
                  ),
                ),
              );
            },
            groupHeaderBuilder: (BuildContext context, group, _) {
              return ListTile(
                leading: Text(group),
              );
            },
            preceedingWidgets: searchIsActive.value
                ? filteredContacts.value.isEmpty
                    ? [
                        const ListTile(
                          title: Text('No contacts found'),
                        ),
                      ]
                    : null
                : [
                    ListTile(
                      onTap: () {},
                      title: const Text('Create new contact'),
                      leading:
                          const CircleAvatar(child: Icon(Icons.person_add)),
                    ),
                    ListTile(
                      onTap: () {},
                      title: const Text('Pin contact'),
                      leading:
                          const CircleAvatar(child: Icon(Icons.person_pin)),
                    ),
                  ],
            succeedingWidgets: searchIsActive.value
                ? null
                : [
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
      ),
    );
  }
}
