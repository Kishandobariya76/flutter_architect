import 'package:flutter_architect/src/naming/naming_utils.dart';
import 'package:test/test.dart';

void main() {
  group('NamingUtils', () {
    test('converts various formats to snake_case', () {
      expect(NamingUtils.toSnakeCase('user-profile'), equals('user_profile'));
      expect(NamingUtils.toSnakeCase('UserProfile'), equals('user_profile'));
      expect(NamingUtils.toSnakeCase('user_profile'), equals('user_profile'));
      expect(NamingUtils.toSnakeCase('USER_PROFILE'), equals('user_profile'));
      expect(NamingUtils.toSnakeCase('user profile'), equals('user_profile'));
      expect(NamingUtils.toSnakeCase('user.profile'), equals('user_profile'));
    });

    test('converts to PascalCase', () {
      expect(NamingUtils.toPascalCase('user-profile'), equals('UserProfile'));
      expect(NamingUtils.toPascalCase('user_profile'), equals('UserProfile'));
      expect(NamingUtils.toPascalCase('login'), equals('Login'));
      expect(NamingUtils.toPascalCase('USER_AUTH_PROVIDER'),
          equals('UserAuthProvider'));
    });

    test('converts to camelCase', () {
      expect(NamingUtils.toCamelCase('user-profile'), equals('userProfile'));
      expect(NamingUtils.toCamelCase('UserProfile'), equals('userProfile'));
      expect(NamingUtils.toCamelCase('login'), equals('login'));
    });

    test('converts to kebab-case', () {
      expect(NamingUtils.toKebabCase('user_profile'), equals('user-profile'));
      expect(NamingUtils.toKebabCase('UserProfile'), equals('user-profile'));
    });

    test('converts to Title Case', () {
      expect(NamingUtils.toTitleCase('user_profile'), equals('User Profile'));
      expect(NamingUtils.toTitleCase('login-page'), equals('Login Page'));
    });

    test('validates identifiers', () {
      expect(NamingUtils.isValidIdentifier('login'), isTrue);
      expect(NamingUtils.isValidIdentifier('user_profile'), isTrue);
      expect(NamingUtils.isValidIdentifier('123invalid'), isFalse);
      expect(NamingUtils.isValidIdentifier(''), isFalse);
    });
  });
}
