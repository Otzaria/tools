// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/parser.dart';
import 'package:csslib/visitor.dart';
import 'package:test/test.dart';

import 'testing.dart';

void main() {
  test('named color lookup remains case insensitive', () {
    expect(TokenKind.colorValue(TokenKind.matchColorName('RED')!), 0xFF0000);
    expect(
      TokenKind.colorValue(TokenKind.matchColorName('aliceblue')!),
      0xF0F8FF,
    );
    expect(TokenKind.matchColorName('not-a-color'), isNull);
  });

  test('left and right bottom page-margin names are distinct', () {
    const left = 'left-bottom';
    const right = 'right-bottom';
    expect(
      TokenKind.matchMarginDirectives(left, 0, left.length),
      TokenKind.MARGIN_DIRECTIVE_LEFTBOTTOM,
    );
    expect(
      TokenKind.matchMarginDirectives(right, 0, right.length),
      TokenKind.MARGIN_DIRECTIVE_RIGHTBOTTOM,
    );

    final errors = <Message>[];
    final parsed = parse(
      '@page { @left-bottom { content: "L"; } '
      '@right-bottom { content: "R"; } }',
      errors: errors,
    );
    expect(errors, isEmpty);
    expect(parsed.topLevels.single, isA<PageDirective>());
    expect(compactOutput(parsed), contains('@left-bottom'));
    expect(compactOutput(parsed), contains('@right-bottom'));
  });
}
