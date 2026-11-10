// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/parser.dart';
import 'package:test/test.dart';

void main() {
  test('indexed CSS keywords remain ASCII case-insensitive', () {
    expect(TokenKind.matchUnits('PX', 0, 2), TokenKind.UNIT_LENGTH_PX);
    expect(TokenKind.matchUnits('10ReM', 2, 3), TokenKind.UNIT_REM);
    expect(TokenKind.matchDirectives('MEDiA', 0, 5),
        TokenKind.DIRECTIVE_MEDIA);
    expect(TokenKind.matchMediaOperator('AND', 0, 3),
        TokenKind.MEDIA_OP_AND);
  });

  test('offsets and unknown keywords are unchanged', () {
    expect(TokenKind.matchUnits('font', 0, 4), -1);
    expect(TokenKind.matchUnits('foopx', 0, 5), -1);
    expect(TokenKind.matchDirectives('my-import', 3, 6),
        TokenKind.DIRECTIVE_IMPORT);
    expect(TokenKind.matchMarginDirectives('right-bottom', 0, 12),
        TokenKind.MARGIN_DIRECTIVE_RIGHTBOTTOM);
  });

  test('indexed matching agrees with generic linear matcher', () {
    final candidates = [
      'rem', 'fr', 'px', 'PT', 'dppx', 'foo', 'font-size', 'media',
      'supports', 'left-top', 'right-bottom', 'and', 'only',
    ];
    for (final word in candidates) {
      expect(
        TokenKind.matchUnits(word, 0, word.length),
        TokenKind.matchList(
          const [
            {'unit': TokenKind.UNIT_EM, 'value': 'em'},
            {'unit': TokenKind.UNIT_REM, 'value': 'rem'},
            {'unit': TokenKind.UNIT_LENGTH_PX, 'value': 'px'},
          ],
          'unit',
          word,
          0,
          word.length,
        ),
        reason: word,
      );
    }
  });
}
