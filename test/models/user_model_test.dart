import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn/models/user_model.dart';

void main() {
  group('UserModel', () {
    const user = UserModel(
      id: 'u1',
      name: 'John Doe',
      email: 'john@example.com',
      role: 'Developer',
      totalBalance: 500.0,
    );

    const userWithAvatar = UserModel(
      id: 'u2',
      name: 'Jane Smith',
      email: 'jane@example.com',
      role: 'Designer',
      avatarUrl: 'https://example.com/avatar.png',
      totalBalance: 800.0,
    );

    group('constructor', () {
      test('creates instance with required fields', () {
        expect(user.id, 'u1');
        expect(user.name, 'John Doe');
        expect(user.email, 'john@example.com');
        expect(user.role, 'Developer');
        expect(user.totalBalance, 500.0);
        expect(user.avatarUrl, isNull);
      });

      test('creates instance with optional avatarUrl', () {
        expect(userWithAvatar.avatarUrl, 'https://example.com/avatar.png');
      });
    });

    group('firstName getter', () {
      test('returns first word of a multi-word name', () {
        expect(user.firstName, 'John');
      });

      test('returns the name itself when it is a single word', () {
        const singleName = UserModel(
          id: 'u3',
          name: 'Madonna',
          email: 'm@example.com',
          role: 'Artist',
          totalBalance: 0,
        );
        expect(singleName.firstName, 'Madonna');
      });

      test('returns first segment of a three-part name', () {
        const triName = UserModel(
          id: 'u4',
          name: 'Mary Jane Watson',
          email: 'mj@example.com',
          role: 'Journalist',
          totalBalance: 0,
        );
        expect(triName.firstName, 'Mary');
      });
    });

    group('copyWith', () {
      test('returns a new instance with updated name', () {
        final updated = user.copyWith(name: 'Johnny Doe');
        expect(updated.name, 'Johnny Doe');
        expect(updated.id, user.id);
      });

      test('returns a new instance with updated email', () {
        final updated = user.copyWith(email: 'new@example.com');
        expect(updated.email, 'new@example.com');
      });

      test('returns a new instance with updated role', () {
        final updated = user.copyWith(role: 'Manager');
        expect(updated.role, 'Manager');
      });

      test('returns a new instance with updated avatarUrl', () {
        final updated = user.copyWith(avatarUrl: 'https://img.com/pic.png');
        expect(updated.avatarUrl, 'https://img.com/pic.png');
      });

      test('returns a new instance with updated totalBalance', () {
        final updated = user.copyWith(totalBalance: 9999.99);
        expect(updated.totalBalance, 9999.99);
      });

      test('preserves all unchanged fields', () {
        final updated = user.copyWith(totalBalance: 100.0);
        expect(updated.id, user.id);
        expect(updated.name, user.name);
        expect(updated.email, user.email);
        expect(updated.role, user.role);
        expect(updated.avatarUrl, user.avatarUrl);
      });

      test('does not mutate the original instance', () {
        user.copyWith(name: 'Other');
        expect(user.name, 'John Doe');
      });
    });

    
  });
}