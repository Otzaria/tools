// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/parser.dart';
import 'package:csslib/visitor.dart';
import 'package:test/test.dart';

void main() {
  test('selector group clones isolate list and combinator changes', () {
    final sheet = parse('div, span { color: red; }');
    final original = (sheet.topLevels.single as RuleSet).selectorGroup!;
    final copy = original.clone();

    expect(identical(original.selectors, copy.selectors), isFalse);
    copy.selectors.removeLast();
    expect(original.selectors, hasLength(2));

    final originalSequence =
        original.selectors.first.simpleSelectorSequences.first;
    final clonedSequence = copy.selectors.first.simpleSelectorSequences.first;
    clonedSequence.combinator = TokenKind.COMBINATOR_GREATER;
    expect(originalSequence.combinator, TokenKind.COMBINATOR_NONE);
  });

  test('selector names and attributes are not aliased', () {
    final name = Identifier('original', null);
    final original = ClassSelector(name, null);
    final copy = original.clone();
    name.name = 'changed';
    expect(copy.name, 'original');

    final attributeName = Identifier('title', null);
    final attributeValue = Identifier('hello', null);
    final attribute = AttributeSelector(
      attributeName, TokenKind.EQUALS, attributeValue, null,
    ).clone();
    attributeName.name = 'other';
    attributeValue.name = 'world';
    expect(attribute.name, 'title');
    expect(attribute.valueToString(), 'hello');

    final namespaceName = Identifier('svg', null);
    final elementName = Identifier('rect', null);
    final namespace = NamespaceSelector(
      namespaceName, ElementSelector(elementName, null), null,
    ).clone();
    namespaceName.name = 'other';
    elementName.name = 'circle';
    expect(namespace.toString(), 'svg|rect');
  });

  test('legacy pseudo elements retain single-colon syntax when cloned', () {
    final name = Identifier('before', null);
    final original = PseudoElementSelector(name, null, isLegacy: true);
    final copy = original.clone();
    name.name = 'after';
    expect(copy.isLegacy, isTrue);
    expect(copy.toString(), ':before');
  });

  test('functional pseudo-selector arguments are deeply cloned', () {
    final innerName = Identifier('item', null);
    final nested = Selector(
      [SimpleSelectorSequence(ClassSelector(innerName, null), null)],
      null,
    );
    final original =
        PseudoClassFunctionSelector(Identifier('host', null), nested, null);
    final copy = original.clone();
    innerName.name = 'changed';
    expect(
      (copy.argument as Selector).simpleSelectorSequences.single
          .simpleSelector.name,
      'item',
    );

    final expr = SelectorExpression([NumberTerm(2, '2', null)], null);
    final pseudo = PseudoElementFunctionSelector(
      Identifier('part', null), expr, null,
    ).clone();
    expr.expressions.clear();
    expect(pseudo.expression.expressions, hasLength(1));
  });

  test('negation argument is detached from original', () {
    final name = Identifier('className', null);
    final negative = NegationSelector(ClassSelector(name, null), null).clone();
    name.name = 'mutated';
    expect(negative.negationArg!.name, 'className');
  });
}
