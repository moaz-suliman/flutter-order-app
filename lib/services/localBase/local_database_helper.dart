import 'dart:convert';
import 'package:final_project/models/order_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB('tasty_bites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, 
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) await _createOrdersTable(db);
    if (oldVersion < 3) await db.execute('''
      CREATE TABLE IF NOT EXISTS auth (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
    if (oldVersion < 4) await db.execute('''
      CREATE TABLE IF NOT EXISTS session (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }
  Future<void> deleteOrder(String orderId) async {
  final db = await instance.database;
  await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
}

  Future _createDB(Database db, int version) async {
    // جدول السلة
    await db.execute('''
      CREATE TABLE cart (
        productId TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // جدول المنتجات
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    // جدول الطلبات
    await _createOrdersTable(db);

    //  جدول session بدل auth
    await db.execute('''
      CREATE TABLE session (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  Future _createOrdersTable(Database db) async {
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        items TEXT NOT NULL,
        total REAL NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  //  حفظ uid في session
  Future<void> saveUid(String uid) async {
    final db = await instance.database;
    await db.insert(
      'session',
      {'key': 'uid', 'value': uid},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //  جلب uid من session
  Future<String?> getUid() async {
    final db = await instance.database;
    final result = await db.query(
      'session',
      where: 'key = ?',
      whereArgs: ['uid'],
    );
    if (result.isNotEmpty) return result.first['value'] as String;
    return null;
  }

  //  حذف uid من session
  Future<void> deleteUid() async {
    final db = await instance.database;
    await db.delete('session', where: 'key = ?', whereArgs: ['uid']);
  }

  // --- Order functions ---

  Future<void> insertOrder(OrderModel order) async {
    final db = await instance.database;
    await db.insert(
      'orders',
      {
        'id': order.id,
        'userId': order.userId,
        'items': jsonEncode(order.items),
        'total': order.total,
        'status': order.status,
        'createdAt': order.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<OrderModel>> getOrders(String userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) {
      return OrderModel(
        id: map['id'] as String,
        userId: map['userId'] as String,
        items: jsonDecode(map['items'] as String) as List<dynamic>,
        total: map['total'] as double,
        status: map['status'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
    }).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}