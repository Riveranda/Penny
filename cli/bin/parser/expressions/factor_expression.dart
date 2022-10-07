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
import 'dart:math';

class FactorExpression extends Expression {
  Token operator;
  late Expression leftHandSide;
  late Expression rightHandSide;

  FactorExpression(
      this.operator, Expression leftHandSide, Expression rightHandSide) {
    this.leftHandSide = addChild(leftHandSide);
    this.rightHandSide = addChild(rightHandSide);
  }

  bool isMultiply() {
    return operator.type == TokenType.STAR;
  }

  bool isDivide() {
    return operator.type == TokenType.SLASH;
  }

  bool isBinAnd() {
    return operator.type == TokenType.BINAND;
  }

  bool isBinLeftShift() {
    return operator.type == TokenType.BINLEFTSHIFT;
  }

  bool isBinOr() {
    return operator.type == TokenType.BINOR;
  }

  bool isBinRightShift() {
    return operator.type == TokenType.BINRIGHTSHIFT;
  }

  bool isBinXor() {
    return operator.type == TokenType.BINXOR;
  }

  bool isMod() {
    return operator.type == TokenType.MOD;
  }

  bool isBool() {
    return operator.type == TokenType.AND || operator.type == TokenType.OR;
  }

  bool isAnd() {
    return operator.type == TokenType.AND;
  }

  bool isStarStar() {
    return operator.type == TokenType.STARSTAR;
  }

  @override
  Object? evaluate(PennyRuntime runtime) {
    if (isBool()) {
      return (isAnd())
          ? (leftHandSide.evaluate(runtime) as bool) &&
              (rightHandSide.evaluate(runtime) as bool)
          : (leftHandSide.evaluate(runtime) as bool) ||
              (rightHandSide.evaluate(runtime) as bool);
    }
    if (isMultiply()) {
      if (getType().type == PenType.FLOAT) {
        double rhs = (rightHandSide.evaluate(runtime) as double);
        double lhs = (leftHandSide.evaluate(runtime) as double);
        return lhs * rhs;
      } else {
        int rhs = (rightHandSide.evaluate(runtime) as int);
        int lhs = (leftHandSide.evaluate(runtime) as int);
        return lhs * rhs;
      }
    }
    if (isDivide()) {
      if (getType().type == PenType.FLOAT) {
        double rhs = (rightHandSide.evaluate(runtime) as double);
        double lhs = (leftHandSide.evaluate(runtime) as double);
        return lhs / rhs;
      } else {
        int rhs = (rightHandSide.evaluate(runtime) as int);
        int lhs = (leftHandSide.evaluate(runtime) as int);
        return lhs / rhs;
      }
    }
    if (isMod()) {
      int rhs = (rightHandSide.evaluate(runtime) as int);
      int lhs = (leftHandSide.evaluate(runtime) as int);
      return lhs % rhs;
    }
    if (isBinAnd()) {
      int rhs = (rightHandSide.evaluate(runtime) as int);
      int lhs = (leftHandSide.evaluate(runtime) as int);
      return lhs & rhs;
    }
    if (isBinOr()) {
      int rhs = (rightHandSide.evaluate(runtime) as int);
      int lhs = (leftHandSide.evaluate(runtime) as int);
      return lhs | rhs;
    }
    if (isBinXor()) {
      int rhs = (rightHandSide.evaluate(runtime) as int);
      int lhs = (leftHandSide.evaluate(runtime) as int);
      return lhs ^ rhs;
    }
    if (isBinLeftShift()) {
      int rhs = (rightHandSide.evaluate(runtime) as int);
      int lhs = (leftHandSide.evaluate(runtime) as int);
      return lhs << rhs;
    }
    if (isStarStar()) {
      if (getType().type == PenType.FLOAT) {
        double rhs = (rightHandSide.evaluate(runtime) as double);
        double lhs = (leftHandSide.evaluate(runtime) as double);
        return pow(lhs, rhs);
      } else {
        int rhs = (rightHandSide.evaluate(runtime) as int);
        int lhs = (leftHandSide.evaluate(runtime) as int);
        return pow(lhs, rhs);
      }
    } else {
      int rhs = (rightHandSide.evaluate(runtime) as int);
      int lhs = (leftHandSide.evaluate(runtime) as int);
      return lhs >> rhs;
    }
  }

  @override
  PennyType getType() {
    if (isBool()) {
      return PennyType(PenType.BOOLEAN);
    }
    if (leftHandSide.getType().type == PenType.FLOAT ||
        rightHandSide.getType().type == PenType.FLOAT) {
      return PennyType(PenType.FLOAT);
    }
    return PennyType(PenType.INT);
  }

  @override
  void validate(SymbolTable symboltable) {
    leftHandSide.validate(symboltable);
    rightHandSide.validate(symboltable);
    if (isBool()) {
      if (leftHandSide.getType().type != PenType.BOOLEAN ||
          rightHandSide.getType().type != PenType.BOOLEAN) {
        addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    } else if (isMultiply() || isDivide() || isStarStar()) {
      if (leftHandSide.getType().type != PenType.INT &&
          leftHandSide.getType().type != PenType.FLOAT) {
        leftHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
      if (rightHandSide.getType().type != PenType.INT &&
          rightHandSide.getType().type != PenType.FLOAT) {
        rightHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    } else {
      if (leftHandSide.getType().type != PenType.INT) {
        leftHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
      if (rightHandSide.getType().type != PenType.INT) {
        rightHandSide.addError(ErrorType.INCOMPATIBLE_TYPES, []);
      }
    }
  }
}
