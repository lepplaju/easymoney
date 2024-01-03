import 'package:flutter_test/flutter_test.dart';
import 'package:easymoney/utils/file_operations.dart';

void main() {
  test('Join paths', () async {
    final path1 = joinPath('/appdir/', '/test_dir/');
    final path2 = joinPath('appdir/', '/test_dir/');
    final path3 = joinPath('/appdir/', '/test_dir');
    final path4 = joinPath('/appdir', '/test_dir');
    final path5 = joinPath('/appdir/', 'test_dir');
    final path6 = joinPath('/appdir', 'test_dir');
    final path7 = joinPath('appdir', 'test_dir');

    expect(path1, '/appdir/test_dir/');
    expect(path2, 'appdir/test_dir/');
    expect(path3, '/appdir/test_dir');
    expect(path4, '/appdir/test_dir');
    expect(path5, '/appdir/test_dir');
    expect(path6, '/appdir/test_dir');
    expect(path7, 'appdir/test_dir');
  });

  test('Is accepted type', () {
    const acceptedTypes = ['jpg', 'png'];
    const filename1 = 'test.jpg';
    const filename2 = 'test.jpeg';
    const filename3 = 'test.png';
    const filename4 = 'test.txt';
    const filename5 = 'test.pdf';

    expect(isAcceptedType(acceptedTypes, filename1), true);
    expect(isAcceptedType(acceptedTypes, filename2), false);
    expect(isAcceptedType(acceptedTypes, filename3), true);
    expect(isAcceptedType(acceptedTypes, filename4), false);
    expect(isAcceptedType(acceptedTypes, filename5), false);
  });
}
