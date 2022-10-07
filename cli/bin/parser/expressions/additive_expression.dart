/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../tokenizer/token.dart';
import '../../tokenizer/token_type.dart';
import '../parser_exception.dart';
import '../symbol_table.dart';
import '../penny_type.dart';
import '../../eval/penny_runtime.dart';
import 'expression.dart';

class AdditiveExpression extends Expression {
  Token operator;
  late Expression leftHandSide;
  late Expression rightHandSide;
  AdditiveExpression(
      this.operator, Expression leftHandSide, Expression rightHandSide) {
    this.leftHandSide = addChild(leftHandSide);
    this.rightHandSide = addChild(rightHandSide);
  }

  bool isAdd() {
    return operator.type == TokenType.PLUS;
  }

  @override
  PennyType getType() {
    if (leftHandSide.getType().type == PenType.STRING ||
        rightHandSide.getType().type == PenType.STRING) {
      return PennyType(PenType.STRING);
    }
    if (leftHandSide.getType().type == PenType.FLOAT ||
        rightHandSide.getType().type == PenType.FLOAT) {
      return PennyType(PenType.FLOAT);
    }
    return PennyType(PenType.INT);
  }

  @override
  Object? evaluate(PennyRuntime runtime) {
    if (getType().type == PenType.STRING) {
      String leftString = leftHandSide.evaluate(runtime).toString();
      String rightString = rightHandSide.evaluate(runtime).toString();
      return (leftString + rightString);
    }
    if (getType().type == PenType.FLOAT) {
      return (isAdd())
          ? (leftHandSide.evaluate(runtime) as double) +
              (rightHandSide.evaluate(runtime) as double)
          : (leftHandSide.evaluate(runtime) as double) -
              (rightHandSide.evaluate(runtime) as double);
    }
    return (isAdd())
        ? (leftHandSide.evaluate(runtime) as int) +
            (rightHandSide.evaluate(runtime) as int)
        : (leftHandSide.evaluate(runtime) as int) -
            (rightHandSide.evaluate(runtime) as int);
  }

  @override
  void validate(SymbolTable symboltable) {
    leftHandSide.validate(symboltable);
    rightHandSide.validate(symboltable);
    if (getType().type == PenType.INT || getType().type == PenType.FLOAT) {
      if (rightHandSide.getType().type != PenType.INT &&
          rightHandSide.getType().type != PenType.FLOAT) {
        rightHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
      if (leftHandSide.getType().type != PenType.INT &&
          leftHandSide.getType().type != PenType.FLOAT) {
        leftHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    }
    if (getType().type == PenType.STRING) {
      if (operator.type == TokenType.MINUS) {
        addError(ErrorType.INCOMPATIBLE_TYPES, []);
      } else if (![PenType.STRING, PenType.INT, PenType.NULL]
          .contains(leftHandSide.getType().type)) {
        leftHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      } else if (![PenType.STRING, PenType.INT, PenType.NULL]
          .contains(rightHandSide.getType().type)) {
        rightHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    }
  }
}
