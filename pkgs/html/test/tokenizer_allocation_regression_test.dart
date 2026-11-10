// Copyright (c) project authors. All rights reserved.
// Licensed under the MIT license.
// See LICENSE file in the project root for details.

import 'dart:convert';

import 'package:html/parser.dart';
import 'package:html/src/encoding_parser.dart';
import 'package:test/test.dart';

void main() {
  group('entity-heavy Hebrew HTML', () {
    test('decimal and hexadecimal numeric entities parse identically', () {
      final fragment = parseFragment(
        '<p>&#1488;&#x5D1;&#1504; &#x1F600; &#x05D3;</p>',
      );
      expect(fragment.text, 'אבנ 😀 ד');
    });

    test('named entity backtracking preserves the longest match', () {
      final fragment = parseFragment(
        '<p>&notin; &not; &amp; &copy; &ampx &unknown;</p>',
      );
      // &ampx is a valid legacy &amp reference followed by x.
      expect(fragment.text, '∉ ¬ & © &x &unknown;');
    });

    test('numeric entity overflow is replaced without throwing', () {
      final fragment = parseFragment(
        '<p>&#99999999999999999999999999999999999999;'
        '&#xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;</p>',
      );
      expect(fragment.text, '\uFFFD\uFFFD');
    });

    test('repeated numeric entities keep original text order', () {
      final html = List.filled(300, '&#1488;').join();
      expect(parseFragment('<span>$html</span>').text,
          List.filled(300, 'א').join());
    });
  });

  group('meta charset detection', () {
    test('skips comments and unrelated tags', () {
      const html = '<!-- <meta charset="ascii"> -->'
          '<html><head><title>x</title><meta charset="utf-8">'
          '</head></html>';
      expect(EncodingParser(utf8.encode(html)).getEncoding(), 'utf-8');
    });

    test('recognizes uppercase charset without substring allocations', () {
      const html = '<!DOCTYPE html><META CHARSET="UTF-8">';
      expect(EncodingParser(utf8.encode(html)).getEncoding(), 'utf-8');
    });

    test('ignores fake meta sequences embedded inside comments', () {
      const html = '<!-- <meta charset="ascii"> -->'
          '<meta charset="utf-8">';
      expect(EncodingParser(utf8.encode(html)).getEncoding(), 'utf-8');
    });
  });
}
