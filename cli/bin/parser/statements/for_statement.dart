/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../expressions/expression.dart';
import '../expressions/range_expression.dart';
import '../parser_exception.dart';
import '../penny_type.dart';
import '../symbol_table.dart';
import 'statement.dart';

class ForStatement extends Statement {
  late Expression expression;
  late String variableName;
  List<Statement>? body;
  get getExpression => expression;

  set setExpression(expression) => this.expression = expression;

  get getVariableName => variableName;

  set setVariableName(variableName) => this.variableName = variableName;

  get getBody => body;

  set setBody(body) => this.body = body;

  @override
  void validate(SymbolTable symboltable) {
    symboltable.pushScope();
    if (symboltable.hasSymbol(variableName)) {
      addError(ErrorType.DUPLICATE_NAME, []);
    } else {
      expression.validate(symboltable);
      PenType type = expression.getType().type;
      if (expression is RangeExpression) {
        symboltable.registerSymbol(variableName, getcomponenetType());
      } else {
        addError(ErrorType.INCOMPATIBLE_TYPES, []);
        symboltable.registerSymbol(variableName, PennyType(PenType.OBJECT));
      }
    }
  }

  PennyType getcomponenetType() {
    return null!;
  }
}
