import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // FFI実装の初期化
  sqfliteFfiInit();

  // isolateを使用しないファクトリの設定
  databaseFactory = databaseFactoryFfiNoIsolate;

  testWidgets('SQLite database operations in Widget test', (WidgetTester tester) async {
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
}
