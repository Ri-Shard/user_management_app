import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:user_management_app/data/datasources/user_local_datasource.dart';
import 'package:user_management_app/data/models/models.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static Database? _database;
  static const String _usersTable = 'users';
  static const String _addressesTable = 'addresses';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_management.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE $_usersTable (
        id TEXT PRIMARY KEY,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        birthDate TEXT NOT NULL
      )
    ''');

    // Create addresses table
    await db.execute('''
      CREATE TABLE $_addressesTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        country TEXT NOT NULL,
        department TEXT NOT NULL,
        municipality TEXT NOT NULL,
        street TEXT NOT NULL,
        additionalInfo TEXT,
        FOREIGN KEY (userId) REFERENCES $_usersTable (id) ON DELETE CASCADE
      )
    ''');
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    final db = await database;
    await db.insert(_usersTable, {
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'birthDate': user.birthDate.toIso8601String(),
    });
    return user;
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_usersTable);

    List<UserModel> users = [];
    for (var map in maps) {
      final user = UserModel(
        id: map['id'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        birthDate: DateTime.parse(map['birthDate']),
      );

      // Get addresses for this user
      final addresses = await getUserAddresses(user.id);
      final userWithAddresses = UserModel(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        birthDate: user.birthDate,
        addresses: addresses,
      );

      users.add(userWithAddresses);
    }

    return users;
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw Exception('User not found');
    }

    final map = maps.first;
    final user = UserModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      birthDate: DateTime.parse(map['birthDate']),
    );

    // Get addresses for this user
    final addresses = await getUserAddresses(user.id);
    return UserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      birthDate: user.birthDate,
      addresses: addresses,
    );
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      _usersTable,
      {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'birthDate': user.birthDate.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return user;
  }

  @override
  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete(_usersTable, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final db = await database;
    await db.insert(_addressesTable, {
      'id': address.id,
      'userId': address.userId,
      'country': address.country,
      'department': address.department,
      'municipality': address.municipality,
      'street': address.street,
      'additionalInfo': address.additionalInfo,
    });
    return address;
  }

  @override
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _addressesTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps
        .map(
          (map) => AddressModel(
            id: map['id'],
            userId: map['userId'],
            country: map['country'],
            department: map['department'],
            municipality: map['municipality'],
            street: map['street'],
            additionalInfo: map['additionalInfo'],
          ),
        )
        .toList();
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    final db = await database;
    await db.update(
      _addressesTable,
      {
        'country': address.country,
        'department': address.department,
        'municipality': address.municipality,
        'street': address.street,
        'additionalInfo': address.additionalInfo,
      },
      where: 'id = ?',
      whereArgs: [address.id],
    );
    return address;
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    final db = await database;
    await db.delete(_addressesTable, where: 'id = ?', whereArgs: [addressId]);
  }
}
