/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'package:test/test.dart';
import '../../bin/master_imports.dart';
import 'dart:math';

void main() {
  testAdditionExpression();
  testUnaryExpression();
  testFactorExpression();
  testEqualityExpression();
  testRecallForgetExpressions();
  testComparisonExpression();
}

PennyParser parser = PennyParser();
Expression updateSrc(String src) {
  parser.tokens = PennyTokenizer(src).getTokens;
  return parser.parseExpression();
}

void testComparisonExpression() {
  test("testLessThanExpression", () {
    var runtime = PennyRuntime();
    var expression = updateSrc("5 < 6");
    expect(expression is ComparisonExpression, true);
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("6 < 5");
    expect(expression.evaluate(runtime), false);

    expression = updateSrc("5 < 6.5");
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("6.5 < 5");
    expect(expression.evaluate(runtime), false);
  });
  test("testLessThanOrEqualExpression", () {
    var runtime = PennyRuntime();
    var expression = updateSrc("5 <= 6");
    expect(expression is ComparisonExpression, true);
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("6 <= 6");
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("6 <= 5");
    expect(expression.evaluate(runtime), false);

    expression = updateSrc("5 <= 6.5");
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("6.5 <= 5");
    expect(expression.evaluate(runtime), false);

    expression = updateSrc("6.5 <= 6.5");
    expect(expression.evaluate(runtime), true);
  });

  test("testGreaterThanExpression", () {
    var runtime = PennyRuntime();
    var expression = updateSrc("6 > 5");
    expect(expression is ComparisonExpression, true);
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("5 > 6");
    expect(expression.evaluate(runtime), false);

    expression = updateSrc("6.5 > 5");
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("5 > 6.5");
    expect(expression.evaluate(runtime), false);
  });

  test("testGreaterThanOrEqualExpression", () {
    var runtime = PennyRuntime();
    var expression = updateSrc("6 >= 5");
    expect(expression is ComparisonExpression, true);
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("6 >= 6");
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("5 >= 6");
    expect(expression.evaluate(runtime), false);

    expression = updateSrc("6.5 >= 5");
    expect(expression.evaluate(runtime), true);

    expression = updateSrc("5 >= 6.5");
    expect(expression.evaluate(runtime), false);

    expression = updateSrc("6.5 >= 6.5");
    expect(expression.evaluate(runtime), true);
  });
}

void testRecallForgetExpressions() {
  test("testRecallExpression", () {
    PennyRuntime runtime = PennyRuntime();
    runtime.setGlobalStorage = "hello";
    var expression = updateSrc("recall");
    expect(expression is RecallExpression, true);
    expect(expression.evaluate(runtime), "hello");
    expect(runtime.getGlobalStorage != null, true);
  });

  test("testForgetExpression", () {
    PennyRuntime runtime = PennyRuntime();
    runtime.setGlobalStorage = "hello";
    var expression = updateSrc("forget");
    expect(expression is ForgetExpression, true);
    expect(expression.evaluate(runtime), "hello");
    expect(runtime.getGlobalStorage == null, true);
  });
}

void testEqualityExpression() {
  test("testEqualityExpression", () {
    var expression = updateSrc("5 == 1");
    expect(expression is EqualityExpression, true);
    expect(expression.evaluate(PennyRuntime()), false);

    expression = updateSrc("true == true");
    expect(expression is EqualityExpression, true);
    expect(expression.evaluate(PennyRuntime()), true);
  });
}

void testFactorExpression() {
  test("testMultiplyExpression", () {
    var expression = updateSrc("5 * 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 25);

    expression = updateSrc("5.5 * -5.5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.FLOAT);
    expect(expression.evaluate(PennyRuntime()), 5.5 * -5.5);
  });

  test("testDivideExpression", () {
    var expression = updateSrc("5 / 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 5 / 5);

    expression = updateSrc("5.5 / -5.5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.FLOAT);
    expect(expression.evaluate(PennyRuntime()), 5.5 / -5.5);
  });

  test("testExponentExpression", () {
    var expression = updateSrc("5 ** 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), pow(5, 5));

    expression = updateSrc("5.5 ** -5.5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.FLOAT);
    expect(expression.evaluate(PennyRuntime()), pow(5.5, -5.5));
  });

  test("testModulusExpression", () {
    var expression = updateSrc("5 % 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 5 % 5);
  });

  test("testOrExpression", () {
    var expression = updateSrc("true or !true");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.BOOLEAN);
    expect(expression.evaluate(PennyRuntime()), true);
  });

  test("testAndExpression", () {
    var expression = updateSrc("false and true");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.BOOLEAN);
    expect(expression.evaluate(PennyRuntime()), false);
  });

  test("testBinAndExpression", () {
    var expression = updateSrc("5 & 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 5 & 5);
  });

  test("testBinLeftShiftExpression", () {
    var expression = updateSrc("5 << 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 5 << 5);
  });

  test("testBinRightShiftExpression", () {
    var expression = updateSrc("5 >> 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 5 >> 5);
  });

  test("testBinOrExpression", () {
    var expression = updateSrc("5 | 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 5 | 5);
  });

  test("testBinXorExpression", () {
    var expression = updateSrc("5 ^ 5");
    expect(expression is FactorExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 5 ^ 5);
  });
}

void testUnaryExpression() {
  test("testUnaryExpression", () {
    var expression = updateSrc("!false");
    expect(expression is UnaryExpression, true);
    expect(expression.getType().type, PenType.BOOLEAN);
    expect(expression.evaluate(PennyRuntime()), true);

    expression = updateSrc("-(5+2)");
    expect(expression is UnaryExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), -7);

    expression = updateSrc("~5");
    expect(expression is UnaryExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), ~5); //~x = -x - 1 for all Z
  });
}

void testAdditionExpression() {
  test("additionExpressionEvaluate", () {
    var expression = updateSrc("5 + 5");
    expect(expression is AdditiveExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 10);

    expression = updateSrc("5 - 3");
    expect(expression is AdditiveExpression, true);
    expect(expression.getType().type, PenType.INT);
    expect(expression.evaluate(PennyRuntime()), 2);

    expression = updateSrc("5.2 + 5.2");
    expect(expression is AdditiveExpression, true);
    expect(expression.getType().type, PenType.FLOAT);
    expect(expression.evaluate(PennyRuntime()), 10.4);

    expression = updateSrc("5.2 - 5.1");
    expect(expression is AdditiveExpression, true);
    expect(expression.getType().type, PenType.FLOAT);
    expect(expression.evaluate(PennyRuntime()), closeTo(0.1, 0.000000001));

    expression = updateSrc("\"Hi\" + \"There\"");
    expect(expression is AdditiveExpression, true);
    expect(expression.getType().type, PenType.STRING);
    expression.validate(SymbolTable());
    expect(expression.evaluate(PennyRuntime()), "HiThere");
  });
}
