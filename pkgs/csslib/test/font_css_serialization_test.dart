// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/parser.dart';
import 'package:test/test.dart';

void main() {
  test('font CSS omits null and empty family lists', () {
    expect(const Font(size: 16).cssExpression, '16px');
    expect(const Font(size: 16, family: []).cssExpression, '16px');
    expect(
      const Font(size: 16, weight: FontWeight.bold).cssExpression,
      '700 16px',
    );
  });

  test('font CSS serializes multiple named families', () {
    expect(
      const Font(size: 16, family: ['Alef', 'serif']).cssExpression,
      '16px Alef, serif',
    );
  });

  test('font CSS keeps weight and explicit line height', () {
    final font = Font(
      size: 16,
      weight: FontWeight.bold,
      lineHeight: const LineHeight(24),
      family: const ['Alef'],
    );
    expect(font.cssExpression, '700 16px/24 Alef');
  });
}
