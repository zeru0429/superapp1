import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as reorderable;
import 'package:superapp/apps/mezemur/components/unorder/UnorderList.dart';
import 'package:superapp/apps/mezemur/database/db_connection.dart';
import 'package:superapp/apps/mezemur/screen/LyricPage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class searchMezemur extends StatefulWidget {
  const searchMezemur({Key? key});

  @override
  State<searchMezemur> createState() => _searchMezemurState();
}

class _searchMezemurState extends State<searchMezemur> {
  late List<ItemData> _items;
  List<String> _categories2 = [];
  final List<String> imageAssets = [
    'assets/images/1.JPG',
    'assets/images/2.JPG',
    'assets/images/3.JPG',
    'assets/images/4.JPG',
    'assets/images/5.JPG',
    'assets/images/6.JPG',
    'assets/images/7.JPG',
    'assets/images/8.JPG',
    'assets/images/9.JPG',
    'assets/images/10.JPG',
    'assets/images/11.JPG',
    'assets/images/12.JPG',
    'assets/images/13.JPG',
    'assets/images/14.JPG',
    'assets/images/15.JPG',
    'assets/images/16.JPG',
    // 'assets/images/17.JPG',
    // Add more image asset paths as needed
  ];

  // late List<ItemData> _items;
  DraggingMode _draggingMode = DraggingMode.iOS;
  String? selectedCategory;
  String? selectedCategory2;
  String? selectedCategory3;
  String? searchQuery = '';

  @override
  void initState() {
    super.initState();
    _items = [];
    _fetchDataFromDatabase(
      categoryFilter: selectedCategory,
      categoryFilter2: selectedCategory2,
      categoryFilter3: selectedCategory3,
    );
    _fetchCategoryList();
  }

  Future<void> _fetchCategoryList() async {
    final dbHelper = DatabaseConnection();
    await dbHelper.setDatabase();

    try {
      final fetchedData2 = await dbHelper.getCategory2List();
      setState(() {
        _categories2 = fetchedData2
            .map((category) => category['category2'].toString())
            .toList();
      });
    } catch (e) {
      print('Error fetching category list: $e');
    }
  }

  Future<void> _fetchDataFromDatabase({
    String? categoryFilter,
    String? categoryFilter2,
    String? categoryFilter3,
  }) async {
    final dbHelper = DatabaseConnection();
    print("---------------------------------");
    print(categoryFilter);
    print(categoryFilter2);
    print(categoryFilter3);
    print("+++++++++++++++++++++++++++++++++");
    await dbHelper.setDatabase();

    try {
      final data = await dbHelper.listFilterData(
        categoryFilter: categoryFilter,
        categoryFilter2: categoryFilter2,
        categoryFilter3: categoryFilter3,
      );
      final favorites = await dbHelper.getFavorites();

      setState(() {
        _items = data.map((item) {
          final isFavorite =
              favorites.any((fav) => fav['mezmur_id'] == item['id']);
          return ItemData(
            item['id'],
            "${item['id']}, ${item['title']}",
            UniqueKey(),
            item['lyric'],
            isFavorite,
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _searchDataFromDatabase(String searchQuery) async {
    // print("-----------------object================");
    // print(searchQuery);
    final dbHelper = DatabaseConnection();
    await dbHelper.setDatabase();

    try {
      final data = await dbHelper.searchMezemur(searchQuery);
      final favorites = await dbHelper.getFavorites();

      setState(() {
        _items = data.map((item) {
          final isFavorite =
              favorites.any((fav) => fav['mezmur_id'] == item['id']);
          return ItemData(
            item['id'],
            "${item['id']}, ${item['title']}",
            UniqueKey(),
            item['lyric'],
            isFavorite,
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
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
    debugPrint("Reordering finished for ${draggedItem.title}}");
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

  final Random random = Random();
  @override
  Widget build(BuildContext context) {
    int randomIndex = random.nextInt(imageAssets.length);
    double fontSizeheight = MediaQuery.of(context).size.height * 0.018;
    double fontSizewidth = MediaQuery.of(context).size.width * 0.018;
    double fontSize2 = (fontSizeheight + fontSizewidth) / 2;
    double screenWidth = MediaQuery.of(context).size.width;
    double bannerSize = MediaQuery.of(context).size.height * 0.33;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownButton<String>(
                    value: selectedCategory3,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory3 = newValue;
                      });
                      _fetchDataFromDatabase(
                        categoryFilter: selectedCategory,
                        categoryFilter2: selectedCategory2,
                        categoryFilter3: selectedCategory3,
                      );
                    },
                    hint: Text(
                      'ጥራዝ',
                      style: TextStyle(fontSize: fontSize2),
                    ),
                    items: <String>['ጥራዝ 1', 'ጥራዝ 2', 'ጥራዝ 3', 'ጥራዝ 4']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: fontSize2),
                        ),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                      _fetchDataFromDatabase(
                        categoryFilter: selectedCategory,
                        categoryFilter2: selectedCategory2,
                        categoryFilter3: selectedCategory3,
                      );
                    },
                    hint: Text(
                      'ቋንቋ',
                      style: TextStyle(fontSize: fontSize2),
                    ),
                    items: <String>['ግዕዝ', 'አማርኛ', 'ኦሮምኛ', 'ወላይትኛ', 'ትግርኛ']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: fontSize2),
                        ),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: selectedCategory2,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory2 = newValue;
                      });
                      _fetchDataFromDatabase(
                        categoryFilter: selectedCategory,
                        categoryFilter2: selectedCategory2,
                        categoryFilter3: selectedCategory3,
                      );
                    },
                    hint: Text(
                      'ዘውግ',
                      style: TextStyle(fontSize: fontSize2),
                    ),
                    items: _categories2
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: fontSize2),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchDataFromDatabase(value);
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'ፈልግ',
                  hintText: 'አርስት',
                  border: OutlineInputBorder(),
                  isDense: true, // Reduces the height of the input field
                  contentPadding:
                      EdgeInsets.all(8.0), // Adjust padding as needed
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
                  SliverAppBar(
                    actions: <Widget>[
                      PopupMenuButton<DraggingMode>(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        initialValue: _draggingMode,
                        onSelected: (DraggingMode mode) {
                          setState(() {
                            _draggingMode = mode;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuItem<DraggingMode>>[
                          const PopupMenuItem<DraggingMode>(
                            value: DraggingMode.iOS,
                            child: Text('iOS-like dragging'),
                          ),
                          const PopupMenuItem<DraggingMode>(
                            value: DraggingMode.android,
                            child: Text('Android-like dragging'),
                          ),
                        ],
                      ),
                    ],
                    pinned: false,
                    expandedHeight: bannerSize,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(
                        imageAssets[
                            randomIndex], // Use the randomly selected image asset path
                        fit: BoxFit.cover,
                      ),
                      // title: Text('JIT Gbi Gubae It Team'),
                    ),
                  ),
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

class ItemData {
  ItemData(this.id, this.title, this.key, this.lyric, this.isFavorite);

  final int id;
  final String title;
  final Key key;
  final String lyric;
  bool isFavorite;
}
