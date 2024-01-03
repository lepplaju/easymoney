import 'package:flutter_test/flutter_test.dart';
import 'package:easymoney/features/receipts/domain/receipt.dart';

void main() {
  const initialDate = '2024-01-01T12:00:00.000';
  const initialId = 1;
  const initialAmount = 0;
  const initialStore = 'Test Store';
  const initialDescription = 'Test description';
  const initialFileName = 'test_receipt.jpg';
  const initialMinute = '1/24';
  const initialProfileId = 1;

  Receipt createReceipt({
    id = initialId,
    date = initialDate,
    amount = initialAmount,
    store = initialStore,
    description = initialDescription,
    fileName = initialFileName,
    profileId = initialProfileId,
    minute = initialMinute,
  }) {
    return Receipt(
      id: id,
      date: DateTime.parse(date),
      amount: amount,
      store: store,
      description: description,
      fileName: fileName,
      profileId: profileId,
      minute: minute,
    );
  }

  group('Receipt constructors', () {
    test('Receipt() creates a Receipt', () {
      var receipt = createReceipt();
      expect(receipt.id, initialId);
      expect(receipt.date.toIso8601String(), initialDate);
      expect(receipt.amount, initialAmount);
      expect(receipt.store, initialStore);
      expect(receipt.description, initialDescription);
      expect(receipt.fileName, initialFileName);
      expect(receipt.profileId, initialProfileId);
      expect(receipt.minute, initialMinute);
    });
    test('Receipt.fromMap() creates a Receipt', () {
      var receipt = Receipt.fromMap({
        'id': initialId,
        'date': initialDate,
        'amount': initialAmount,
        'store': initialStore,
        'description': initialDescription,
        'fileName': initialFileName,
        'profileId': initialProfileId,
        'minute': initialMinute,
      });
      expect(receipt.id, initialId);
      expect(receipt.date.toIso8601String(), initialDate);
      expect(receipt.amount, initialAmount);
      expect(receipt.store, initialStore);
      expect(receipt.description, initialDescription);
      expect(receipt.fileName, initialFileName);
      expect(receipt.profileId, initialProfileId);
      expect(receipt.minute, initialMinute);
    });
  });

  group('Receipt setters', () {
    test('date', () {
      var receipt = createReceipt();
      expect(receipt.date.toIso8601String(), initialDate);
      receipt.date = DateTime.parse('2024-01-02 12:00:00.000');
      expect(receipt.date.toIso8601String(), '2024-01-02T12:00:00.000');
    });
    test('amount', () {
      var receipt = createReceipt();
      expect(receipt.amount, initialAmount);
      receipt.amount = 100;
      expect(receipt.amount, 100);
    });
    test('store', () {
      var receipt = createReceipt();
      expect(receipt.store, initialStore);
      receipt.store = 'Test Store 2';
      expect(receipt.store, 'Test Store 2');
    });
    test('description', () {
      var receipt = createReceipt();
      expect(receipt.description, initialDescription);
      receipt.description = 'Test description 2';
      expect(receipt.description, 'Test description 2');
    });
    test('fileName', () {
      var receipt = createReceipt();
      expect(receipt.fileName, initialFileName);
      receipt.fileName = 'test_receipt_2.jpg';
      expect(receipt.fileName, 'test_receipt_2.jpg');
    });
    test('profileId', () {
      var receipt = createReceipt();
      expect(receipt.profileId, initialProfileId);
      receipt.profileId = 2;
      expect(receipt.profileId, 2);
    });
    test('minute', () {
      var receipt = createReceipt();
      expect(receipt.minute, initialMinute);
      receipt.minute = '2/24';
      expect(receipt.minute, '2/24');
    });
  });

  group('Receipt getters', () {
    test('Receipt.euros returns correctly formatted string', () {
      var receipt = createReceipt();
      expect(receipt.euros, '0.00');
      receipt.amount = 100;
      expect(receipt.euros, '1.00');
      receipt.amount = 1000;
      expect(receipt.euros, '10.00');
      receipt.amount = 9999;
      expect(receipt.euros, '99.99');
      receipt.amount = 3333;
      expect(receipt.euros, '33.33');
    });
    test('Receipt.dateOnly returns correctly formatted string', () {
      var receipt = createReceipt();
      expect(receipt.dateOnly, '1.1.2024');
      receipt.date = DateTime.parse('2024-01-02 12:00:00.000');
      expect(receipt.dateOnly, '2.1.2024');
      receipt.date = DateTime.parse('2022-12-31 12:00:00.000');
      expect(receipt.dateOnly, '31.12.2022');
      receipt.date = DateTime.parse('2024-01-01 23:45:10.000');
      expect(receipt.dateOnly, '1.1.2024');
    });
    test('Receipt.toString works', () {
      var receipt = createReceipt();
      expect(
          receipt.toString(),
          'Receipt{'
          'id: $initialId, '
          'date: $initialDate, '
          'amount: $initialAmount, '
          'store: "$initialStore", '
          'description: "$initialDescription", '
          'fileName: "$initialFileName", '
          'minute: "$initialMinute", '
          'profileId: "$initialProfileId"'
          '}');
    });
    test('Receipt.toMap works', () {
      var receipt = createReceipt();
      expect(receipt.toMap(), {
        'id': initialId,
        'date': initialDate,
        'amount': initialAmount,
        'store': initialStore,
        'description': initialDescription,
        'fileName': initialFileName,
        'minute': initialMinute,
        'profileId': initialProfileId,
      });
    });
  });
}
