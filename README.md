Flutter Coding Challenge
========================

**Given a list of contact names (as `List<String>` for demo purposes), render an address book list where the names are grouped by their first character.**

* Implementation should be done in its own Widget
* We expect a GroupedListView widget which receives the items
* Make this widget generic and be able to work with any data type, given the appropriate builder is provided
* It should be a single, continuous list widget
* Preferably this scroll view should be using Slivers
* In the end, all data should be displayed in one continuous scrolling list
* Only visible items should be rendered
* Expect huge amounts of test data and a requirement to show images next to each contact
* Use any styling you want, stock Material widgets are fine
* Only show groups that have entries
* Each entry should be tappable (next screen may just show the name in “detail view”)

**In addition to these basic requirements, we’d like to see you implement the following additional features:**

* There should be the ability to show widgets on top and below the list
* For this challenge, we only want to inject a vertical list of buttons
*  A search field should be provided to filter down the list
* When a search is active, the additional widgets should be hidden
* Describe why a Scroll to index API is not as straightforward with normal ListView or Sliver widgets in the README of the project

_Please finish your coding challenge with a short README outlining your thinking behind the implementation and any open issues you would want to explore if there were more time._

# Sample Input: #

```dart
final contacts = <String>[
    'Adi Shamir',
    'Alan Kay',
    'Andrew Yao',
    'Barbara Liskov',
    'Kristen Nygaard',
    'Leonard Adleman',
    'Leslie Lamport',
    'Ole-Johan Dahl',
    'Peter Naur',
    'Robert E. Kahn',
    'Ronald L. Rivest',
    'Vinton G. Cerf',
];
```