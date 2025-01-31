import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  /// 初期化処理
  void sqfliteTestInit() {
    databaseFactoryOrNull = null;
    // ffi実装の初期化
    sqfliteFfiInit();
    // グローバルファクトリーの設定
    databaseFactory = databaseFactoryFfi;
  }

  setUp(() {
    sqfliteTestInit();
  });

  test('SQLite database operations test', () async {
    // データベースのセットアップ
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db
          .execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)');
    });

    // テストデータの挿入
    await db.insert('Test', {'value': 'テストデータ'});

    // データの検証
    var result = await db.query('Test');
    expect(result, [
      {'id': 1, 'value': 'テストデータ'}
    ]);

    // データベースを閉じることを忘れずに
    await db.close();
  });

  test('SQLite update operation test', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db
          .execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)');
    });

    // テストデータの挿入
    await db.insert('Test', {'value': 'テストデータ'});

    // データの更新
    await db.update('Test', {'value': '更新データ'},
        where: 'id = ?', whereArgs: [1]);

    // データの検証
    var result = await db.query('Test');
    expect(result, [
      {'id': 1, 'value': '更新データ'}
    ]);

    await db.close();
  });

  test('SQLite delete operation test', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db
          .execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)');
    });

    // テストデータの挿入
    await db.insert('Test', {'value': 'テストデータ'});

    // データの削除
    await db.delete('Test', where: 'id = ?', whereArgs: [1]);

    // データの検証
    var result = await db.query('Test');
    expect(result, []);

    await db.close();
  });
}
