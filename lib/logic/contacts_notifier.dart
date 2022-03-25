import 'package:aboutyou/data/contacts.dart';
import 'package:flutter/foundation.dart';

import 'models/contact.dart';
import 'models/contacts_store.dart';

// We could use StateNotifier if we want to use provider or riverpod too

class ContactsNotifier extends ValueNotifier<ContactStore> {
  ContactsNotifier() : super(ContactStore.empty) {
    /// Ideally the whole contacts list and pinned contacts list
    /// come from a local database through and API that allows for pinning/unpinning

    value = ContactStore(
      contacts: contacts,
      sortedContactIds: sortedContactIds,
      pinnedContactIds: const [],
    );
  }

  void filterContacts(String? searchTerm) {
    if (searchTerm == null) {
      value = value.copyWith(sortedContactIds: sortedContactIds);
      return;
    }
    final filteredContacts = sortedContactIds
        .where(
          (contactId) => contacts[contactId]!
              .name
              .toLowerCase()
              .contains(searchTerm.toLowerCase()),
        )
        .toList(growable: false);

    value = value.copyWith(sortedContactIds: filteredContacts);
  }

  // ideally this changes a local or cloud db as well as a local one optmisitically
  void pinContact(Contact contact) {
    final pinnedContactIds = [...value.pinnedContactIds, contact.id];

    value.contacts.update(
        contact.id,
        (c) => Contact(
            id: c.id, name: c.name, avatarUrl: c.avatarUrl, isPinned: true));
    final newContacts = {...value.contacts};

    value = value.copyWith(
        pinnedContactIds: pinnedContactIds, contacts: newContacts);
  }

  void unpinContact(Contact contact) {
    final pinnedContactIds = [...value.pinnedContactIds];
    pinnedContactIds.removeWhere((id) => id == contact.id);

    value.contacts.update(
        contact.id,
        (c) => Contact(
            id: c.id, name: c.name, avatarUrl: c.avatarUrl, isPinned: false));
    final newContacts = {...value.contacts};

    value = value.copyWith(
        pinnedContactIds: pinnedContactIds, contacts: newContacts);
  }
}
