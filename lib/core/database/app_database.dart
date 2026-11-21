import 'dart:io';

import 'package:codit/core/database/database_tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    LocalCollections,
    LocalDebts,
    SyncQueue,
    DeviceMeta,
    GoldDrafts,
    BranchSnapshots,
    PendingApprovalDecisions,
    // SentApprovalDecisions, // TODO: uncomment after build_runner completes
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
  
  // TODO: Migration - uncomment after build_runner completes
  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onUpgrade: (m, from, to) async {
  //       if (from < 2) {
  //         await m.createTable(sentApprovalDecisions);
  //       }
  //     },
  //   );
  // }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'codit.db'));
      return NativeDatabase(file);
    });
  }
}