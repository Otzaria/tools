// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/parser.dart';
import 'package:csslib/visitor.dart';
import 'package:test/test.dart';

import 'testing.dart';

void main() {
  test('unescaped identifiers preserve names and !important', () {
    final errors = <Message>[];
    final sheet = parse(
      '.hebrew-שלום { font-family: FrankRuhl; color: red !important; }',
      errors: errors,
    );
    expect(errors, isEmpty);

    final declarations = (sheet.topLevels.single as RuleSet)
        .declarationGroup
        .declarations
        .cast<Declaration>();
    expect(declarations.map((declaration) => declaration.property), [
      'font-family',
      'color',
    ]);
    expect(declarations.last.important, isTrue);
  });

  test('hex-escaped identifiers retain their raw spelling', () {
    final errors = <Message>[];
    final ast = selector(r'.\35 00px', errors: errors);
    expect(errors, isEmpty);
    expect(compactOutput(ast), r'.\35 00px');

    errors.clear();
    final attr = selector(r'[elevation=\31]', errors: errors);
    expect(errors, isEmpty);
    expect(compactOutput(attr), r'[elevation=\31]');
  });

  test('long plain identifiers do not change parsed output', () {
    final errors = <Message>[];
    final identifier = 'hebrew' * 100;
    final css = '.$identifier { --my-property: some-long-value; }';
    final parsed = parse(css, errors: errors);
    expect(errors, isEmpty);
    expect(compactOutput(parsed), contains(identifier));
  });
}
