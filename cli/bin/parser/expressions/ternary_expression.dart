/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../master_imports.dart';

class TernaryExpression extends Expression {
  late ParenthesizedExpression parenthesizedExpression;
  late Expression trueExpression;
  late Expression falseExpression;

  set setParenthesizedExpression(
          ParenthesizedExpression parenthesizedExpression) =>
      this.parenthesizedExpression = parenthesizedExpression;

  set setTrueExpression(trueExpression) => this.trueExpression = trueExpression;

  set setFalseExpression(falseExpression) =>
      this.falseExpression = falseExpression;

  TernaryExpression();

  @override
  Object? evaluate(PennyRuntime runtime) {
    return (parenthesizedExpression.evaluate(runtime) as bool)
        ? trueExpression.evaluate(runtime)
        : falseExpression.evaluate(runtime);
  }

  @override
  PennyType getType() {
    return (trueExpression.getType() == falseExpression.getType())
        ? trueExpression.getType()
        : PennyType(PenType.OBJECT);
  }

  @override
  void validate(SymbolTable symboltable) {
    parenthesizedExpression.validate(symboltable);
    trueExpression.validate(symboltable);
    falseExpression.validate(symboltable);
  }
}
