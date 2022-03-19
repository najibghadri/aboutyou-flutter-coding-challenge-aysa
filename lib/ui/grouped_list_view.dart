import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GroupedListView<I, G> extends HookWidget {
  /// Items that will be rendered by [itemBuilder]
  final List<I> items;

  /// This function maps an item to it's group. It's called for each item, when
  /// the group is equal for two items, they belong in the same group
  final G Function(I item) mapToGroup;

  final int Function(G g1, G g2)? groupComparator;

  final int Function(I i1, I i2)? itemComparator;

  final Widget Function(BuildContext context, G group, I firstItem)
      groupHeaderBuilder;

  final Widget Function(BuildContext context, I item, int index) itemBuilder;

  final bool needsSorting;

  final List<Widget>? preceedingWidgets;

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
      // Sort all items if needed. If the list is filtered for search f.ex.
      // this will still re sort the new items list even if it's already sorted.
      // In that case it's better to pass a sorted [items] list and needsSorting=false
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
