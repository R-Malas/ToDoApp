import 'package:drift/drift.dart';

class UserActivity extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get username => text().withLength(min: 6, max: 32)();

  IntColumn get auditActivity => integer().nullable()();
}

@DataClassName('AuditActivity')
class AuditActivities extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text()();
}
