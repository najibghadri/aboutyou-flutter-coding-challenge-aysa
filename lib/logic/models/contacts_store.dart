import 'package:equatable/equatable.dart';

import 'contact.dart';

class ContactStore extends Equatable {
  final Map<int, Contact> contacts;
  final List<int> sortedContactIds;
  final List<int> pinnedContactIds;

  const ContactStore({
    required this.contacts,
    required this.sortedContactIds,
    required this.pinnedContactIds,
  });

  static const empty = ContactStore(
    contacts: {},
    sortedContactIds: [],
    pinnedContactIds: [],
  );

  @override
  List<Object?> get props => [
        contacts,
        sortedContactIds,
        pinnedContactIds,
      ];

  ContactStore copyWith({
    Map<int, Contact>? contacts,
    List<int>? sortedContactIds,
    List<int>? pinnedContactIds,
  }) {
    return ContactStore(
      contacts: contacts ?? this.contacts,
      sortedContactIds: sortedContactIds ?? this.sortedContactIds,
      pinnedContactIds: pinnedContactIds ?? this.pinnedContactIds,
    );
  }
}
