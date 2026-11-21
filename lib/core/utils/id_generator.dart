import 'package:uuid/uuid.dart';

class IdGenerator {
  IdGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  String newId() => _uuid.v4();

  String decisionId() => 'DEC-${_uuid.v4()}';

  String collectionId() => 'COL-${_uuid.v4()}';
}