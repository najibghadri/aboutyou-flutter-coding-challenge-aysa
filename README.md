# About You Flutter homework

https://user-images.githubusercontent.com/11639734/159179579-d5452bc5-769b-48ad-b12c-a9e976d81ee6.mov

`GroupedListView` renders a list view that groups items with a generic and easy-to-use api. Allows for inserting widgets before and after the list view.

### Parameters:
| Name | Description | Required | Default value |
|----|----|----|----|
|`items`| Items that will be rendered by `itemBuilder` | required | - |
|`itemBuilder`| Called when building an item.| required | - |
|`groupHeaderBuilder`| Called when building the header of a group.| required | - |
|`mapToGroup` | This function maps an item to its group. It is called for each item. When the group is equal for two items, they belong in the same group. | required | - |
|`itemComparator`| Optional: Needed if `needsSorting` is true and Item type is not a Comparable. no | - |
|`groupComparator`| Optional: Needed if Group type is not a Comparable.| no | - |
|`needsSorting`| Sort the provided `items` or not. If the `items` list is modified frequently, but keeps sorting (filtered for search for example) then it's better to pass `items` already sorted and set `needsSorting` to false to avoid unnecessary sorts which decrease performance. | no | true |
|`preceedingWidgets`|  Optional. List of widgets to insert before the grouped list view| no | - |
|`succeedingWidgets`|  Optional. List of widgets to insert after the grouped list view| no | - |

### Implementation

- `GroupedListView`'s implementation one file that lives inside the main app package. It could be package that's then imported to the main app.
- I used `flutter_hooks`, a great package that brings hooks to flutter like they are in React, and it allows for much cleaner code and reusability.
- `GroupedListView` extends a `HookWidget` that uses a `useState` and a `useEffect` in case `needsSorting` is true, otherwise it behaves like a plain `StatelessWidget`.
- If `needsSorting` is kept true then whenever `items` parameter changes the component will sort it. This can be a performance issue as described above.
- It uses `CustomScrollView` and Slivers to combine the large items list and the optional preceeding and succeeding widget lists.
- There is no preprocessing of the `items` list, meaning there is no itermediary list that combines group headers and items. The list is generated on-the-fly with a trick: in reality what's rendered is a list twice as large as `items`, where for even indices either a group header is built or a zero sized `SizedBox.shrink` depending on whether there is a difference between the current and previous item's group, and for odd indices the actual item's builder is called.

### Testing
- I created a dataset of 5000 names and avatar urls. This can be tested by uncommenting [home_page.dart#L18](https://github.com/najibghadri/aboutyou-flutter-coding-challenge-aysa/blob/coding-challenge/lib/ui/home_page.dart#L18)
- Using Material components I made a HomePage that uses stock ListTiles, TextField and IconButton.
- It is also a `HookWidget`:
- it uses a useEffect to sort the large (or small) list of contacts instead of letting `GroupedListView` sort it. 
- It uses useState, useFocusNode, useTextEditingController and useEffect to implement an interactive search. When the TextField in AppBar is focused then `searchIsActive` is true and the additional button widgets aren't provided to `GroupedListView` and the list is filtered with the value of the search text controller.
- When the value of the text field is changed then the list is filtered, but not sorted again, hence keeping good performance.
- A cancel button is added to the appbar in active search that clears the text, unfocuses and deactives search.

### Further work
- Implementing a scrollToIndex api would be interesting
- Adding a draggable scrollbar would improve UX greatly, like https://pub.dev/packages/draggable_scrollbar
- 
