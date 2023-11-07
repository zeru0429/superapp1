import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as reorderable;
import 'package:superapp/apps/mezemur/database/db_connection.dart';
import 'package:superapp/apps/mezemur/screen/LyricPage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Catagory1List extends StatefulWidget {
  const Catagory1List({
    Key? key,
    required this.title,
    required bool isFirstLaunch,
  }) : super(key: key);

  final String title;

  @override
  _Catagory1ListState createState() => _Catagory1ListState();
}

class ItemData {
  ItemData(this.id, this.title, this.key, this.lyric, this.isFavorite);

  final int id;
  final String title;
  final Key key;
  final String lyric;
  bool isFavorite;
}

enum DraggingMode {
  iOS,
  android,
}

class _Catagory1ListState extends State<Catagory1List> {
  late List<ItemData> _originalItems;
  late List<ItemData> _items;
  DraggingMode _draggingMode = DraggingMode.iOS;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _originalItems = [];
    _items = [];
    _fetchDataFromDatabase();
  }

  Future<void> _fetchDataFromDatabase() async {
    final dbHelper = DatabaseConnection();
    await dbHelper.setDatabase();
    try {
      final data = await dbHelper.listCatagorizedData(widget.title);
      final favorites = await dbHelper.getFavorites();

      setState(() {
        _originalItems = data.map((item) {
          final isFavorite =
              favorites.any((fav) => fav['mezmur_id'] == item['id']);
          return ItemData(item['id'], "${item['id']}, ${item['title']}",
              UniqueKey(), item['lyric'], isFavorite);
        }).toList();

        // Initially, _items should contain the same data as _originalItems
        _items = List.from(_originalItems);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _searchDataFromDatabase(String query) {
    final dbHelper = DatabaseConnection();
    final filteredItems = _originalItems.where((item) {
      final title = item.title.toLowerCase();
      final lowerQuery = query.toLowerCase();
      return title.contains(lowerQuery);
    }).toList();

    setState(() {
      searchQuery = query;
      _items = filteredItems;
    });
  }

  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}");
  }

  void _toggleFavorite(ItemData item) async {
    final dbHelper = DatabaseConnection();
    final isFavorite = await dbHelper.isFavorite(item.id);

    if (isFavorite) {
      await dbHelper.removeFavorite(item.id);
    } else {
      await dbHelper.addFavorite(item.id);
    }

    setState(() {
      item.isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchDataFromDatabase(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ፈልግ',
                  hintText: 'አርስት',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: reorderable.ReorderableList(
              onReorder: _reorderCallback,
              onReorderDone: _reorderDone,
              child: CustomScrollView(
                slivers: <Widget>[
                  // ... SliverAppBar and other widgets ...
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Item(
                            data: _items[index],
                            isFirst: index == 0,
                            isLast: index == _items.length - 1,
                            draggingMode: _draggingMode,
                            toggleFavorite: _toggleFavorite,
                          );
                        },
                        childCount: _items.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.draggingMode,
    required this.toggleFavorite,
  }) : super(key: key);

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;
  final Function(ItemData) toggleFavorite;

  Widget _buildChild(
      BuildContext context, reorderable.ReorderableItemState state) {
    final fontSize = MediaQuery.of(context).size.width *
        0.035; // Calculate font size as 3% of screen width

    final decoration = state == reorderable.ReorderableItemState.dragProxy ||
            state == reorderable.ReorderableItemState.dragProxyFinished
        ? const BoxDecoration(color: Color(0xFFE6F374))
        : BoxDecoration(
            border: Border(
              top: isFirst &&
                      state != reorderable.ReorderableItemState.placeholder
                  ? Divider.createBorderSide(context)
                  : BorderSide.none,
              bottom: isLast &&
                      state == reorderable.ReorderableItemState.placeholder
                  ? BorderSide.none
                  : Divider.createBorderSide(context),
            ),
            color: state == reorderable.ReorderableItemState.placeholder
                ? null
                : const Color(0xFFCCE6E9),
          );

    Widget favoriteIcon = Icon(
      data.isFavorite ? Icons.favorite : Icons.favorite_border,
      color: Colors.red, // Customize the icon color
    );

    favoriteIcon = GestureDetector(
      onTap: () {
        toggleFavorite(data); // Call the toggleFavorite function
      },
      child: favoriteIcon,
    );

    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? reorderable.ReorderableListener(
            child: Container(
              padding: const EdgeInsets.only(right: 18.0, left: 18.0),
              color: const Color(0x08000000),
              child: const Center(
                child: Icon(Icons.reorder,
                    color: Color.fromRGBO(26, 144, 157, 1.0)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Opacity(
          opacity:
              state == reorderable.ReorderableItemState.placeholder ? 0.0 : 1.0,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 14.0),
                    child: Text(
                      data.title,
                      style: TextStyle(
                        fontFamily:
                            "jiret", // Replace with the actual custom font name
                        fontSize: fontSize,
                        fontWeight:
                            FontWeight.bold, // Adjust the font weight as needed
                      ),
                    ),
                  ),
                ),
                favoriteIcon, // Add the favorite icon here
                dragHandle,
              ],
            ),
          ),
        ),
      ),
    );

    if (draggingMode == DraggingMode.android) {
      content = reorderable.DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LyricPage(
              id: data.title,
              lyric: data.lyric,
              isFav: data.isFavorite,
            ),
          ),
        );
      },
      child: reorderable.ReorderableItem(
        key: data.key,
        childBuilder: _buildChild,
      ),
    );
  }
}
