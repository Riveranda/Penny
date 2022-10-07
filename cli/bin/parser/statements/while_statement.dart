/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../tokenizer/token.dart';
import '../expressions/expression_imports.dart';
import '../parser_exception.dart';
import '../symbol_table.dart';
import 'statement.dart';

class WhileStatement extends Statement {
  late Expression expression;
  late List<Statement> body;
  late Token variableName;
  Token get getVariableName => variableName;

 set setVariableName(Token variableName) => this.variableName = variableName;
  get getExpression => expression;

  set setExpression(expression) => this.expression = expression;

  get getBody => body;

  set setBody(body) => this.body = body;

  @override
  void validate(SymbolTable symboltable) {
    symboltable.pushScope();
    expression.validate(symboltable);
    if (expression is! EqualityExpression ||
        expression is! BooleanLiteralExpression ||
        expression is! ComparisonExpression) {
      addError(ErrorType.INCOMPATIBLE_TYPES, []);
    }

    for (Statement statement in body) {
      statement.validate(symboltable);
    }

    symboltable.popScope();
  }
}
