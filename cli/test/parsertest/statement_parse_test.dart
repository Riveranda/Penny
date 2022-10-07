/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'package:test/test.dart';
import '../../bin/master_imports.dart';

void main() {
  testForStatement();
  testIfStatement();
  testWhileStatement();
  testDoWhileStatement();
  testSwitchStatement();
  testReturnStatement();
  testVarStatement();
}

PennyParser parser = PennyParser();
void updateSrc(String src) {
  parser.tokens = PennyTokenizer(src).getTokens;
}

void testVarStatement() {
  test("testVarStatement", () {
    updateSrc("var x = 5");
    var statement = parser.parseVarStatement();
    expect(statement.getExplicitType, null);
    expect(statement.expression.getType().type, PenType.INT);
    expect(statement.variableName, "x");

    updateSrc("var x: int = 5");
    statement = parser.parseVarStatement();
    expect(statement.explicitType!.type, PenType.INT);
    expect(statement.variableName, "x");
  });
}

void testReturnStatement() {
  test("testReturnStatement", () {
    updateSrc("return x + 5");
    var statement = parser.parseReturnStatement();
    expect(statement.expression is AdditiveExpression, true);
    updateSrc("-> x + 5");
    statement = parser.parseReturnStatement();
    expect(statement.expression is AdditiveExpression, true);
  });
}

void testSwitchStatement() {
  test("testSwitchStatement", () {
    updateSrc("switch(5){is 1, 5{ var x = 50} is 1,2{} def{}}");
    var statement = parser.parseSwitchStatement();
    expect(statement.isStatements.length, 3);
    expect((statement.isStatements.first as IsStatement).matches.length, 2);
    expect(
        (statement.isStatements.first as IsStatement).trueStatements.length, 1);
    expect(
        (statement.isStatements.first as IsStatement).trueStatements.first
            is VariableStatement,
        true);
    expect(
        ((statement.isStatements.first as IsStatement).trueStatements.first
                as VariableStatement)
            .variableName,
        "x");
    expect((statement.isStatements.last as IsStatement).isDefault(), true);
  });
}

void testDoWhileStatement() {
  test("testDoWhileStatement", () {
    updateSrc("do x {}while(true)");
    var statement = parser.parseDoWhileStatement();
    expect(statement.variableName.stringValue, "x");
    expect(statement.expression is BooleanLiteralExpression, true);
    expect((statement.expression as BooleanLiteralExpression).boolValue, true);
  });
}

void testWhileStatement() {
  test("testWhileStatement", () {
    updateSrc("while(true, x){}");
    var statement = parser.parseWhileStatement();
    expect(statement.variableName.stringValue, "x");
    expect(statement.expression is BooleanLiteralExpression, true);
    expect((statement.expression as BooleanLiteralExpression).boolValue, true);
  });
}

void testIfStatement() {
  test("testIfStatement", () {
    updateSrc("if (5 == 4){return 5} else if (3 == 2){} else {}");
    var statement = parser.parseIfStatement();
    expect(statement.elseStatements.length, 1);
    expect(statement.trueStatements.length, 1);
  });
}

void testForStatement() {
  test("testRangeFor", () {
    updateSrc("for i in range(5){}");
    var statement = parser.parseForStatement();
    expect(statement is ForStatement, true);
    statement = statement as ForStatement;
    expect(statement.expression is RangeExpression, true);
    expect(
        (statement.expression as RangeExpression).control.elementAt(0)
            is IntegerLiteralExpression,
        true);
    expect(
        (((statement.expression as RangeExpression).control.elementAt(0))
                as IntegerLiteralExpression)
            .integerVal,
        5);
  });

  test("testfullrange", () {
    updateSrc("for(i in range(5, 4, 3)){}");
    var statement = parser.parseForStatement();
    expect(statement is ForStatement, true);
    statement = statement as ForStatement;
    expect(statement.expression is RangeExpression, true);
    int x = 0;
    for (var i = 5; i > 4; i -= 3) {
      expect(
          (statement.expression as RangeExpression).control.elementAt(x)
              is IntegerLiteralExpression,
          true);
      expect(
          (((statement.expression as RangeExpression).control.elementAt(x))
                  as IntegerLiteralExpression)
              .integerVal,
          i);
      x++;
    }
  });
}
