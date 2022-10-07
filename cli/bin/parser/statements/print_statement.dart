/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../master_imports.dart';

class PrintStatement extends Statement {
  late Expression expression;
  get getExpression => expression;

  set setExpression(expression) => this.expression = expression;

  @override
  void execute(PennyRuntime runtime) {
    print(expression.evaluate(runtime));
  }

  @override
  void validate(SymbolTable symboltable) {
    expression.validate(symboltable);
  }
}
