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
- I created a dataset of 5000 names and avatar urls. By default a sublist of 50 contacts is used. The large list can be tested by uncommenting [home_page.dart#L18](https://github.com/najibghadri/aboutyou-flutter-coding-challenge-aysa/blob/coding-challenge/lib/ui/home_page.dart#L18)
- Using Material components I made a HomePage that uses stock ListTiles, TextField and IconButton.
- It is also a `HookWidget`:
  - it uses a useEffect to sort the large (or small) list of contacts instead of letting `GroupedListView` sort it. 
  - it uses useState, useFocusNode, useTextEditingController and useEffect to implement an interactive search. When the TextField in AppBar is focused then `searchIsActive` is true and the additional button widgets aren't provided to `GroupedListView` and the list is filtered with the value of the search text controller.
- When the value of the text field is changed then the list is filtered, but not sorted again, hence keeping good performance.
- A cancel button is added to the appbar in active search that clears the text, unfocuses and deactives search.

### Further work
- Implementing a scrollToIndex api would be interesting
- Adding a draggable scrollbar would improve UX greatly, like https://pub.dev/packages/draggable_scrollbar
- In https://capsulechat.com/ I have implemented a similar component for listing messages and a group header for each new day. I've also used `CustomScrollView` but there is preprocessing to an intermediary list. Additionally I implemented a `onReachingTop` api using `ScrollNotification` that helps in pagination loading and also `onFirstItemIndexChanged` which returns the index of the items that's currently visible on the top of the scrollview's viewport. This helps in showing a fixed floating header of the current day 👍. It uses `findRenderObject` and `localToGlobal` apis.

## About scrollToIndex api

- In short a scrollToIndex api for Flutter's ListView isn't possible because the height of each list items isn't known before actually rendering them. Since ListView's good performance comes from not rendering items that aren't visible, it won't know the height of all items.
- This was actually a long conversation in this issue: https://github.com/flutter/flutter/issues/12319. The community missed this feature as it was present in Android and iOS Swift. The request wasn't implemented into ListView because the pixel based api conflicts with the index based api.
- Workarounds:
  - If the height of the items is known (for example in a contacts list, where each ListTile has a fixed height) we could use ListView's (ScrollableController's) jumpTo(pixelOffset) or animateTo(pixelOffset) methods, as such: https://stackoverflow.com/a/58435822/6585695
  - If the height is not fixed, then ListView's scrollController won't work. In that case one of the provided soltions to the issue above will work, such as
  - https://pub.dev/packages/indexed_list_view or https://pub.dev/packages/scrollable_positioned_list. Both of these use rendering tricks. `ScrollablePositionedList` exposes a `itemScrollController` which has jumpTo(index) and scrollTo(index) methods. Looking at the implementation we can see that `jumpTo` simply renders the items near that index while `scrollTo` also uses a secondary Sliver list.
