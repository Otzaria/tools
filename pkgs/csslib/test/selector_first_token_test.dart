// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/parser.dart';
import 'package:test/test.dart';

import 'testing.dart';

void main() {
  test('unit-like type selectors are recognized from the first token', () {
    for (final name in ['px', 'fr', 'em', 'rem', 'ch', 'vw', 'lh']) {
      final errors = <Message>[];
      final parsed = selector(name, errors: errors);
      expect(errors, isEmpty, reason: name);
      expect(compactOutput(parsed), name);
    }
  });

  test('first token of a selector group is in selector mode', () {
    final errors = <Message>[];
    final group = parseSelectorGroup('fr, rem, px', errors: errors);
    expect(errors, isEmpty);
    expect(group, isNotNull);
    expect(group!.selectors, hasLength(3));
  });

  test('ordinary stylesheet value units still parse as units', () {
    final errors = <Message>[];
    final sheet = parse('.entry { width: 10px; }', errors: errors);
    expect(errors, isEmpty);
    expect(sheet.topLevels, hasLength(1));
  });
}
