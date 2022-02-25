import 'package:flutter_test/flutter_test.dart';
import 'package:uphf_edt/data/utils/date_helper.dart';

void main() {
  test(
    'Given a DateTime When convertDateTimeTwoDigit(DateTime dateTime) is called Then dd/mm/yyyy is return',
    () {
      // Given
      final dateTime = DateTime(2022, 2, 24);

      // When
      final result = DateHelper.convertDateTimeTwoDigit(dateTime);

      // Then
      expect(result, '24/02/2022');
    },
  );

  test(
    'Given a DateTime When convertDateTimeToSQLFormat(DateTime dateTime) is called Then yyyy-MM-dd is return',
    () {
      // Given
      final dateTime = DateTime(2022, 2, 24);

      // When
      final result = DateHelper.convertDateTimeToSQLFormat(dateTime);

      // Then
      expect(result, '2022-02-24');
    },
  );

  test(
    'Given a SQL date format When convertSQLDateFormatToDateTime(String date) is called Then a DateTime is return',
    () {
      // Given
      const date = '2022-02-24';

      // When
      final result = DateHelper.convertSQLDateFormatToDateTime(date);

      // Then
      expect(result, DateTime(2022, 2, 24));
    },
  );

  test(
      'Given a Litteral Date format When convertLitteralDateToDateTime(String date) is called Then a DateTime is return',
      () {
    // Given
    const date = 'jeudi 24 février';

    // When
    final result = DateHelper.convertLitteralDateToDateTime(date);

    // Then
    expect(result, DateTime(1970, 2, 24));
  });

  test(
      'Given a DateTime When convertDateTimeToLitteral(DateTime dateTime) is called Then a litteral date is return',
      () {
    // Given
    final dateTime = DateTime(2022, 2, 24);

    // When
    final result = DateHelper.convertDateTimeToLitteral(dateTime);

    // Then
    expect(result, 'jeudi 24 février');
  });
}
