/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../parser_exception.dart';
import '../symbol_table.dart';
import '../penny_type.dart';
import '../../eval/penny_runtime.dart';
import 'expression.dart';

class RangeExpression extends Expression {
  RangeExpression();

  late List<Expression> control;

  void setControl(List<Expression> control) {
    this.control = control;
  }

  @override
  Object? evaluate(PennyRuntime runtime) {
    List<int> ints = [];
    for (var expression in control) {
      ints.add(expression.evaluate(runtime) as int);
    }
    return ints;
  }

  @override
  PennyType getType() {
    return PennyType(PenType.INT);
  }

  @override
  void validate(SymbolTable symboltable) {
    for (var exp in control) {
      if (exp.getType().type != PenType.INT) {
        addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    }
    if (control.isEmpty || control.length > 3) {
      addError(ErrorType.UNEXPECTED_TOKEN, []);
    }
  }
}
