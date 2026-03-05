import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ===================================
// PRODUCT MODEL
// ===================================
class Product {
  final int? id;
  final String barcode;
  final String productName;
  final double buyPrice;
  final double sellPrice;
  final String category;
  final int quantity;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    this.id,
    required this.barcode,
    required this.productName,
    required this.buyPrice,
    required this.sellPrice,
    required this.category,
    required this.quantity,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Product to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'productName': productName,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'category': category,
      'quantity': quantity,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create Product from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      barcode: map['barcode'] as String,
      productName: map['productName'] as String,
      buyPrice: (map['buyPrice'] as num).toDouble(),
      sellPrice: (map['sellPrice'] as num).toDouble(),
      category: map['category'] as String,
      quantity: map['quantity'] as int,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  // Copy with changes
  Product copyWith({
    int? id,
    String? barcode,
    String? productName,
    double? buyPrice,
    double? sellPrice,
    String? category,
    int? quantity,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      productName: productName ?? this.productName,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Product(id: $id, name: $productName, barcode: $barcode)';
}

// ===================================
// DATABASE HELPER - SINGLETON
// ===================================
class DatabaseHelper {
  // Singleton pattern with proper constructor
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  /// Initialize Database
  Future<Database> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'products.db');

    return openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create table on first launch
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT UNIQUE NOT NULL,
        productName TEXT NOT NULL,
        buyPrice REAL NOT NULL,
        sellPrice REAL NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        description TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_barcode ON products(barcode)');
    await db.execute('CREATE INDEX idx_productName ON products(productName)');
    await db.execute('CREATE INDEX idx_category ON products(category)');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Drop old table and recreate with new schema
      await db.execute('DROP TABLE IF EXISTS products');
      await _onCreate(db, newVersion);
    }
  }

  /// Delete database (for testing or reset)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'products.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // ===================================
  // CRUD OPERATIONS
  // ===================================

  /// Add Product
  Future<int> insertProduct(Product product) async {
    try {
      final db = await database;

      // Check if barcode already exists
      final existing = await db.query(
        'products',
        where: 'barcode = ?',
        whereArgs: [product.barcode],
      );

      if (existing.isNotEmpty) {
        throw Exception('Product with this barcode already exists!');
      }

      return await db.insert('products', product.toMap());
    } catch (e) {
      throw Exception('Failed to insert product: $e');
    }
  }

  /// Get Product by ID
  Future<Product?> getProductById(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return null;
      }

      return Product.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  /// Get Product by Barcode
  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      final db = await database;
      final maps = await db.query(
        'products',
        where: 'barcode = ?',
        whereArgs: [barcode],
      );

      if (maps.isEmpty) {
        return null;
      }

      return Product.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  /// Get All Products
  Future<List<Product>> getAllProducts() async {
    try {
      final db = await database;
      final maps = await db.query(
        'products',
        orderBy: 'createdAt DESC',
      );

      return List.generate(
        maps.length,
            (i) => Product.fromMap(maps[i]),
      );
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  /// Search Products by Name
  Future<List<Product>> searchProductsByName(String query) async {
    try {
      final db = await database;
      final maps = await db.query(
        'products',
        where: 'productName LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'productName ASC',
      );

      return List.generate(
        maps.length,
            (i) => Product.fromMap(maps[i]),
      );
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  /// Get Products by Category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final db = await database;
      final maps = await db.query(
        'products',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'productName ASC',
      );

      return List.generate(
        maps.length,
            (i) => Product.fromMap(maps[i]),
      );
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  /// Update Product
  Future<int> updateProduct(Product product) async {
    try {
      final db = await database;

      if (product.id == null) {
        throw Exception('Cannot update product without ID');
      }

      // Check if barcode already exists for another product
      final existing = await db.query(
        'products',
        where: 'barcode = ? AND id != ?',
        whereArgs: [product.barcode, product.id],
      );

      if (existing.isNotEmpty) {
        throw Exception('Another product with this barcode already exists!');
      }

      return await db.update(
        'products',
        product.copyWith(updatedAt: DateTime.now()).toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete Product
  Future<int> deleteProduct(int id) async {
    try {
      final db = await database;

      return await db.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Get All Categories
  Future<List<String>> getAllCategories() async {
    try {
      final db = await database;
      final maps = await db.rawQuery(
        'SELECT DISTINCT category FROM products ORDER BY category ASC',
      );

      return List.generate(
        maps.length,
            (i) => maps[i]['category'] as String,
      );
    } catch (e) {
      // Return empty list if no products yet
      return [];
    }
  }

  /// Get Product Count
  Future<int> getProductCount() async {
    try {
      final db = await database;
      final result =
      await db.rawQuery('SELECT COUNT(*) as count FROM products');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Failed to get product count: $e');
    }
  }

  /// Get Total Inventory Value
  Future<double> getTotalInventoryValue() async {
    try {
      final db = await database;
      final result = await db
          .rawQuery('SELECT SUM(price * quantity) as total FROM products');

      final total = result.first['total'];
      return total != null ? (total as num).toDouble() : 0.0;
    } catch (e) {
      throw Exception('Failed to get inventory value: $e');
    }
  }

  /// Get Low Stock Products
  Future<List<Product>> getLowStockProducts({int threshold = 5}) async {
    try {
      final db = await database;
      final maps = await db.query(
        'products',
        where: 'quantity <= ?',
        whereArgs: [threshold],
        orderBy: 'quantity ASC',
      );

      return List.generate(
        maps.length,
            (i) => Product.fromMap(maps[i]),
      );
    } catch (e) {
      throw Exception('Failed to get low stock products: $e');
    }
  }

  /// Clear All Products
  Future<int> clearAllProducts() async {
    try {
      final db = await database;
      return await db.delete('products');
    } catch (e) {
      throw Exception('Failed to clear products: $e');
    }
  }

  /// Close Database
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}