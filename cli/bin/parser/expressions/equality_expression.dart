/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../tokenizer/token.dart';
import '../../tokenizer/token_type.dart';
import '../symbol_table.dart';
import '../penny_type.dart';
import '../../eval/penny_runtime.dart';
import 'expression.dart';

class EqualityExpression extends Expression {
  final Token operator;
  late Expression leftHandSide;
  late Expression rightHandSide;

  EqualityExpression(
      this.operator, Expression leftHandSide, Expression rightHandSide) {
    this.leftHandSide = addChild(leftHandSide);
    this.rightHandSide = addChild(rightHandSide);
  }

  bool isEqual() {
    return operator.type == TokenType.EQUAL_EQUAL;
  }

  @override
  Object? evaluate(PennyRuntime runtime) {
    return isEqual() ==
        (rightHandSide.evaluate(runtime) == leftHandSide.evaluate(runtime));
  }

  @override
  PennyType getType() {
    return PennyType(PenType.BOOLEAN);
  }

  @override
  void validate(SymbolTable symboltable) {
    leftHandSide.validate(symboltable);
    rightHandSide.validate(symboltable);
  }
}
