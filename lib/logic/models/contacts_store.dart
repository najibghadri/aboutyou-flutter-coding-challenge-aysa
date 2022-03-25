import 'package:equatable/equatable.dart';

import 'contact.dart';

class ContactStore extends Equatable {
  final List<Contact> contacts;
  final List<Contact> pinnedContacts;

  const ContactStore({
    required this.contacts,
    required this.pinnedContacts,
  });

  static const empty = ContactStore(
    contacts: [],
    pinnedContacts: [],
  );

  @override
  List<Object?> get props => [
        contacts,
        pinnedContacts,
      ];

  ContactStore copyWith({
    List<Contact>? contacts,
    List<Contact>? pinnedContacts,
  }) {
    return ContactStore(
      contacts: contacts ?? this.contacts,
      pinnedContacts: pinnedContacts ?? this.pinnedContacts,
    );
  }
}
