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

class ComparisonExpression extends Expression {
  Token operator;
  late Expression leftHandSide;
  late Expression rightHandSide;

  ComparisonExpression(
      this.operator, Expression leftHandSide, Expression rightHandSide) {
    this.leftHandSide = addChild(leftHandSide);
    this.rightHandSide = addChild(rightHandSide);
  }

  bool isLess() {
    return operator.type == TokenType.LESS;
  }

  bool isLessEqual() {
    return operator.type == TokenType.LESS_EQUAL;
  }

  bool isGreater() {
    return operator.type == TokenType.GREATER;
  }

  bool isGreaterEqual() {
    return operator.type == TokenType.GREATER_EQUAL;
  }

  @override
  Object? evaluate(PennyRuntime runtime) {
    Object lhs = leftHandSide.evaluate(runtime)!;
    Object rhs = rightHandSide.evaluate(runtime)!;
    
    bool lhi = lhs is int, rhi = rhs is int;

    if (isGreater()) {
      return ((lhi) ? lhs : (lhs as double)) >
          ((rhi) ? rhs : (rhs as double));
    }
    if (isLess()) {
      return ((lhi) ? lhs : (lhs as double)) <
          ((rhi) ? rhs : (rhs as double));
    }
    if (isGreaterEqual()) {
      return ((lhi) ? (lhs as int) : (lhs as double)) >=
          ((rhi) ? (rhs as int) : (rhs as double));
    }
    if (isLessEqual()) {
      return ((lhi) ? (lhs as int) : (lhs as double)) <=
          ((rhi) ? (rhs as int) : (rhs as double));
    }
    return false;
  }

  @override
  PennyType getType() {
    return PennyType(PenType.BOOLEAN);
  }

  @override
  void validate(SymbolTable symboltable) {
    leftHandSide.validate(symboltable);
    rightHandSide.validate(symboltable);
    if (leftHandSide.getType().type != PenType.INT &&
        leftHandSide.getType().type != PenType.FLOAT) {
      leftHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
    }
    if (rightHandSide.getType().type != PenType.INT &&
        rightHandSide.getType().type != PenType.FLOAT) {
      rightHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
    }
  }
}
