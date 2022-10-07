/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../expressions/expression.dart';
import '../parser_exception.dart';
import '../penny_type.dart';
import '../symbol_table.dart';
import 'statement_imports.dart';

class ReturnStatement extends Statement {
  late Expression? expression;
  late FunctionDefinitionStatement? function;
  get getExpression => expression;

  set setExpression(expression) => this.expression = expression;

  get getFunction => function;

  set setFunction(function) => this.function = function;

  @override
  void validate(SymbolTable symboltable) {
    if (expression != null && function != null) {
      expression!.validate(symboltable);
      if (!function!.getType!.isAssignableFrom(expression!.getType().type)) {
        expression!.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    } else {
      if (function!.getType!.type == PenType.VOID) {
        addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    }
  }
}
