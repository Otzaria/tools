// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/visitor.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  test('font clones own their family list and retain priority', () {
    final span = SourceFile.fromString('font').span(0, 4);
    final names = <String>['Frank Ruhl', 'serif'];
    final style = FontExpression(span, family: names)..priority = 37;
    final clone = style.clone();

    names[0] = 'different font';
    names.add('fallback');
    expect(clone.font.family, ['Frank Ruhl', 'serif']);
    expect(clone.priority, 37);

    clone.font.family!.add('separate');
    expect(style.font.family, ['different font', 'serif', 'fallback']);
  });

  test('all Dart style subclasses retain priority when cloned', () {
    final span = SourceFile.fromString('margin').span(0, 6);
    final styles = <DartStyleExpression>[
      MarginExpression(span, left: 1),
      BorderExpression(span, right: 2),
      PaddingExpression(span, top: 3),
      HeightExpression(span, 4),
      WidthExpression(span, 5),
    ];
    for (final style in styles) {
      style.priority = 42;
      final copy = style.clone() as DartStyleExpression;
      expect(copy.priority, 42, reason: style.runtimeType.toString());
      copy.priority = 7;
      expect(style.priority, 42);
    }
  });
}
