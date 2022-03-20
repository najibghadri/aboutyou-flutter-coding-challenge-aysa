# About You Flutter homework

https://user-images.githubusercontent.com/11639734/159179579-d5452bc5-769b-48ad-b12c-a9e976d81ee6.mov

`GroupedListView` is a generic grouped list view with a well-documented easy to use api:

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
