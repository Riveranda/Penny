/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../expressions/expression.dart';
import '../parser_exception.dart';
import '../penny_type.dart';
import '../symbol_table.dart';
import 'statement.dart';

class AssignmentStatement extends Statement {
  late Expression expression;
  late String variableName;
  Expression get getExpression => expression;
  List<Expression>? arrayIndex;

  set setArrayIndex(List<Expression> arrayIndex) => this.arrayIndex = arrayIndex;

  set setExpression(Expression expression) => this.expression = expression;

  get getVariableName => variableName;

  set setVariableName(String s) => variableName = s;

  @override
  void validate(SymbolTable symboltable) {
    expression.validate(symboltable);
    PenType? pennyType = symboltable.getSymbolType(getVariableName);
    if (pennyType == null){
      addError(ErrorType.UNKNOWN_NAME, []);
    }
    else{
      if (pennyType != expression.getType().type && arrayIndex == null){
        addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    }
  }
}
