/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../tokenizer/token.dart';
import '../parser_exception.dart';
import '../symbol_table.dart';
import '../penny_type.dart';
import '../../eval/penny_runtime.dart';
import 'expression.dart';

class SyntaxErrorExpression extends Expression {
  SyntaxErrorExpression(Token consumeToken) {
    setToken(consumeToken);
    addError(ErrorType.UNEXPECTED_TOKEN, []);
  }
  @override
  Object? evaluate(PennyRuntime runtime) {
    // TODO: implement evaluate
    throw UnimplementedError();
  }

  @override
  PennyType getType() {
    return PennyType(PenType.OBJECT);
  }

  @override
  void validate(SymbolTable symboltable) {
    // TODO: implement validate
  }
}
