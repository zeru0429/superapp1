import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:superapp/apps/mezemur/database/data/data1.dart';
import 'package:superapp/apps/mezemur/database/data/data2.dart';
import 'package:superapp/apps/mezemur/database/data/data3.dart';

class DatabaseConnection {
  // db install
  Future<Database> setDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mezemur_app.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Mezemur (id INTEGER PRIMARY KEY, title TEXT, category1 TEXT, category2 TEXT, category3 TEXT, lyric TEXT)');

      await db.execute(
          'CREATE TABLE Favorites (id INTEGER PRIMARY KEY, mezmur_id INTEGER)');
    });
    return database;
  }

  //get all language
  Future<List<Map<String, dynamic>>> getCategory1List() async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT DISTINCT category1 FROM Mezemur');
    return list;
  }

  //get all genera
  Future<List<Map<String, dynamic>>> getCategory2List() async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT DISTINCT category2 FROM Mezemur');
    return list;
  }

  //get all tiraz
  Future<List<Map<String, dynamic>>> getCategory3List() async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT DISTINCT category3 FROM Mezemur');
    return list;
  }

  // add to fav
  Future<void> addFavorite(int mezmurId) async {
    Database db = await setDatabase();
    await db.insert('Favorites', {'mezmur_id': mezmurId});
    print('$mezmurId added sucessfully');
  }

  // remove to fav
  Future<void> removeFavorite(int mezmurId) async {
    Database db = await setDatabase();
    await db.delete('Favorites', where: 'mezmur_id = ?', whereArgs: [mezmurId]);
    print('$mezmurId removed sucessfully');
  }

  // get all fav list
  Future<List<Map<String, dynamic>>> getFavorites() async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list = await db.query('Favorites');
    return list;
  }

  // check if it is fav
  Future<bool> isFavorite(int mezmurId) async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> result = await db
        .query('Favorites', where: 'mezmur_id = ?', whereArgs: [mezmurId]);
    return result.isNotEmpty;
  }

  // listing all mezemur
  Future<List<Map<String, dynamic>>> listData() async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM Mezemur ORDER BY title');
    return list;
  }

  Future<List<Map<String, dynamic>>> listSinglemezemur(int id) async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM Mezemur WHERE id = ?', [id]);
    return list;
  }

// listing all catagory1 mezemur
  Future<List<Map<String, dynamic>>> listCatagorizedData(
      String category1) async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list = await db.rawQuery(
        'SELECT * FROM Mezemur WHERE category1 = ? ORDER BY title',
        [category1]);
    return list;
  }

// listing all catagory2 mezemur
  Future<List<Map<String, dynamic>>> listCatagorized2Data(
      String category2) async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list = await db.rawQuery(
        'SELECT * FROM Mezemur WHERE category2 = ? ORDER BY title',
        [category2]);
    return list;
  }

// listing all catagory3 mezemur
  Future<List<Map<String, dynamic>>> listFavData() async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list = await db.rawQuery('''
    SELECT * FROM Mezemur
    WHERE id IN (
      SELECT mezmur_id FROM Favorites
    )
  ''');
    return list;
  }

  Future<List<Map<String, dynamic>>> listFilterData({
    String? categoryFilter,
    String? categoryFilter2,
    String? categoryFilter3,
    String? titleQuery,
  }) async {
    final db = await setDatabase();

    if (categoryFilter != null &&
        categoryFilter2 != null &&
        categoryFilter3 != null) {
      return db.query(
        'Mezemur',
        where:
            'category1 = ? AND category2 = ? AND category3 = ? ORDER BY title',
        whereArgs: [categoryFilter, categoryFilter2, categoryFilter3],
      );
    } else if (categoryFilter2 != null && categoryFilter3 != null) {
      return db.query(
        'Mezemur',
        where: 'category2 = ? AND category3 = ? ORDER BY title',
        whereArgs: [categoryFilter2, categoryFilter3],
      );
    } else if (categoryFilter != null && categoryFilter2 != null) {
      return db.query(
        'Mezemur',
        where: 'category1 = ? AND category2 = ? ORDER BY title',
        whereArgs: [categoryFilter, categoryFilter2],
      );
    } else if (categoryFilter != null && categoryFilter3 != null) {
      return db.query(
        'Mezemur',
        where: 'category1 = ? AND category3 = ? ORDER BY title',
        whereArgs: [categoryFilter, categoryFilter3],
      );
    } else if (categoryFilter != null) {
      return db.query(
        'Mezemur',
        where: 'category1 = ? ORDER BY title',
        whereArgs: [categoryFilter],
      );
    } else if (categoryFilter2 != null) {
      return db.query(
        'Mezemur',
        where: 'category2 = ? ORDER BY title',
        whereArgs: [categoryFilter2],
      );
    } else if (categoryFilter3 != null) {
      return db.query(
        'Mezemur',
        where: 'category3 = ? ORDER BY title',
        whereArgs: [categoryFilter3],
      );
    } else {
      return db.query('Mezemur');
    }
  }

  Future<List<Map<String, dynamic>>> searchMezemur(String? query) async {
    Database db = await setDatabase();
    List<Map<String, dynamic>> list = await db.query(
      'Mezemur',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return list;
  }

// //insertion
  Future<void> insertData() async {
    Database db = await setDatabase();
    await db.transaction((txn) async {
      //-----data1-----//
      for (Mezemur1 mezemur in listOfMezemur1) {
        int id = await txn.rawInsert(
          'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
          [
            mezemur.title,
            mezemur.category1,
            mezemur.category2,
            mezemur.category3,
            mezemur.lyric,
          ],
        );
        print('Inserted ID: $id');
      }
      //-----data2-----//
      for (Mezemur2 mezemur in listOfMezemur2) {
        int id = await txn.rawInsert(
          'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
          [
            mezemur.title,
            mezemur.category1,
            mezemur.category2,
            mezemur.category3,
            mezemur.lyric,
          ],
        );
        print('Inserted ID: $id');
      }
      //-----data3-----//
      for (Mezemur3 mezemur in listOfMezemur3) {
        int id = await txn.rawInsert(
          'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
          [
            mezemur.title,
            mezemur.category1,
            mezemur.category2,
            mezemur.category3,
            mezemur.lyric,
          ],
        );
        print('Inserted ID: $id');
      }
      //-----data4-----//
      //   for (Mezemur4 mezemur in listOfMezemur4) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data5-----//
      //   for (Mezemur5 mezemur in listOfMezemur5) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data6-----//
      //   for (Mezemur6 mezemur in listOfMezemur6) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data7-----//
      //   for (Mezemur7 mezemur in listOfMezemur7) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data8-----//
      //   for (Mezemur8 mezemur in listOfMezemur8) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data9-----//
      //   for (Mezemur9 mezemur in listOfMezemur9) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data10-----//
      //   for (Mezemur10 mezemur in listOfMezemur10) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data11-----//
      //   for (Mezemur11 mezemur in listOfMezemur11) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }

      //   //-----data12-----//
      //   for (Mezemur12 mezemur in listOfMezemur12) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }

      //   //-----data13-----//
      //   for (Mezemur13 mezemur in ListOfMezemur13) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data14-----//
      //   for (Mezemur14 mezemur in listOfMezemur14) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data15-----//
      //   for (Mezemur15 mezemur in listOfMezemur15) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }

      //   //-----data16-----//
      //   for (Mezemur16 mezemur in listOfMezemur16) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }

      //   //-----data17-----//
      //   for (Mezemur17 mezemur in listOfMezemur17) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data18-----//
      //   for (Mezemur18 mezemur in listOfMezemur18) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }

      //   //-----data19-----//
      //   for (Mezemur19 mezemur in listOfMezemur19) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----data20-----//

      //   for (Mezemur20 mezemur in listOfMezemur20) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }

      //   //-----dataor1-----//
      //   for (Mezemuror1 mezemur in listOfMezemuror1) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----dataor2-----//
      //   for (Mezemuror2 mezemur in listOfMezemuror2) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }

      //   //-----dataor3-----//
      //   for (Mezemuror3 mezemur in listOfMezemuror3) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----dataor4-----//
      //   for (Mezemuror4 mezemur in listOfMezemuror4) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----datatg1-----//
      //   for (Mezemurtg1 mezemur in listOfMezemurtg1) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----datatg2-----//
      //   for (Mezemurtg2 mezemur in listOfMezemurtg2) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----datatg3-----//
      //   for (Mezemurtg3 mezemur in ListOfMezemurtg3) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----datatg4-----//
      //   for (Mezemurtg4 mezemur in listOfMezemurtg4) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }

      //   //-----datatg5-----//
      //   for (Mezemurtg5 mezemur in listOfMezemurtg5) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //-----datatg6-----//
      //   for (Mezemurtg6 mezemur in listOfMezemurtg6) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
      //   //wolaitigna
      //   //-----data21-----//
      //   for (Mezemurwol mezemur in listOfMezemurwol) {
      //     int id = await txn.rawInsert(
      //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
      //       [
      //         mezemur.title,
      //         mezemur.category1,
      //         mezemur.category2,
      //         mezemur.category3,
      //         mezemur.lyric,
      //       ],
      //     );
      //     print('Inserted ID: $id');
      //   }
    });
  }
}












    //  //-----data21-----//
    //   for (Mezemur21 mezemur in listOfMezemur21) {
    //     int id = await txn.rawInsert(
    //       'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
    //       [
    //         mezemur.title,
    //         mezemur.category1,
    //         mezemur.category2,
    //         mezemur.category3,
    //         mezemur.lyric,
    //       ],
    //     );
    //     print('Inserted ID: $id');
    //   }
    //     //-----data22-----//
    //     for (Mezemur22 mezemur in listOfMezemur22) {
    //       int id = await txn.rawInsert(
    //         'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
    //         [
    //           mezemur.title,
    //           mezemur.category1,
    //           mezemur.category2,
    //           mezemur.category3,
    //           mezemur.lyric,
    //         ],
    //       );
    //       print('Inserted ID: $id');
    //     }
    //       //-----data23-----//
    //       for (Mezemur23 mezemur in listOfMezemur23) {
    //         int id = await txn.rawInsert(
    //           'INSERT INTO Mezemur(title, category1, category2, category3, lyric) VALUES(?, ?, ?, ?, ?)',
    //           [
    //             mezemur.title,
    //             mezemur.category1,
    //             mezemur.category2,
    //             mezemur.category3,
    //             mezemur.lyric,
    //           ],
    //         );
    //         print('Inserted ID: $id');
    //       }