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

class UnaryExpression extends Expression {
  Token operator;
  late Expression expression;
  Token get getOperator => operator;

  set setOperator(Token operator) => this.operator = operator;

  get getExpression => expression;

  set setExpression(expression) => this.expression = expression;
  UnaryExpression(this.operator, Expression expression) {
    this.expression = addChild(expression);
  }

  bool isMinus() {
    return operator.type == TokenType.MINUS;
  }

  bool isNot() {
    return operator.type == TokenType.NOT;
  }


  @override
  Object? evaluate(PennyRuntime runtime) {
    Object value = expression.evaluate(runtime)!;
    if (isMinus()) {
      if (getType().type == PenType.INT) {
        return -1 * (value as int);
      } else {
        return -1 * (value as double);
      }
    } else if (isNot()) {
      return !(value as bool);
    } else {
      return ~(value as int);
    }
  }

  @override
  PennyType getType() {
    return expression.getType();
  }

  @override
  void validate(SymbolTable symboltable) {
    expression.validate(symboltable);
    if (isNot() && expression.getType().type != PenType.BOOLEAN) {
      addError(ErrorType.INCOMPATIBLE_TYPES, []);
    } else if (isMinus() && expression.getType().type != PenType.INT) {
      addError(ErrorType.INCOMPATIBLE_TYPES, []);
    }
  }
}
