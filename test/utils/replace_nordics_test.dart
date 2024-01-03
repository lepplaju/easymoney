import 'package:flutter_test/flutter_test.dart';
import 'package:easymoney/utils/replace_nordics.dart';

void main() {
  test('Replace nordics', () {
    const text1 = 'äåáàâãåæöøóòôõ';
    var result = replaceNordics(text: text1);
    expect(result, 'aaaaaaaaoooooo');

    const text2 = 'ÄÅÁÀÂÃÅÆÖØÓÒÔÕ';
    result = replaceNordics(text: text2);
    expect(result, 'aaaaaaaaoooooo');

    const text3 = 'testitapaus välilyönnillä';
    result = replaceNordics(text: text3);
    expect(result, 'testitapaus valilyonnilla');
  });
}
