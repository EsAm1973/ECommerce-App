import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'products.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)",
        );
        await db.execute(
          "CREATE TABLE favorite_products(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, rating_rate REAL, rating_count INTEGER)",
        );
        await db.execute(
          "CREATE TABLE cart_products(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, rating_rate REAL, rating_count INTEGER, quantity INTEGER DEFAULT 1)",
        );
      },
    );
  }

  Future<void> insertUser(String username, String password) async {
    final db = await database;

    await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, String>?> getUser() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('users');

    if (maps.isNotEmpty) {
      return {
        'username': maps.first['username'],
        'password': maps.first['password'],
      };
    }

    return null;
  }

  Future<void> insertFavoriteProduct(
      String username,
      String title,
      String description,
      String category,
      String image,
      double price,
      double ratingRate,
      int ratingCount) async {
    final db = await database;

    await db.insert(
      'favorite_products',
      {
        'username': username,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating_rate': ratingRate,
        'rating_count': ratingCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteProduct(String username) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_products',
      where: 'username = ?',
      whereArgs: [username],
    );

    return maps;
  }

  Future<bool> isFavorite(String username, String productTitle) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_products',
      where: 'username = ? AND title = ?',
      whereArgs: [username, productTitle],
    );

    return maps.isNotEmpty;
  }

  Future<void> removeFavoriteProduct(
      String username, String productTitle) async {
    final db = await database;

    await db.delete(
      'favorite_products',
      where: 'username = ? AND title = ?',
      whereArgs: [username, productTitle],
    );
  }

  Future<void> insertCartProduct(
      String username,
      String title,
      String description,
      String category,
      String image,
      double price,
      double ratingRate,
      int ratingCount) async {
    final db = await database;

    await db.insert(
      'cart_products',
      {
        'username': username,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating_rate': ratingRate,
        'rating_count': ratingCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartProduct(String username) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'cart_products',
      where: 'username = ?',
      whereArgs: [username],
    );

    return maps;
  }

  Future<bool> isInCart(String username, String productTitle) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'cart_products',
      where: 'username = ? AND title = ?',
      whereArgs: [username, productTitle],
    );

    return maps.isNotEmpty;
  }

  Future<void> removeCartProduct(String username, String productTitle) async {
    final db = await database;

    await db.delete(
      'cart_products',
      where: 'username = ? AND title = ?',
      whereArgs: [username, productTitle],
    );
  }

  Future<void> updateCartProductQuantity(
      String username, String title, int quantityChange) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE cart_products 
      SET quantity = quantity + ? 
      WHERE username = ? AND title = ?
    ''', [quantityChange, username, title]);
  }

  Future<int> getProductQuantity(String username, String title) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'cart_products',
      columns: ['quantity'],
      where: 'username = ? AND title = ?',
      whereArgs: [username, title],
    );
    if (result.isNotEmpty) {
      return result.first['quantity'];
    } else {
      return 0;
    }
  }
}
