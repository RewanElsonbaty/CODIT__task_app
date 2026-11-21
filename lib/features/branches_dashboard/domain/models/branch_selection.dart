import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_selection.freezed.dart';
part 'branch_selection.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// Branch selection options
@freezed
class BranchSelection with _$BranchSelection {
  const factory BranchSelection.all() = AllBranches;
  
  const factory BranchSelection.specific({
    required String branchId,
    required String branchName,
  }) = SpecificBranch;

  factory BranchSelection.fromJson(Map<String, dynamic> json) =>
      _$BranchSelectionFromJson(json);
}

extension BranchSelectionExtension on BranchSelection {
  String get displayName {
    return when(
      all: () => 'كل الفروع',
      specific: (id, name) => name,
    );
  }

  String? get branchId {
    return when(
      all: () => null,
      specific: (id, name) => id,
    );
  }

  bool get isAll => when(
        all: () => true,
        specific: (_, _) => false,
      );
}

/// Available branch info
@freezed
class BranchInfo with _$BranchInfo {
  const factory BranchInfo({
    required String id,
    required String name,
    required bool isActive,
  }) = _BranchInfo;

  factory BranchInfo.fromJson(Map<String, dynamic> json) =>
      _$BranchInfoFromJson(json);
}
