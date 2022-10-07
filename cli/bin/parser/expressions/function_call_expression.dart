/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../symbol_table.dart';
import '../penny_type.dart';
import '../../eval/penny_runtime.dart';
import 'expression.dart';

class FunctionCallExpression extends Expression {
  final String name;
  late List<Expression> arguments;
  FunctionCallExpression(this.name, List<Expression> arguments) {
    for (var arg in arguments) {
      this.arguments.add(addChild(arg));
    }
  }

  @override
  Object? evaluate(PennyRuntime runtime) {
    // TODO: implement evaluate
    throw UnimplementedError();
  }

  @override
  PennyType getType() {
    // TODO: implement getType
    throw UnimplementedError();
  }

  @override
  void validate(SymbolTable symboltable) {
    // TODO: implement validate
  }
}
