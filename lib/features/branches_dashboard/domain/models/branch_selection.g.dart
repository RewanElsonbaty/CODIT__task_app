// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_selection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllBranches _$AllBranchesFromJson(Map<String, dynamic> json) =>
    AllBranches($type: json['runtimeType'] as String?);

Map<String, dynamic> _$AllBranchesToJson(AllBranches instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

SpecificBranch _$SpecificBranchFromJson(Map<String, dynamic> json) =>
    SpecificBranch(
      branchId: json['branchId'] as String,
      branchName: json['branchName'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SpecificBranchToJson(SpecificBranch instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'runtimeType': instance.$type,
    };

_BranchInfo _$BranchInfoFromJson(Map<String, dynamic> json) => _BranchInfo(
  id: json['id'] as String,
  name: json['name'] as String,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$BranchInfoToJson(_BranchInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
    };
