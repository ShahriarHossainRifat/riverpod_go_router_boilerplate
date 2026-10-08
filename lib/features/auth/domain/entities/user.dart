import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Represents an authenticated user.
///
/// Uses Freezed for:
/// - Immutability
/// - Value equality
/// - copyWith
/// - JSON serialization
@freezed
abstract class User with _$User {
  /// Creates a [User] instance.
  const factory({
    required String id,
    required String email,
    String? name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default(false) bool isEmailVerified,
    DateTime? createdAt,
  }) = _User;

  /// Creates a [User] instance from JSON.
  factory fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
