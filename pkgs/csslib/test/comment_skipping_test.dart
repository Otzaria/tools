// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/parser.dart';
import 'package:test/test.dart';

void main() {
  test('thousands of skipped comments cannot overflow the tokenizer stack', () {
    final comments = List.filled(20000, '/* note */ \n').join();
    final errors = <Message>[];
    final tree = parse('$comments.x { color: red; }', errors: errors);
    expect(errors, isEmpty);
    expect(tree.topLevels, hasLength(1));
  });

  test('HTML comment, CDATA and block comments preserve following rules', () {
    final errors = <Message>[];
    final tree = parse(
      '<!-- header --> <![CDATA[ /* ignored */ ]]> '
      '.entry { color: red; }',
      errors: errors,
    );
    expect(errors, isEmpty);
    expect(tree.topLevels, hasLength(1));
  });

  test('comments before EOF do not produce empty rules', () {
    final errors = <Message>[];
    final tree = parse('/* leading */ \n /* trailing */', errors: errors);
    expect(errors, isEmpty);
    expect(tree.topLevels, isEmpty);
  });
}
