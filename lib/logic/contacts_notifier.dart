import 'package:aboutyou/data/contacts.dart';
import 'package:flutter/foundation.dart';

import 'models/contact.dart';
import 'models/contacts_store.dart';

// We could use StateNotifier if we want to use provider or riverpod too

class ContactsNotifier extends ValueNotifier<ContactStore> {
  ContactsNotifier() : super(ContactStore.empty) {
    /// Ideally the whole contacts list and pinned contacts list
    /// come from a local database through and API that allows for pinning/unpinning

    /// To use huge list of 5000 users comment out the following line:
    contacts = contacts.sublist(0, 50);
    contacts.sort(((a, b) => a.name.compareTo(b.name)));

    value = ContactStore(
      contacts: [...contacts],
      pinnedContacts: const [],
    );
  }

  void filterContacts(String? searchTerm) {
    if (searchTerm == null) {
      value = value.copyWith(contacts: contacts);
      return;
    }
    final filteredContacts = contacts
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(searchTerm.toLowerCase()),
        )
        .toList(growable: false);

    value = value.copyWith(contacts: filteredContacts);
  }

  // ideally this changes a local or cloud db as well as a local one optmisitically
  void pinContact(Contact contact) {
    final pinnedContacts = [...value.pinnedContacts, contact];
    value = value.copyWith(pinnedContacts: pinnedContacts);
  }

  void unpinContact(Contact contact) {
    final pinnedContacts = [...value.pinnedContacts];
    pinnedContacts.removeWhere((c) => c.id == contact.id);

    value = value.copyWith(pinnedContacts: pinnedContacts);
  }
}
