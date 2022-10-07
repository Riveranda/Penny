/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'package:test/test.dart';
import '../../bin/master_imports.dart';

void main() {
  testParseTypeLiteral();
  testParsePrimaryExpression();
  testParseComplexExpressions();
}

final PennyParser parser = PennyParser();
late Expression expression;
late TypeLiteral typeLiteral;
void updateSrc(String src) {
  parser.tokens = PennyTokenizer(src).getTokens;
}

void parsePrimaryExpression() {
  expression = parser.parsePrimaryExpression();
}

void parseTypeLiteral() {
  typeLiteral = parser.parseTypeLiteral();
}

void testParseComplexExpressions() {
  test("testParseRangeExpression", () {
    updateSrc("range(2)");
    expression = parser.parseRangeExpression();
    expect(expression is RangeExpression, true);
    expect((expression as RangeExpression).control.length, 1);
    updateSrc("range(2, 3, 4)");
    expression = parser.parseRangeExpression();
    expect(expression is RangeExpression, true);
    expect((expression as RangeExpression).control.length, 3);
  });

  test("testParseComparisonExpression", () {
    updateSrc("5>4");
    expression = parser.parseComparisonExpression();
    expect(expression is ComparisonExpression, true);
    expect(
        (expression as ComparisonExpression).operator.type, TokenType.GREATER);

    updateSrc("5<4");
    expression = parser.parseComparisonExpression();
    expect(expression is ComparisonExpression, true);
    expect((expression as ComparisonExpression).operator.type, TokenType.LESS);

    updateSrc("5>=4");
    expression = parser.parseComparisonExpression();
    expect(expression is ComparisonExpression, true);
    expect((expression as ComparisonExpression).operator.type,
        TokenType.GREATER_EQUAL);

    updateSrc("5<=4");
    expression = parser.parseComparisonExpression();
    expect(expression is ComparisonExpression, true);
    expect((expression as ComparisonExpression).operator.type,
        TokenType.LESS_EQUAL);
  });

  test("testEqualityExpression", () {
    updateSrc("5==2");
    expression = parser.parseEqualityExpression();
    expect(expression is EqualityExpression, true);

    expect((expression as EqualityExpression).operator.type,
        TokenType.EQUAL_EQUAL);

    expect((expression as EqualityExpression).leftHandSide.getType().type,
        PenType.INT);
    expect((expression as EqualityExpression).rightHandSide.getType().type,
        PenType.INT);

    expect(
        (expression as EqualityExpression).leftHandSide.start.stringValue, "5");
    expect((expression as EqualityExpression).rightHandSide.start.stringValue,
        "2");

    updateSrc("5!=2");
    expression = parser.parseEqualityExpression();
    expect(expression is EqualityExpression, true);

    expect(
        (expression as EqualityExpression).operator.type, TokenType.BANG_EQUAL);

    expect((expression as EqualityExpression).leftHandSide.start.type,
        TokenType.INTEGER);
    expect((expression as EqualityExpression).rightHandSide.start.type,
        TokenType.INTEGER);

    expect(
        (expression as EqualityExpression).leftHandSide.start.stringValue, "5");
    expect((expression as EqualityExpression).rightHandSide.start.stringValue,
        "2");
  });

  test("testAdditiveExpression", () {
    updateSrc("5+1");
    expression = parser.parseAdditiveExpression();
    expect(expression is AdditiveExpression, true);

    expect((expression as AdditiveExpression).operator.type, TokenType.PLUS);

    expect((expression as AdditiveExpression).leftHandSide.start.type,
        TokenType.INTEGER);
    expect((expression as AdditiveExpression).rightHandSide.start.type,
        TokenType.INTEGER);

    expect(
        (expression as AdditiveExpression).leftHandSide.start.stringValue, "5");
    expect((expression as AdditiveExpression).rightHandSide.start.stringValue,
        "1");

    updateSrc("5-1");
    expression = parser.parseAdditiveExpression();
    expect(expression is AdditiveExpression, true);
    expect((expression as AdditiveExpression).operator.type, TokenType.MINUS);

    expect((expression as AdditiveExpression).leftHandSide.start.type,
        TokenType.INTEGER);
    expect((expression as AdditiveExpression).rightHandSide.start.type,
        TokenType.INTEGER);

    expect(
        (expression as AdditiveExpression).leftHandSide.start.stringValue, "5");
    expect((expression as AdditiveExpression).rightHandSide.start.stringValue,
        "1");
  });

  test("parseStringAdditiveExpression", () {
    updateSrc("\"Hello\" + \"Hi\"");
    var expression = parser.parseAdditiveExpression();
    expect(expression is AdditiveExpression, true);
    expression = expression as AdditiveExpression;
    expect(expression.leftHandSide is StringLiteralExpression, true);
    expect(expression.rightHandSide is StringLiteralExpression, true);
    expect(expression.operator.type, TokenType.PLUS);
  });

  test("testParseFactorExpression", () {
    updateSrc("5*3");
    expression = parser.parseFactorExpression();
    expect(expression is FactorExpression, true);

    expect((expression as FactorExpression).operator.type, TokenType.STAR);

    expect((expression as FactorExpression).leftHandSide.start.type,
        TokenType.INTEGER);
    expect((expression as FactorExpression).rightHandSide.start.type,
        TokenType.INTEGER);

    expect(
        (expression as FactorExpression).leftHandSide.start.stringValue, "5");
    expect(
        (expression as FactorExpression).rightHandSide.start.stringValue, "3");
  });

  test("testParseUnaryExpression", () {
    updateSrc("-x");
    expression = parser.parseUnaryExpression();
    expect(expression is UnaryExpression, true);

    expect((expression as UnaryExpression).expression is IdentifierExpression,
        true);
    expect(
        ((expression as UnaryExpression).expression as IdentifierExpression)
            .name,
        "x");
    expect((expression as UnaryExpression).operator.type, TokenType.MINUS);

    updateSrc("not true");
    expression = parser.parseUnaryExpression();
    expect(expression is UnaryExpression, true);
    expect(
        (expression as UnaryExpression).expression is BooleanLiteralExpression,
        true);
    expect(
        ((expression as UnaryExpression).expression as BooleanLiteralExpression)
            .boolValue,
        true);
    expect((expression as UnaryExpression).operator.type, TokenType.NOT);
  });

  test("testParseTernaryExpression", () {
    updateSrc("(true == false) ? \"Wee\" : \"Woo\"");
    expression = parser.parsePrimaryExpression();
    expect(expression is TernaryExpression, true);
    expect(
        (expression as TernaryExpression).parenthesizedExpression.expression
            is EqualityExpression,
        true);

    expect((expression as TernaryExpression).trueExpression.getType().type,
        PenType.STRING);
    expect((expression as TernaryExpression).falseExpression.getType().type,
        PenType.STRING);

    expect(
        ((expression as TernaryExpression).trueExpression
                as StringLiteralExpression)
            .string,
        "Wee");
    expect(
        ((expression as TernaryExpression).falseExpression
                as StringLiteralExpression)
            .string,
        "Woo");
  });
}

void testParsePrimaryExpression() {
  test("testintegerliteralexpression", () {
    updateSrc("1236");
    parsePrimaryExpression();
    expect(expression is IntegerLiteralExpression, true);
    expect((expression as IntegerLiteralExpression).integerVal, 1236);
  });

  test("testfloatliteralexpression", () {
    updateSrc("12.36");
    parsePrimaryExpression();
    expect(expression is FloatLiteralExpression, true);
    expect((expression as FloatLiteralExpression).floatVal, 12.36);
  });
  test("teststringliteralexpresion", () {
    updateSrc("\"bacon\"");
    parsePrimaryExpression();
    expect(expression is StringLiteralExpression, true);
    expect((expression as StringLiteralExpression).string, "bacon");
  });

  test("parseidentifierexpression", () {
    updateSrc("hello_human");
    parsePrimaryExpression();
    expect(expression is IdentifierExpression, true);
    expect((expression as IdentifierExpression).name, "hello_human");
  });

  test("parsebooleanliteral", () {
    updateSrc("false");
    parsePrimaryExpression();
    expect(expression is BooleanLiteralExpression, true);
    expect((expression as BooleanLiteralExpression).boolValue, false);

    updateSrc("true");
    parsePrimaryExpression();
    expect(expression is BooleanLiteralExpression, true);
    expect((expression as BooleanLiteralExpression).boolValue, true);
  });

  test("nullliteralexpression", () {
    updateSrc("null");
    parsePrimaryExpression();
    expect(expression is NullLiteralExpression, true);
  });
  // TODO List literal expression
  // test("listliteralexpression", (){
  //   updateSrc("list[1,2,\"Hello\"]");
  //   parsePrimaryExpression();
  //   expect(expression is ListLiteralExpression, true);
  //   expect((expression as ListLiteralExpression).values.length, 3);
  // });

  test("testparenthesizedexpression", () {
    updateSrc("(1)");
    parsePrimaryExpression();
    expect(expression is ParenthesizedExpression, true);
    expect(
        ((expression as ParenthesizedExpression).expression
                as IntegerLiteralExpression)
            .integerVal,
        1);
  });
}

void testParseTypeLiteral() {
  test("testintliteral", () {
    updateSrc("int");
    parseTypeLiteral();
    expect(typeLiteral.type.type, PenType.INT);
  });

  test("teststringliteral", () {
    updateSrc("string");
    parseTypeLiteral();
    expect(typeLiteral.type.type, PenType.STRING);
  });

  test("testboolliteral", () {
    updateSrc("bool");
    parseTypeLiteral();
    expect(typeLiteral.type.type, PenType.BOOLEAN);
  });

  test("testobjectliteral", () {
    updateSrc("object");
    parseTypeLiteral();
    expect(typeLiteral.type.type, PenType.OBJECT);
  });

  test("testlistliteral", () {
    updateSrc("list");
    parseTypeLiteral();
    expect(typeLiteral.type.type, PenType.OBJECT);
    expect(typeLiteral.type is ListType, true);
    updateSrc("list<int>");
    parseTypeLiteral();
    expect(typeLiteral.type.type, PenType.INT);
    expect(typeLiteral.type is ListType, true);
  });

  test("testfloatliteral", () {
    updateSrc("float");
    parseTypeLiteral();
    expect(typeLiteral.type.type, PenType.FLOAT);
  });
}
