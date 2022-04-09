import 'package:aboutyou/ui/components/contact_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:aboutyou/logic/contacts_notifier.dart';
import 'package:aboutyou/ui/contact_details_page.dart';

import 'components/grouped_list_view.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactsNotifier = useMemoized(() => ContactsNotifier());
    final contactStore = useValueListenable(contactsNotifier);

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
        contactsNotifier.filterContacts(textController.text);
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
            : [],
      ),
      body: SafeArea(
        child: Scrollbar(
          radius: const Radius.circular(10),
          child: GroupedListView<int, String>(
            needsSorting: false,
            items: contactStore.sortedContactIds,
            mapToGroup: (contactId) {
              return contactStore.contacts[contactId]!.name.characters.first;
            },
            itemBuilder: (BuildContext context, int contactId, int index) {
              final contact = contactStore.contacts[contactId]!;
              return ContactListItem(
                contact: contact,
                isPinned: contact.isPinned,
                onTap: () {
                  Navigator.of(context).push(ContactDetailsPage.route(contact));
                },
                onPinTap: () {
                  if (contact.isPinned) {
                    contactsNotifier.unpinContact(contact);
                  } else {
                    contactsNotifier.pinContact(contact);
                  }
                },
              );
            },
            groupHeaderBuilder: (BuildContext context, group, _) {
              return ListTile(
                leading: Text(group),
              );
            },
            preceedingWidgets: searchIsActive.value
                ? contactStore.contacts.isEmpty
                    ? [
                        const ListTile(
                          title: Text('No contact found'),
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
                    const Divider(),
                    ...(contactStore.pinnedContactIds.isEmpty
                        ? []
                        : [
                            ...contactStore.pinnedContactIds.map(
                              (contactId) {
                                final contact =
                                    contactStore.contacts[contactId]!;
                                return ContactListItem(
                                  contact: contact,
                                  isPinned: contact.isPinned,
                                  onTap: () {
                                    Navigator.of(context).push(
                                        ContactDetailsPage.route(contact));
                                  },
                                  onPinTap: () {
                                    if (contact.isPinned) {
                                      contactsNotifier.unpinContact(contact);
                                    } else {
                                      contactsNotifier.pinContact(contact);
                                    }
                                  },
                                );
                              },
                            ),
                            const Divider(),
                          ])
                  ],
            succeedingWidgets: searchIsActive.value
                ? null
                : [
                    const Divider(),
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
