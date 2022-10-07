/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../expressions/expression.dart';
import '../parser_exception.dart';
import '../penny_type.dart';
import '../symbol_table.dart';
import 'statement.dart';

class SwitchStatement extends Statement {
  late Expression expression;
  List<Statement> isStatements = [];
  late PennyType type;
  get getExpression => expression;

  set setExpression(expression) => this.expression = expression;

  get getIsStatement => isStatements;

  set setIsStatement(isStatement) => isStatements = isStatement;

  get getType => type;

  set setType(type) => this.type = type;

  @override
  void validate(SymbolTable symboltable) {
    expression.validate(symboltable);
    if (expression.getType().type != PenType.INT &&
        expression.getType().type != PenType.STRING) {
      expression.addError(ErrorType.INCOMPATIBLE_TYPES, []);
    }
    symboltable.pushScope();
    for (Statement statement in isStatements) {
      statement.validate(symboltable);
    }
    symboltable.popScope();
  }
}
