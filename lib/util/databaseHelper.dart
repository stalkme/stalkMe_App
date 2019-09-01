import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//import 'package:stalkme_app/util/friendList.dart';
import 'package:stalkme_app/util/userClass.dart';

class DatabaseHelper {
  final _databaseName = 'stalkme.db';
  static Database _database;
  static List<User> _friendList = List();

  //Singleton class
  DatabaseHelper._privateConstructor() {
    _initFriendList();
  }
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE friends (
        id INTEGER PRIMARY KEY,
        nickname TEXT NOT NULL,
        message TEXT
      );
    ''');
  }

  Future<void> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert('friends', row);
  }

  Future<void> delete(int id) async {
    Database db = await instance.database;
    await db.delete('friends', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('friends', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query('friends');
  }

  List<User> get friendList {
    return _friendList;
  }

  Future<void> _initFriendList() async {
    List<Map<String, dynamic>> rows = await instance.queryAllRows();
    rows.forEach((row){
      User user = User(
        id: row['id'],
        nickname: row['nickname'],
        message: row['message'],
      );
      instance.friendList.add(user);
    });
  }

  void addFriend(User user) {
    instance.friendList.add(user);
    Map<String, dynamic> toDB = {
      'id': user.id,
      'nickname': user.nickname,
      'message': user.message
    };
    instance.insert(toDB);
  }

  void removeFriend(User user) {
    instance.friendList.remove(user);
    instance.delete(user.id);
  }


}
