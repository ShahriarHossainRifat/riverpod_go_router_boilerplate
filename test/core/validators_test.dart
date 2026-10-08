import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('required', () {
      test('returns error for null value', () {
        final validator = Validators.required();
        expect(validator(null), isNotNull);
      });

      test('returns error for empty string', () {
        final validator = Validators.required();
        expect(validator(''), isNotNull);
      });

      test('returns error for whitespace-only string', () {
        final validator = Validators.required();
        expect(validator('   '), isNotNull);
      });

      test('returns null for valid string', () {
        final validator = Validators.required();
        expect(validator('hello'), isNull);
      });

      test('uses custom error message', () {
        final validator = Validators.required('Custom error');
        expect(validator(''), equals('Custom error'));
      });
    });

    group('email', () {
      test('returns null for valid email', () {
        final validator = Validators.email();
        expect(validator('test@example.com'), isNull);
      });

      test('returns null for null value (not required)', () {
        final validator = Validators.email();
        expect(validator(null), isNull);
      });

      test('returns null for empty value (not required)', () {
        final validator = Validators.email();
        expect(validator(''), isNull);
      });

      test('returns error for invalid email without @', () {
        final validator = Validators.email();
        expect(validator('testexample.com'), isNotNull);
      });

      test('returns error for invalid email without domain', () {
        final validator = Validators.email();
        expect(validator('test@'), isNotNull);
      });
    });

    group('minLength', () {
      test('returns null for string meeting minimum length', () {
        final validator = Validators.minLength(5);
        expect(validator('hello'), isNull);
      });

      test('returns null for string exceeding minimum length', () {
        final validator = Validators.minLength(5);
        expect(validator('hello world'), isNull);
      });

      test('returns error for string below minimum length', () {
        final validator = Validators.minLength(5);
        expect(validator('hi'), isNotNull);
      });

      test('returns null for empty value (not required)', () {
        final validator = Validators.minLength(5);
        expect(validator(''), isNull);
      });
    });

    group('maxLength', () {
      test('returns null for string within maximum length', () {
        final validator = Validators.maxLength(10);
        expect(validator('hello'), isNull);
      });

      test('returns error for string exceeding maximum length', () {
        final validator = Validators.maxLength(5);
        expect(validator('hello world'), isNotNull);
      });
    });

    group('numeric', () {
      test('returns null for numeric string', () {
        final validator = Validators.numeric();
        expect(validator('12345'), isNull);
      });

      test('returns error for non-numeric string', () {
        final validator = Validators.numeric();
        expect(validator('123abc'), isNotNull);
      });
    });

    group('phone', () {
      test('returns null for valid phone with + prefix', () {
        final validator = Validators.phone();
        expect(validator('+1234567890'), isNull);
      });

      test('returns null for valid phone with spaces', () {
        final validator = Validators.phone();
        expect(validator('123 456 7890'), isNull);
      });

      test('returns error for short phone number', () {
        final validator = Validators.phone();
        expect(validator('12345'), isNotNull);
      });
    });

    group('compose', () {
      test('returns first error when multiple validators fail', () {
        final validator = Validators.compose([
          Validators.required('Required'),
          Validators.minLength(5, 'Too short'),
        ]);

        expect(validator(''), equals('Required'));
      });

      test('returns second error when first passes', () {
        final validator = Validators.compose([
          Validators.required('Required'),
          Validators.minLength(5, 'Too short'),
        ]);

        expect(validator('hi'), equals('Too short'));
      });

      test('returns null when all validators pass', () {
        final validator = Validators.compose([
          Validators.required(),
          Validators.minLength(3),
          Validators.maxLength(10),
        ]);

        expect(validator('hello'), isNull);
      });

      test('works with email validation chain', () {
        final validator = Validators.compose([
          Validators.required('Email required'),
          Validators.email('Invalid email'),
        ]);

        expect(validator(''), equals('Email required'));
        expect(validator('invalid'), equals('Invalid email'));
        expect(validator('test@example.com'), isNull);
      });
    });

    group('strongPassword', () {
      test('returns error for password without uppercase', () {
        final validator = Validators.strongPassword();
        expect(validator('password1!'), isNotNull);
      });

      test('returns error for password without lowercase', () {
        final validator = Validators.strongPassword();
        expect(validator('PASSWORD1!'), isNotNull);
      });

      test('returns error for password without number', () {
        final validator = Validators.strongPassword();
        expect(validator('Password!'), isNotNull);
      });

      test('returns error for password without special char', () {
        final validator = Validators.strongPassword();
        expect(validator('Password1'), isNotNull);
      });

      test('returns error for short password', () {
        final validator = Validators.strongPassword();
        expect(validator('Pa1!'), isNotNull);
      });

      test('returns null for strong password', () {
        final validator = Validators.strongPassword();
        expect(validator('Password1!'), isNull);
      });
    });

    group('match', () {
      test('returns null when values match', () {
        String getValue() => 'password123';
        final validator = Validators.match(getValue);

        expect(validator('password123'), isNull);
      });

      test('returns error when values do not match', () {
        String getValue() => 'password123';
        final validator = Validators.match(getValue, 'Passwords must match');

        expect(validator('different'), equals('Passwords must match'));
      });
    });

    group('url', () {
      test('returns null for valid http URL', () {
        final validator = Validators.url();
        expect(validator('http://example.com'), isNull);
      });

      test('returns null for valid https URL', () {
        final validator = Validators.url();
        expect(validator('https://example.com'), isNull);
      });

      test('returns null for URL with path', () {
        final validator = Validators.url();
        expect(validator('https://example.com/path/to/page'), isNull);
      });

      test('returns null for URL with query params', () {
        final validator = Validators.url();
        expect(validator('https://example.com?foo=bar'), isNull);
      });

      test('returns error for URL without scheme', () {
        final validator = Validators.url();
        expect(validator('example.com'), isNotNull);
      });

      test('returns error for URL without host', () {
        final validator = Validators.url();
        expect(validator('http://'), isNotNull);
      });

      test('returns error for non-http/https scheme', () {
        final validator = Validators.url();
        expect(validator('ftp://example.com'), isNotNull);
      });

      test('returns error for plain text', () {
        final validator = Validators.url();
        expect(validator('not-a-url'), isNotNull);
      });

      test('returns null for empty value (not required)', () {
        final validator = Validators.url();
        expect(validator(''), isNull);
      });

      test('returns null for null value (not required)', () {
        final validator = Validators.url();
        expect(validator(null), isNull);
      });
    });
  });
}
