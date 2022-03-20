import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Renders a list view that groups items with a generic api.
/// Allows for inserting widgets before and after the list view.
class GroupedListView<I, G> extends HookWidget {
  /// Items that will be rendered by [itemBuilder]
  final List<I> items;

  /// This function maps an item to its group. It is called for each item. When
  /// the group is equal for two items, they belong in the same group.
  final G Function(I item) mapToGroup;

  /// Optional: Needed if Group type is not a Comparable.
  final int Function(G g1, G g2)? groupComparator;

  /// Optional: Needed if [needsSorting] = true and Item type is not a Comparable.
  final int Function(I i1, I i2)? itemComparator;

  /// Called when building the header of a group.
  final Widget Function(BuildContext context, G group, I firstItem)
      groupHeaderBuilder;

  /// Called when building an item.
  final Widget Function(BuildContext context, I item, int index) itemBuilder;

  /// Sort the provided [items] or not. If the [items] list is modified frequently,
  /// but keeps sorting (filtered for search for example) then it's better to pass
  /// [items] already sorted and set [needsSorting] to false to avoid unnecessary sorts
  /// which decrease performance.
  final bool needsSorting;

  /// Optional. List of widgets to insert before the grouped list view
  final List<Widget>? preceedingWidgets;

  /// Optional. List of widgets to insert after the grouped list view
  final List<Widget>? succeedingWidgets;

  const GroupedListView({
    required this.items,
    required this.mapToGroup,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    this.preceedingWidgets,
    this.succeedingWidgets,
    this.groupComparator,
    this.itemComparator,
    this.needsSorting = true,
    Key? key,
  }) : super(key: key);

  _isGroupHeaderIndex(int i) {
    return i.isEven;
  }

  _groupsNotEqual(G g1, G? g2) {
    if (g2 == null) return true;
    if (groupComparator != null) {
      return groupComparator!(g1, g2) != 0;
    } else if (g1 is Comparable) {
      return g1.compareTo(g2) != 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedItems = useState<List<I>>([]);

    useEffect(() {
      if (needsSorting) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          items.sort((i1, i2) {
            if (itemComparator != null) {
              return itemComparator!(i1, i2);
            } else if (i1 is Comparable) {
              return i1.compareTo(i2);
            } else {
              return 0;
            }
          });
          sortedItems.value = items;
        });
      }
    }, [items]);

    // If the received [items] list is already sorted we use it directly, otherwise we use the sorted list
    final itemsList = needsSorting ? sortedItems.value : items;

    return CustomScrollView(
      slivers: [
        ...(preceedingWidgets == null
            ? []
            : [
                SliverList(
                  delegate: SliverChildListDelegate(preceedingWidgets!),
                ),
              ]),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final itemindex = index ~/ 2;
              final item = itemsList[itemindex];

              if (_isGroupHeaderIndex(index)) {
                var currentGroup = mapToGroup(item);
                var previousGroup = itemindex == 0
                    ? null
                    : mapToGroup(itemsList[itemindex - 1]);
                if (_groupsNotEqual(currentGroup, previousGroup)) {
                  return groupHeaderBuilder(context, currentGroup, item);
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return itemBuilder(context, item, itemindex);
              }
            },
            childCount: itemsList.length * 2,
          ),
        ),
        ...(succeedingWidgets == null
            ? []
            : [
                SliverList(
                  delegate: SliverChildListDelegate(succeedingWidgets!),
                ),
              ]),
      ],
    );
  }
}
