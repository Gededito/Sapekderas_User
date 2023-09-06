// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class UserModel extends Equatable {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String id;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String type;

  const UserModel({
    required this.email,
    required this.password,
    required this.id,
    this.phone = '',
    this.type = "user",
    this.name = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [email, password, id, name];

  UserModel copyWith({
    String? email,
    String? password,
    String? id,
    String? name,
    String? phone,
    String? type,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      type: type ?? this.type,
    );
  }
}
